//
//  DYCacheTool.m
//  Douyin
//
//  Created by Ternence on 2019/5/24.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYCacheTool.h"
#import <objc/runtime.h>
//#import <CommonCrypto/CommonDigest.h>

@implementation DYWebCombineOperation

- (void)cancel{
    //取消查询缓存NSOperation任务和下载资源WebDownloadOperation任务
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
        self.cacheOperation = nil;
    }
    
    //取消下载资源WebDownloadOperation任务
    if (self.downloadOperation) {
        [self.downloadOperation cancel];
        self.downloadOperation = nil;
    }
    
    //任务取消回调
    if (self.cancelBlock) {
        self.cancelBlock();
        _cancelBlock = nil;
    }
}

@end

@interface DYCacheTool ()
@property (nonatomic, strong) NSCache *memCache;            //内存缓存
@property (nonatomic, strong) NSFileManager *fileManager;   //文件管理类
@property (nonatomic, strong) NSURL *diskCacheDirectoryURL; //本地磁盘文件夹路径
@property (nonatomic, strong) dispatch_queue_t ioQueue;     //查询缓存任务队列
@end

@implementation DYCacheTool

+ (DYCacheTool *)sharedWebCache{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return  instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _memCache = [NSCache new];
        _memCache.name = @"webCache";
        _memCache.totalCostLimit = 50 * 1024 * 1024;
        
        //初始化文件管理类
        _fileManager = [NSFileManager defaultManager];
        
        //获取本地磁盘缓存文件夹路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *path = [paths lastObject];
        NSString *diskCachePath = [NSString stringWithFormat:@"%@%@",path,@"/webCache"];
        
        //判断是否创建本地磁盘缓存文件夹
        BOOL isDirectory = NO;
        BOOL isExisted = [_fileManager fileExistsAtPath:diskCachePath isDirectory:&isDirectory];
        if (!isDirectory || !isExisted) {
            NSError *error;
            [_fileManager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
        //本地磁盘缓存文件夹URL
        _diskCacheDirectoryURL = [NSURL fileURLWithPath:diskCachePath];
        
        //初始化查询缓存任务队列
        _ioQueue = dispatch_queue_create("com.start.webcache", DISPATCH_QUEUE_SERIAL);
        
    }
    return self;
}

//根据key值从内存和本地磁盘中查询缓存数据
- (NSOperation *)queryDataFromMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock{
    return [self queryDataFromMemory:key cacheQueryCompletedBlock:cacheQueryCompletedBlock extension:nil];
}

//根据key值从内存和本地磁盘中查询缓存数据，所查询缓存数据包含指定文件类型
- (NSOperation *)queryDataFromMemory:(NSString *)key
            cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock
                           extension:(NSString *)extension{
    NSOperation *operation = [NSOperation new];
    dispatch_async(_ioQueue, ^{
        if (operation.isCancelled) {
            return;
        }
        
        NSData *data = [self dataFromMemoryCache:key];
        if (!data) {
            data = [self dataFromDiskCache:key];
        }
        
        if (!data) {
            data = [self dataFromDiskCache:key extension:extension];
        }
        
        if (data) {
            cacheQueryCompletedBlock(data, YES);
        }else{
            cacheQueryCompletedBlock(nil, NO);
        }
    });
    
    return operation;
}

//根据Key值从本地磁盘中查询缓存数据
- (NSOperation *)queryURLFromeDiskMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock{
    return [self queryURLFromDiskMemory:key cacheQueryCompletedBlock:cacheQueryCompletedBlock extension:nil];
}

//根据key值从本地磁盘中查询缓存数据，所查询缓存数据包含指定文件类型
- (NSOperation *)queryURLFromDiskMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock extension:(NSString *)extension{
    NSOperation *operation = [NSOperation new];
    dispatch_async(_ioQueue, ^{
        if (operation.isCancelled) {
            return;
        }
        
        NSString *path = [self diskCachePathForKey:key extension:extension];
        if ([self.fileManager fileExistsAtPath:path]) {
            cacheQueryCompletedBlock(path, YES);
        }else{
            cacheQueryCompletedBlock(path, NO);
        }
    });
    
    return operation;
}

//根据key值从内存中查询缓存数据
- (NSData *)dataFromMemoryCache:(NSString *)key{
    return [_memCache objectForKey:key];
}

//根据key值从本地磁盘中查询缓存数据
- (NSData *)dataFromDiskCache:(NSString *)key{
    return [self dataFromDiskCache:key extension:nil];
}

//根据key值从本地磁盘中查询缓存数据
- (NSData *)dataFromDiskCache:(NSString *)key extension:(NSString *)extension{
    return [NSData dataWithContentsOfFile:[self diskCachePathForKey:key extension:extension]];
}

//存储缓存数据到内存和本地磁盘中，所查询缓存数据包含指定文件类型
- (void)storeDataCache:(NSData *)data forKey:(NSString *)key{
    dispatch_async(_ioQueue, ^{
        [self storeDataToMemoryCache:data key:key];
        [self storeDataToDisk:data forKey:key];
    });
}

//存储缓存数据到本地磁盘
- (void)storeDataToMemoryCache:(NSData *)data key:(NSString *)key{
    if (data && key) {
        [self.memCache setObject:data forKey:key];
    }
}

//存储缓存数据到本地磁盘
- (void)storeDataToDisk:(NSData *)date forKey:(NSString *)key{
    [self storeDataToDisk:date forKey:key extension:nil];
}

//根据key值从本地磁盘中查询缓存数据，缓存数据返回路径包含文件类型
- (void)storeDataToDisk:(NSData *)date forKey:(NSString *)key extension:(NSString *)extension{
    if (date && key) {
        [_fileManager createFileAtPath:[self diskCachePathForKey:key extension:extension] contents:date attributes:nil];
    }
}

//获取key值对应的磁盘缓存文件路径，文件路径包含指定拓展名
- (NSString *)diskCachePathForKey:(NSString *)key extension:(NSString *)extension{
    NSString *fileName = [NSString md5ForString:key];
    NSString *cachePathForKey = [_diskCacheDirectoryURL URLByAppendingPathComponent:fileName].path;
    if (extension) {
        cachePathForKey = [cachePathForKey stringByAppendingFormat:@".%@", extension];
    }
    return cachePathForKey;
}

//清除内存和本地磁盘缓存的数据
- (void)clearCache:(WebCacheClearCompletedBlock)cacheCompletedBlock{
    dispatch_async(_ioQueue, ^{
        [self clearMemoryCache];
        NSString *cacheSize = [self clearDiskCache];
        if (cacheCompletedBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cacheCompletedBlock(cacheSize);
            });
        }
    });
}

