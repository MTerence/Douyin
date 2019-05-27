//
//  CMVideoPlayer.m
//  Douyin
//
//  Created by Ternence on 2019/5/27.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "CMVideoPlayer.h"
#import "DYCacheTool.h"

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

- (void)layoutSubviews{
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
    NSURLComponents *components = [[NSURLComponents alloc]initWithURL:self.sourceURL resolvingAgainstBaseURL:NO];
    self.sourceScheme = components.scheme;
    
    //路径作为视频缓存key
    _cacheFileKey = self.sourceURL.absoluteString;
    
    __weak typeof(self)weakSelf = self;
    //查找本地视频缓存数据
    _queryCacheOperation = [[DYCacheTool sharedWebCache] queryURLFromDisk:_cacheFileKey cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
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
            [weakSelf.playerItem addObserver:weakSelf forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
            //切换当前AVPlayer播放器的播放源
            weakSelf.player = [[AVPlayer alloc]initWithPlayerItem:weakSelf.playerItem];
            weakSelf.playerLayer.player = weakSelf.player;
            //给AVPlayerLayer添加周期性调用的观察者，用于更新播放进度
            [weakSelf addProgressObserver];
        });
    } extension:@"mp4"];
}


- (void)addProgressObserver{
    
}

@end
