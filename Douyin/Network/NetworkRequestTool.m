//
//  NetworkRequestTool.m
//  Douyin
//
//  Created by Ternence on 2019/5/22.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "NetworkRequestTool.h"
#import "NetworkTools.h"

//域名
NSString *const kURL_Base = @"http://116.62.9.17:8080/douyin/";
//获取用户发布的视频列表
NSString *const kURL_UserWorkVideoList  = @"aweme/post";
//获取用户信息
NSString *const kURL_UserInfo           = @"user";

@implementation NetworkRequestTool


/**
 Get请求

 @param url url
 @param params 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)GetWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure{
    if (url == NULL) {
        return;
    }
    
    NSString *urlString = [[kURL_Base stringByAppendingString:url] stringByRemovingPercentEncoding];

    NetworkTools *sessionManager = [NetworkTools sharedManager];
    [sessionManager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\n\nURL:%@ Error:%@\n\n",url,error);
        if (failure) {
            failure(error);
        }
    }];
}


@end
