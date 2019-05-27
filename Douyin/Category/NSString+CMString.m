//
//  NSString+CMString.m
//  Douyin
//
//  Created by Ternence on 2019/5/27.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "NSString+CMString.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (CMString)

+ (NSString *)md5ForString:(NSString *)string{
    //要进行UTF8的转码
    const char *input = [string UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(input, (CC_LONG)strlen(input), digest);
    
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        //小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return  result;
}

- (NSURL *)urlScheme:(NSString *)scheme{
    NSURLComponents *components = [[NSURLComponents alloc]initWithURL:[NSURL URLWithString:scheme] resolvingAgainstBaseURL:NO];
    components.scheme = scheme;
    return [components scheme];
}

@end