//清除内存缓存数据
- (void)clearMemoryCache{
    [_memCache removeAllObjects];
}

//清除磁盘缓存数据
- (NSString *)clearDiskCache{
    NSArray *contents = [_fileManager contentsOfDirectoryAtPath:_diskCacheDirectoryURL.path error:nil];
    NSEnumerator *enumerator = [contents objectEnumerator];
    NSString *fileName;
    CGFloat folderSize = 0.0f;
    
    while (fileName == [enumerator nextObject]) {
        NSString *filePath = [_diskCacheDirectoryURL.path stringByAppendingString:fileName];
        folderSize += [_fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
        [_fileManager removeItemAtPath:filePath error:NULL];
    }
    
    return [NSString stringWithFormat:@"%.2f", folderSize/1024.0f/1024.0f];
}

@end

@interface WebDownloadOperation ()

@property (nonatomic, copy) WebDownloaderResponseBlock  responseBlock;      //下载进度响应Block
@property (nonatomic, copy) WebDownloaderProgressBlock  progressBlock;      //下载进度回调Block
@property (nonatomic, copy) WebDownloaderCompletedBlock completedBlock;     //下载完成回调Block
@property (nonatomic, copy) WebDownloaderCancelBlock    cancelBlock;        //取消下载回调Block

@property (nonatomic, strong) NSMutableData *data;                          //用于存储网络资源数据
@property (nonatomic, assign) NSInteger     expectedSize;                   //网络资源数据总大小
@property (nonatomic, assign) BOOL          executing;                      //判断NSOperation是否执行
@property (nonatomic, assign) BOOL          finished;                       //判断NSOperation是否结束
@end


@implementation WebDownloadOperation

@synthesize executing = _executing; //指定executing别名为_executing
@synthesize finished  = _finished;  //指定finished别名为_finished

- (instancetype)initWithRequest:(NSURLRequest *)request
                  responseBlock:(WebDownloaderResponseBlock)responseBlock
                  progressBlock:(WebDownloaderProgressBlock)progressBlock
                 completedBlock:(WebDownloaderCompletedBlock)completedBlock
                    cancelBlock:(WebDownloaderCancelBlock)cancelBlock{
    if (self = [super init]) {
        _request = [request copy];
        _responseBlock = [responseBlock copy];
        _progressBlock = [progressBlock copy];
        _completedBlock = [completedBlock copy];
        _cancelBlock = [cancelBlock copy];
    }
    return self;
}

- (void)start{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    //判断当前任务执行前是否取消了下载
    if (self.isCancelled) {
        [self done];
        return;
    }
    
    @synchronized (self) {
        //创建网络资源下载请求，并设置网络请求代理
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = 15;
        _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:NSOperationQueue.mainQueue];
        _dataTask = [_session dataTaskWithRequest:_request];
        [_dataTask resume];
    }
}

