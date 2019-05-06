//
//  UIColor+DYColor.m
//  Douyin
//
//  Created by Ternence on 2019/5/6.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "UIColor+DYColor.h"

@implementation UIColor (DYColor)

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha];
}

+ (UIColor *)colorWithW:(CGFloat)white a:(CGFloat)alpha {
    return [UIColor colorWithWhite:white/255.0f alpha:alpha];
}

+ (UIColor *)colorWithHex:(int32_t)rgbValue {
    return [[self class] colorWithHex:rgbValue a:1.0];
}

+ (UIColor *)colorWithHex:(int32_t)rgbValue a:(CGFloat)alpha {
    return [[self class] colorWithR:((float)((rgbValue & 0xFF0000) >> 16))
                                  g:((float)((rgbValue & 0xFF00) >> 8))
                                  b:((float)(rgbValue & 0xFF))
                                  a:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)colorStr {
    return [[self class] colorWithHexString:colorStr alpha:1.0];
}
+ (UIColor *)colorWithHexString:(NSString *)colorStr alpha:(CGFloat)alpha {
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:rString] scanHexInt:&red];
    [[NSScanner scannerWithString:gString] scanHexInt:&green];
    [[NSScanner scannerWithString:bString] scanHexInt:&blue];
    
    return [[self class] colorWithR:(float)red
                                  g:(float)green
                                  b:(float)blue
                                  a:alpha];
}
@end
