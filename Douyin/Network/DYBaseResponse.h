//
//  DYBaseResponse.h
//  Douyin
//
//  Created by Ternence on 2019/5/23.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYBaseResponse : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) NSInteger has_more;

@property (nonatomic, assign) NSInteger total_count;

@property (nonatomic, copy)   NSString  *message;

@end

NS_ASSUME_NONNULL_END