- (BOOL)isExecuting{
    return _executing;
}

- (BOOL)isFinished{
    return _finished;
}

- (BOOL)isAsynchronous{
    return YES;
}

- (void)cancel{
    @synchronized (self) {
        [self done];
    }
}
- (void)done{
    [super cancel];
    if (_executing) {
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        _finished = YES;
        _executing = NO;
        [self didChangeValueForKey:@"isFinished"];
        [self didChangeValueForKey:@"isExecuting"];
        [self reset];
    }
}

- (void)reset{
    if (self.dataTask) {
        [_dataTask cancel];
    }
    if (self.session) {
        [self.session invalidateAndCancel];
        self.session = nil;
    }
}

//网络下载请求获得响应
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (_responseBlock) {
        _responseBlock(httpResponse);
    }
    
    NSInteger code = [httpResponse statusCode];
    if (code == 200) {
        completionHandler(NSURLSessionResponseAllow);
        self.data = [NSMutableData new];
        NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
        self.expectedSize = expected;
    }else{
        completionHandler(NSURLSessionResponseCancel);
    }
}

//网络资源下载请求完毕
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    if (_completedBlock) {
        if (error) {
            if (error.code == NSURLErrorCancelled) {
                _cancelBlock();
            }else{
                _completedBlock(nil, error, NO);
            }
        }else{
            _completedBlock(self.data, nil, YES);
        }
    }
    
    [self done];
}

//网络缓存数据复用
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler{
    NSCachedURLResponse *cachedResponse = proposedResponse;
    if (self.request.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData) {
        cachedResponse = nil;
    }
    if (completionHandler) {
        completionHandler(cachedResponse);
    }
}

@end

@implementation WebDownloader

