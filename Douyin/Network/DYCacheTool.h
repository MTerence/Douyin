//
//  DYCacheTool.h
//  Douyin
//
//  Created by Ternence on 2019/5/24.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <Foundation/Foundation.h>

//缓存清除完毕后的回调block
typedef void(^WebCacheClearCompletedBlock)(NSString *cacheSize);

//缓存查询完毕后的回调block，data返回类型包括NSString缓存文件路径、NSData格式缓存路径
typedef void(^WebCacheQueryCompletedBlock)(id data, BOOL hasCache);

//网络资源下载响应的回调block
typedef void(^WebDownloaderResponseBlock)(NSHTTPURLResponse *response);

//网络资源下载进度的回调block
typedef void(^WebDownloaderProgressBlock)(NSInteger receivedSize);

//网络资源下载完毕后的回调block
typedef void(^WebDownloaderCompletedBlock)(NSData *data, NSError *error, BOOL finished);

//网络资源下载取消后的回调Block
typedef void(^WebDownloaderCancelBlock)(void);

@class WebDownloadOperation;

//查询存储NSOperation任务和下载资源WebDownloadOperation 任务合并的类
@interface DYWebCombineOperation : NSObject
//网络资源下载取消
@property (nonatomic, copy)   WebDownloaderCancelBlock cancelBlock;
//查询缓存NSOperation任务
@property (nonatomic, strong) NSOperation *cacheOperation;
//下载网络资源任务
@property (nonatomic, strong) WebDownloadOperation *downloadOperation;
//取消查询缓存NSOperation任务和下载资源WebDownloadOperation任务
- (void)cancel;

@end

//处理网络资源缓存类
@interface DYCacheTool : NSObject
//单例
+ (DYCacheTool *)sharedWebCache;

//根据key值从内存和本地磁盘中查询缓存数据
- (NSOperation *)queryDataFromMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock;

//根据key值从本地磁盘中查询缓存数据
- (NSOperation *)queryDataFromeDisk:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock;

//根据key值从内存和本地磁盘中查询缓存数据，所查询缓存数据包含指定文件类型
- (NSOperation *)queryDataFromMemory:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock extension:(NSString *)extension;

//根据key值从本地磁盘中查询缓存数据，所查询数据包含指定文件类型
- (NSOperation *)queryURLFromDisk:(NSString *)key cacheQueryCompletedBlock:(WebCacheQueryCompletedBlock)cacheQueryCompletedBlock extension:(NSString *)extension;

//存储缓存数据到内存和本地磁盘
- (void)storeDataCache:(NSData *)data forKey:(NSString *)key;
//存储缓存数据到本地磁盘
- (void)storeDataToDiskCache:(NSData *)date forKey:(NSString *)key;

- (void)storeDataToDisk:(NSData *)date forKey:(NSString *)key extension:(NSString *)extension;

//清除本地缓存数据
- (void)clearCache:(WebCacheClearCompletedBlock)cacheCompletedBlock;

@end




//自定义用于下载网络资源的NSOperation任务
@interface WebDownloadOperation : NSOperation<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionTask *dataTask;
@property (nonatomic, strong, readonly) NSURLRequest *request;

- (instancetype)initWithRequest:(NSURLRequest *)request
                  responseBlock:(WebDownloaderResponseBlock)responseBlock
                  progressBlock:(WebDownloaderProgressBlock)progressBlock
                 completedBlock:(WebDownloaderCompletedBlock)completedBlock
                    cancelBlock:(WebDownloaderCancelBlock)cancelBlock;

@end


@interface WebDownloader : NSObject
//用于处理下载任务的NSOperationQueue队列
@property (nonatomic, strong) NSOperationQueue *downloadConcurrentQueue;
@property (nonatomic, strong) NSOperationQueue *downloadSerialQueue;

@property (nonatomic, strong) NSOperationQueue *downloadBackgroundQueue;
@property (nonatomic, strong) NSOperationQueue *downloadPriorityHighQueue;

+ (WebDownloader *)sharedDownloader;

//下载指定url网络资源
- (DYWebCombineOperation *)downloadWithURL:(NSURL *)url
                          progressBlock:(WebDownloaderProgressBlock)progressBlock
                         completedBlock:(WebDownloaderCompletedBlock)completedBlock
                            cancelBlock:(WebDownloaderCancelBlock)cancelBlock;

- (DYWebCombineOperation *)downloadWithURL:(NSURL *)url
                            progressBlock:(WebDownloaderProgressBlock)progressBlock
                           completedBlock:(WebDownloaderCompletedBlock)completedBlock
                              cnacelBlock:(WebDownloaderCancelBlock)cancelBlock
                             isConcurrent:(BOOL)isConcurrent;

- (DYWebCombineOperation *)downloadWithURL:(NSURL *)url
                             responseBlock:(WebDownloaderResponseBlock)responseBlock
                             progressBlock:(WebDownloaderProgressBlock)progressBlock
                            completedBlock:(WebDownloaderCompletedBlock)completedBlock
                               cancelBlock:(WebDownloaderCancelBlock)cancelBlock;

- (DYWebCombineOperation *)downloadWithURL:(NSURL *)url
                             responseBlock:(WebDownloaderResponseBlock)responseBlock
                             progressBlock:(WebDownloaderProgressBlock)progressBlock
                            completedBlock:(WebDownloaderCompletedBlock)completedBlock
                               cancelBlock:(WebDownloaderCancelBlock)cancelBlock
                              isConcurrent:(BOOL)isConcurrent;

- (DYWebCombineOperation *)downloadWithURL:(NSURL *)url
                             responseBlock:(WebDownloaderResponseBlock)responseBlock
                             progressBlock:(WebDownloaderProgressBlock)progressBlock
                            completedBlock:(WebDownloaderCompletedBlock)completedBlock
                               cancelBlock:(WebDownloaderCancelBlock)cancelBlock
                              isBackground:(BOOL)isBackground;


@end
