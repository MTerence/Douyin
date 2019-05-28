//
//  NetworkTools.m
//  Douyin
//
//  Created by Ternence on 2019/5/22.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "NetworkTools.h"

@implementation NetworkTools

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkTools alloc]init];
    });
    
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.networkState = -1;     //初始化默认值，代表未知网络
        
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //设置超时时间
        [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.requestSerializer.timeoutInterval = 5;
        [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html", nil];
        
        __weak typeof(self)weakSelf = self;
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            weakSelf.networkState = status;
            
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    //未知网络
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    //手机自带网络
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    //WIFI
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                    //无网络
                    break;
                    
                default:
                    break;
            }
        }];
        
        //开始监听网络
        [self.reachabilityManager startMonitoring];
    }
    return self;
}

@end