+ (WebDownloader *)sharedDownloader{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        
        //初始化并行下载队列
        _downloadConcurrentQueue = [NSOperationQueue new];
        _downloadConcurrentQueue.name = @"com.concurrent.webdownloader";
        _downloadConcurrentQueue.maxConcurrentOperationCount = 6;
        
        //初始化串行下载队列
        _downloadSerialQueue = [NSOperationQueue new];
        _downloadSerialQueue.name = @"com.serial.webdownloader";
        _downloadSerialQueue.maxConcurrentOperationCount = 1;
        
        //初始化后台串行下载队列
        _downloadBackgroundQueue = [NSOperationQueue new];
        _downloadBackgroundQueue.name = @"com.background.webdownloader";
        _downloadBackgroundQueue.maxConcurrentOperationCount = 1;
        _downloadBackgroundQueue.qualityOfService = NSQualityOfServiceBackground;
        
        //初始化高优先级下载队列
        _downloadPriorityHighQueue = [NSOperationQueue new];
        _downloadPriorityHighQueue.name = @"com.priporityHigh.webdownloader";
        _downloadPriorityHighQueue.maxConcurrentOperationCount = 1;
        _downloadPriorityHighQueue.qualityOfService = NSQualityOfServiceUserInteractive;
        [_downloadPriorityHighQueue addObserver:self forKeyPath:@"operations" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (DYWebCombineOperation *)downloadWithURL:(NSURL *)url
                             progressBlock:(WebDownloaderProgressBlock)progressBlock
                            completedBlock:(WebDownloaderCompletedBlock)completedBlock
                               cancelBlock:(WebDownloaderCancelBlock)cancelBlock{
    
    return [self downloadWithURL:url
                   progressBlock:progressBlock
                  completedBlock:completedBlock
                     cnacelBlock:cancelBlock
                    isConcurrent:YES];
}

- (DYWebCombineOperation *)downloadWithURL:(NSURL *)url
                             progressBlock:(WebDownloaderProgressBlock)progressBlock
                            completedBlock:(WebDownloaderCompletedBlock)completedBlock
                               cnacelBlock:(WebDownloaderCancelBlock)cancelBlock
                              isConcurrent:(BOOL)isConcurrent{
    return [self downloadWithURL:url
                   responseBlock:nil
                   progressBlock:progressBlock
                  completedBlock:completedBlock
                     cancelBlock:cancelBlock isConcurrent:isConcurrent];
}



- (DYWebCombineOperation *)downloadWithURL:(NSURL *)url
                             responseBlock:(WebDownloaderResponseBlock)responseBlock
                             progressBlock:(WebDownloaderProgressBlock)progressBlock
                            completedBlock:(WebDownloaderCompletedBlock)completedBlock
                               cancelBlock:(WebDownloaderCancelBlock)cancelBlock{
    return [self downloadWithURL:url
                   responseBlock:responseBlock
                   progressBlock:progressBlock
                  completedBlock:completedBlock
                     cancelBlock:cancelBlock isConcurrent:YES];
}

- (DYWebCombineOperation *)downloadWithURL:(NSURL *)url
                             responseBlock:(WebDownloaderResponseBlock)responseBlock
                             progressBlock:(WebDownloaderProgressBlock)progressBlock
                            completedBlock:(WebDownloaderCompletedBlock)completedBlock
                               cancelBlock:(WebDownloaderCancelBlock)cancelBlock
                              isConcurrent:(BOOL)isConcurrent{
    //初始化网络资源下载请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    request.HTTPShouldUsePipelining = YES;  //不必等到response, 就可以再次请求
    //网络资源路径作为key值
    __block NSString *key = url.absoluteString;
    //初始化组合任务DYWebCombineOperation
    __block DYWebCombineOperation *operation = [DYWebCombineOperation new];
    __weak __typeof(self)weakSelf = self;
    //赋值DYWebCombineOperation中查找缓存NSOperation任务
    operation.cacheOperation = [[DYCacheTool sharedWebCache] queryDataFromMemory:key cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
        //判断是否查找到缓存
        if (hasCache) {
            //查找到缓存则直接返回缓存数据
            if (completedBlock) {
                completedBlock(data, nil, YES);
            }
        }else{
            //未查找到缓存，创建下载网络资源的webDownloadOperation任务，并赋值组合任务DYWebCombineOperation
            operation.downloadOperation = [[WebDownloadOperation alloc]initWithRequest:request responseBlock:^(NSHTTPURLResponse *response) {
                if (responseBlock) {
                    responseBlock(response);
                }
            } progressBlock:progressBlock completedBlock:^(NSData *data, NSError *error, BOOL finished) {
                //网络资源下载完毕，处理返回数据
                if (completedBlock) {
                    if (finished && !error) {
                        //若下载任务没有错误的情况下完成，则将下载数据进行缓存
                        [[DYCacheTool sharedWebCache] storeDataCache:data forKey:key];
                        completedBlock(data,nil, YES);
                    }else{
                        //任务失败回调
                        completedBlock(nil, error, NO);
                    }
                }
            } cancelBlock:^{
                if (cancelBlock) {
                    cancelBlock();
                }
            }];
            
            //将下载任务添加进队列
            if (isConcurrent) {
                [weakSelf.downloadConcurrentQueue addOperation:operation.downloadOperation];
            }else{
                [weakSelf.downloadSerialQueue addOperation:operation.downloadOperation];
            }
        }
    }];
    
    //返回包含了查询任务和下载任务的组合任务
    return operation;
}

- (DYWebCombineOperation *)downloadWithURL:(NSURL *)url
                             responseBlock:(WebDownloaderResponseBlock)responseBlock
                             progressBlock:(WebDownloaderProgressBlock)progressBlock
                            completedBlock:(WebDownloaderCompletedBlock)completedBlock
                               cancelBlock:(WebDownloaderCancelBlock)cancelBlock
                              isBackground:(BOOL)isBackground{
    //初始化网络资源下载请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    request.HTTPShouldUsePipelining = YES;
    
    //网络资源路径作为key值
    __block NSString *key = url.absoluteString;
    //初始化组合任务DYWebCombineOperation
    __block DYWebCombineOperation *operation = [DYWebCombineOperation new];
    __weak __typeof(self)weakSelf = self;
    //赋值组合任务DYWebCombineOperation中的查找缓存NSOperation任务
    operation.cacheOperation = [[DYCacheTool sharedWebCache] queryDataFromMemory:key cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
       //判断是否查找到缓存
        if (hasCache) {
            if (completedBlock) {
                completedBlock(data, nil, YES);
            }
        }else{
            operation.downloadOperation = [[WebDownloadOperation alloc]initWithRequest:request responseBlock:^(NSHTTPURLResponse *response) {
                if (responseBlock) {
                    responseBlock(response);
                }
            } progressBlock:progressBlock completedBlock:^(NSData *data, NSError *error, BOOL finished) {
                //网络资源下载完毕，处理返回数据
                if (completedBlock) {
                    if (finished && !error) {
                        //若下载任务没有错误的情况下完成，则将下载数据进行缓存
                        [[DYCacheTool sharedWebCache]storeDataCache:data forKey:key];
                        completedBlock(data, nil, YES);
                    }else{
                        completedBlock(nil, error, NO);
                    }
                }
            } cancelBlock:^{
                if (cancelBlock) {
                    cancelBlock();
                }
            }];
            
            //将下载任务添加进队列
            if (isBackground) {
                [weakSelf.downloadBackgroundQueue addOperation:operation.downloadOperation];
            }else{
                //添加高优先级下载任务，队列中每次只执行一个任务
                [weakSelf.downloadPriorityHighQueue cancelAllOperations];
                [weakSelf.downloadPriorityHighQueue addOperation:operation.downloadOperation];
            }
        }
    }];
    
    return operation;

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"operations"]) {
        @synchronized (self) {
            if ([_downloadPriorityHighQueue.operations count] == 0) {
                [_downloadBackgroundQueue setSuspended:NO];
            }else{
                [_downloadBackgroundQueue setSuspended:YES];
            }
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [_downloadPriorityHighQueue removeObserver:self forKeyPath:@"operations"];
}

@end
