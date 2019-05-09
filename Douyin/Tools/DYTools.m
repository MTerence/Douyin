//
//  DYTools.m
//  Douyin
//
//  Created by Ternence on 2019/5/8.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYTools.h"

@implementation DYTools

#pragma mark - 判断设备是否是iPhoneX系列机型手机
+ (BOOL)isIPhoneX{
    
    BOOL iPhoneX = false; /// 先判断设备是否是iPhone/iPod
    
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneX;
    }
    
    if (@available(iOS 11.0, *)) { /// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = true;
        }
    }
    
    return iPhoneX;
}

#pragma mark - string 转 NSMutableAttributedString
+ (NSMutableAttributedString *)attributeTextWithStrings:(NSArray<NSString *> *)strings
                                                 colors:(NSArray<UIColor *> *)colors
                                                  fonts:(NSArray<UIFont *> *)fonts{
    NSString                  *mutableString = [[NSString alloc]init];
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc]init];
    
    if (strings.count == colors.count && colors.count == fonts.count) {
        for (int i = 0; i < strings.count; i ++) {
            NSString *string = strings[i];
            mutableString = [mutableString stringByAppendingString:string];
            
            NSRange range = [mutableString rangeOfString:string];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:string];
            [attributeText appendAttributedString:attributeString];
            
            [attributeText yy_setColor:colors[i] range:range];
            [attributeText yy_setFont:fonts[i] range:range];
        }
    }
    return attributeText;
    
}

@end
