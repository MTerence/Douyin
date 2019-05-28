//
//  CMVideoPlayer.m
//  Douyin
//
//  Created by Ternence on 2019/5/27.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "CMVideoPlayer.h"
#import "DYCacheTool.h"
//#import "WebCacheHelpler.h"
#import "CMVideoPlayerManager.h"

@interface CMVideoPlayer ()<NSURLSessionTaskDelegate, NSURLSessionDataDelegate, AVAssetResourceLoaderDelegate>

@property (nonatomic, strong) NSURL                 *sourceURL;         //视频路径
@property (nonatomic, strong) NSString              *sourceScheme;   //路径scheme
@property (nonatomic, strong) AVURLAsset            *urlAsset; //视频资源
@property (nonatomic, strong) AVPlayerItem          *playerItem; //视频资源载体
@property (nonatomic, strong) AVPlayer              *player;        //视频播放器
@property (nonatomic, strong) AVPlayerLayer         *playerLayer;   //视频播放器图形化载体
@property (nonatomic, strong) id                    timeObserver;  //视频播放器周期性调用的观察者

@property (nonatomic, strong) NSMutableData         *data;  //视频缓冲数据
@property (nonatomic, copy)   NSString              *mimeType;     //资源格式
@property (nonatomic, assign) long long             expectedContentLength;  //资源大小
@property (nonatomic, strong) NSMutableArray        *pendingRequests;  //存储AVAssetResourceLoadingRequest的数组

@property (nonatomic, copy)   NSString              *cacheFileKey;     //缓冲文件的key值
@property (nonatomic, strong) NSOperation           *queryCacheOperation; //查找本地缓存数据的NSOperation
@property (nonatomic, strong) dispatch_queue_t      cancelLoadingQueue;

@property (nonatomic, strong) DYWebCombineOperation *combineOperation;
//@property (nonatomic, strong) WebCombineOperation *combineOperation;

@property (nonatomic, assign) BOOL retried;

@end

@implementation CMVideoPlayer

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化存储AVAssetResourceLoadingRequest的数组
        _pendingRequests = [NSMutableArray array];
        
        //初始化播放器
        _player = [AVPlayer new];
        //添加视频播放器图形化载体AVPlayerlayer
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer:_playerLayer];
        
        //初始化取消视频加载的队列
        _cancelLoadingQueue = dispatch_queue_create("com.start.cancelloadingqueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    //禁止隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _playerLayer.frame = self.layer.bounds;
    [CATransaction commit];
}

//设置播放路径
- (void)setPlayerWithURL:(NSString *)url{
    //播放路径
    self.sourceURL = [NSURL URLWithString:url];
    
    //获取路径schema
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self.sourceURL resolvingAgainstBaseURL:NO];
    self.sourceScheme = components.scheme;
    
    //路径作为视频缓存key
    _cacheFileKey = self.sourceURL.absoluteString;
    
    __weak typeof(self)weakSelf = self;
    //查找本地视频缓存数据
    _queryCacheOperation = [[DYCacheTool sharedWebCache] queryURLFromDiskMemory:_cacheFileKey cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //hascache是否有缓存，data为本地缓存
            if (!hasCache) {
                weakSelf.sourceURL = [weakSelf.sourceURL.absoluteString urlScheme:@"streaming"];
            }else{
                //当前路径有缓存，则使用本地路径作为播放源
                weakSelf.sourceURL = [NSURL fileURLWithPath:data];
            }
            
            //初始化AVURLAsset
            weakSelf.urlAsset = [AVURLAsset URLAssetWithURL:weakSelf.sourceURL options:nil];
            //设置AVAssetResourceLoaderDelegate代理
            [weakSelf.urlAsset.resourceLoader setDelegate:weakSelf queue:dispatch_get_main_queue()];
            //初始化AVPlayerItem
            weakSelf.playerItem = [AVPlayerItem playerItemWithAsset:weakSelf.urlAsset];
            //观察playerItem.status属性
            [weakSelf.playerItem addObserver:weakSelf forKeyPath:@"status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
            //切换当前AVPlayer播放器的播放源
            weakSelf.player = [[AVPlayer alloc] initWithPlayerItem:weakSelf.playerItem];
            weakSelf.playerLayer.player = weakSelf.player;
            //给AVPlayerLayer添加周期性调用的观察者，用于更新播放进度
            [weakSelf addProgressObserver];
        });
    } extension:@"mp4"];
}

