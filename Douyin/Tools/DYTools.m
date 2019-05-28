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

#pragma mark NSString转NSDate
+ (NSDate *)StringConvertToDate:(NSString *)string{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//可能需要设置时区，此处设为东8即北京时间
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    if (string.length <= 10) {
        format.dateFormat = @"yyyy-MM-dd";
    }
    NSDate *date = [format dateFromString:string];
    
    return date;
}

+ (NSDateComponents *)compareTimeFromDate:(NSString *)fromTime toTime:(NSDate *)toTime{
    
    // 将时间转换为date
    NSDate *fromDate = [DYTools StringConvertToDate:fromTime];
    
    // 创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:fromDate toDate:toTime options:0];
    
    return cmps;
}

#pragma mark - 读取本地Json文件
+ (NSDictionary *)readJsonFile:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return dic;
}

@end
