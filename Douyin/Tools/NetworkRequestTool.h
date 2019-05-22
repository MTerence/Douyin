//
//  NetworkRequestTool.h
//  Douyin
//
//  Created by Ternence on 2019/5/22.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//域名
extern NSString *const kURL_Base;

//获取用户发布的视频列表
extern NSString *const kURL_UserWorkVideoList;
//获取用户信息
extern NSString *const kURL_UserInfo;

@interface NetworkRequestTool : NSObject

/**
 Get请求
 
 @param url url
 @param params 参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)GetWithURL:(NSString *)url
            params:(NSDictionary *)params
           success:(void(^)(id json))success
           failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