//取消播放
- (void)cancelLoading{
    //暂停视频播放
    [self pause];
    
    //隐藏playerLayer
    [_playerLayer setHidden:YES];
    
    //取消下载任务
    if(_combineOperation) {
        [_combineOperation cancel];
        _combineOperation = nil;
    }
    
    //取消查找本地视频缓存数据的NSOperation
    [_queryCacheOperation cancel];
    
    _player = nil;
    [_playerItem removeObserver:self forKeyPath:@"status"];
    _playerItem = nil;
    _playerLayer.player = nil;
    
    __weak __typeof(self) wself = self;
    dispatch_async(self.cancelLoadingQueue, ^{
        //取消AVURLAsset加载，这一步很重要，及时取消到AVAssetResourceLoaderDelegate视频源的加载，避免AVPlayer视频源切换时发生的错位现象
        [wself.urlAsset cancelLoading];
        wself.data = nil;
        //结束所有视频数据加载请求
        [wself.pendingRequests enumerateObjectsUsingBlock:^(id loadingRequest, NSUInteger idx, BOOL * stop) {
            if(![loadingRequest isFinished]) {
                [loadingRequest finishLoading];
            }
        }];
        [wself.pendingRequests removeAllObjects];
    });
    
    _retried = NO;
}

//开始视频资源下载任务
- (void)startDownloadTask:(NSURL *)URL isBackfround:(BOOL)isBackground{
    __weak typeof(self)weakSelf = self;
//    _queryCacheOperation = [[WebCacheHelpler sharedWebCache] queryURLFromDiskMemory:_cacheFileKey cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(hasCache) {
//                return;
//            }
//            
//            if(weakSelf.combineOperation != nil) {
//                [weakSelf.combineOperation cancel];
//            }
//            
//            weakSelf.combineOperation = [[WebDownloader sharedDownloader] downloadWithURL:URL responseBlock:^(NSHTTPURLResponse *response) {
//                weakSelf.data = [NSMutableData data];
//                weakSelf.mimeType = response.MIMEType;
//                weakSelf.expectedContentLength = response.expectedContentLength;
//                [weakSelf processPendingRequests];
//            } progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, NSData *data) {
//                [weakSelf.data appendData:data];
//                //处理视频数据加载请求
//                [weakSelf processPendingRequests];
//            } completedBlock:^(NSData *data, NSError *error, BOOL finished) {
//                if (!error && finished) {
//                    [[WebCacheHelpler sharedWebCache] storeDataToDiskCache:weakSelf.data key:weakSelf.cacheFileKey extension:@"mp4"];
////                    [[DYCacheTool sharedWebCache] storeDataToDisk:weakSelf.data forKey:weakSelf.cacheFileKey extension:@"mp4"];
//                }
//            } cancelBlock:^{
//            } isBackground:isBackground];
//        });
//    }];
    
    
    _queryCacheOperation = [[DYCacheTool sharedWebCache] queryURLFromeDiskMemory:_cacheFileKey cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(hasCache) {
                return;
            }

            if(weakSelf.combineOperation != nil) {
                [weakSelf.combineOperation cancel];
            }

            weakSelf.combineOperation = [[WebDownloader sharedDownloader] downloadWithURL:URL responseBlock:^(NSHTTPURLResponse *response) {
                weakSelf.data = [NSMutableData data];
                weakSelf.mimeType = response.MIMEType;
                weakSelf.expectedContentLength = response.expectedContentLength;
                [weakSelf processPendingRequests];
            } progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, NSData *data) {
                [weakSelf.data appendData:data];
                //处理视频数据加载请求
                [weakSelf processPendingRequests];
            } completedBlock:^(NSData *data, NSError *error, BOOL finished) {
                if (!error && finished) {
                    [[DYCacheTool sharedWebCache] storeDataToDisk:weakSelf.data forKey:weakSelf.cacheFileKey extension:@"mp4"];
                }
            } cancelBlock:^{
            } isBackground:isBackground];
        });
    }];
}

#pragma mark - private Method
- (void)processPendingRequests{
    NSMutableArray *requestsCompleted = [NSMutableArray array];
    
    //获取所有已完成AVAssetResourceLoadingRequest
    [_pendingRequests enumerateObjectsUsingBlock:^(AVAssetResourceLoadingRequest   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //判断AVAssetResourceLoadingRequest是否已完成
        BOOL didRespondCompletely = [self respondWithDataFromRequest:obj];
        //结束AVAssetResourceLoadingRequest
        if (didRespondCompletely) {
            [requestsCompleted addObject:obj];
            [obj finishLoading];
        }
    }];
    //移除所有已完成AVAssetResourceLoadingRequest
    [self.pendingRequests removeObjectsInArray:requestsCompleted];
}

