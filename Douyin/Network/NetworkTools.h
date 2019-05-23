//
//  NetworkTools.h
//  Douyin
//
//  Created by Ternence on 2019/5/22.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkTools : AFHTTPSessionManager

+ (instancetype)sharedManager;


/** 网络状态 */
@property (nonatomic, assign) NSInteger networkState;

@end

NS_ASSUME_NONNULL_END
