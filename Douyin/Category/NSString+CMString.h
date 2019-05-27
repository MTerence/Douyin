//
//  NSString+CMString.h
//  Douyin
//
//  Created by Ternence on 2019/5/27.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CMString)


/**
 计算一个字符串的md5值

 @param string 需要计算md5的字符串
 @return md5
 */
+ (NSString *)md5ForString:(NSString *)string;


- (NSURL *)urlScheme:(NSString *)scheme;

@end

NS_ASSUME_NONNULL_END
