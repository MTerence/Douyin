//
//  UIColor+DYColor.h
//  Douyin
//
//  Created by Ternence on 2019/5/6.
//  Copyright © 2019 Ternence. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DYColor)

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha;
+ (UIColor *)colorWithW:(CGFloat)white a:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(int32_t)rgbValue;
+ (UIColor *)colorWithHex:(int32_t)rgbValue a:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)colorStr;
+ (UIColor *)colorWithHexString:(NSString *)colorStr alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