- (BOOL)respondWithDataFromRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    //设置AVAssetResourceLoadingRequest的类型，支持断点下载、内容大小
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(_mimeType), NULL);
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    loadingRequest.contentInformationRequest.contentType = CFBridgingRelease(contentType);
    loadingRequest.contentInformationRequest.contentLength = _expectedContentLength;
    
    
    //AVAssetResourceLoadingRequest请求偏移量
    long long startOffset = loadingRequest.dataRequest.requestedOffset;
    if (loadingRequest.dataRequest.currentOffset != 0) {
        startOffset = loadingRequest.dataRequest.currentOffset;
    }
    
    //判断当前缓存数据量是否大于请求偏移量
    if (_data.length < startOffset) {
        return NO;
    }
    //计算还未装载到缓存数据
    NSUInteger unreadBytes = _data.length - (NSUInteger)startOffset;
    //判断当前请求到的数据大小
    NSUInteger numberOfBytesToRespondWidth = MIN((NSUInteger)loadingRequest.dataRequest.requestedLength, unreadBytes);
    //将缓存数据的指定片段装载到视频加载请求中
    [loadingRequest.dataRequest respondWithData:[_data subdataWithRange:NSMakeRange((NSUInteger)startOffset, numberOfBytesToRespondWidth)]];
    //计算装载完毕后的数据偏移量
    long long endOffset = startOffset + loadingRequest.dataRequest.requestedLength;
    //判断请求是否完成
    BOOL didRespondFully = _data.length >= endOffset;
    
    return didRespondFully;
}

- (void)addProgressObserver{
    __weak typeof(self)weakSelf = self;
    //AVPlayer添加周期性回调观察者，一秒调用一次block，用于更新视频播放进度
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if(weakSelf.playerItem.status == AVPlayerItemStatusReadyToPlay) {
            //获取当前播放时间
            float current = CMTimeGetSeconds(time);
            //获取视频播放总时间
            float total = CMTimeGetSeconds([weakSelf.playerItem duration]);
            //重新播放视频
            if(total == current) {
                [weakSelf replay];
            }
            //更新视频播放进度方法回调
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(delegate_player:currentTime:totalTime:progress:)]) {
                [weakSelf.delegate delegate_player:weakSelf currentTime:current totalTime:total progress:current/total];
            }
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    //AVPlayerItem.status
    if([keyPath isEqualToString:@"status"]) {
        if(_playerItem.status == AVPlayerItemStatusFailed) {
            if(!_retried) {
                [self retry];
            }
        }
        //视频源装备完毕，则显示playerLayer
        if(_playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.playerLayer setHidden:NO];
        }
        //视频播放状体更新方法回调
        //视频播放状态更新回调
        if (_delegate && [_delegate respondsToSelector:@selector(delegate_player:statusChanged:)]) {
            [_delegate delegate_player:self statusChanged:_playerItem.status];
        }
    }else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - public Methond
- (void)updatePlayerState{
    if (_player.rate == 0) {
        [self play];
    }else{
        [self pause];
    }
}

- (void)play{
    [[CMVideoPlayerManager shareManager] play:_player];
}

- (void)pause{
    [[CMVideoPlayerManager shareManager] pause:_player];
}

- (void)replay{
    [[CMVideoPlayerManager shareManager] replay:_player];
}

- (CGFloat)rate{
    return [_player rate];
}

//重新请求
- (void)retry{
    [self cancelLoading];
    _sourceURL = [_sourceURL.absoluteString urlScheme:_sourceScheme];
    [self setPlayerWithURL:_sourceURL.absoluteString];
    _retried = YES;
}

#pragma mark - AVAssetResourceLoaderDelegate
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{
    //创建用于下载视频源的NSURLSessionDataTask， 当前方法会多次调用，所以需判断self.task == nil
    if (_combineOperation == nil) {
        //将当前的请求路径的scheme缓存https，进行普通的网络请求
        NSURL *url = [[loadingRequest.request URL].absoluteString urlScheme:_sourceScheme];
        [self startDownloadTask:url isBackfround:YES];
    }
    
    //将视频加载请求依次存储到pendingrequests中，因为当前方法会多次调用，所以需用数组缓存
    [_pendingRequests addObject:loadingRequest];
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    //AVAssetResourceLoadingRequest请求被取消，移除视频加载请求
    [_pendingRequests removeObject:loadingRequest];
}


- (void)dealloc{
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_player removeTimeObserver:_timeObserver];
}


@end
