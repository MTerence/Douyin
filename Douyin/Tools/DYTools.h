//
//  DYTools.h
//  Douyin
//
//  Created by Ternence on 2019/5/8.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYTools : NSObject


/**
 判断是否是iPhoneX系列机型

 @return True/False
 */
+ (BOOL)isIPhoneX;

/**
 将string转化为NSMutableAttributedString

 @param strings NSArray 存放每个string
 @param colors  NSArray 存放每个range对应的color
 @param fonts   NSArray 存放每个range对应的font
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)attributeTextWithStrings:(NSArray<NSString *>*)strings
                                                colors:(NSArray <UIColor *> *)colors
                                                 fonts:(NSArray <UIFont *>*)fonts;

/**
 *   NSString转NSDate
 *
 *  @param string  传入的NSString
 *
 *  @return 返回NSDate  2018-03-23 00:00:00
 */
+ (NSDate *)StringConvertToDate:(NSString *)string;

/**
 *  获取时间差
 *
 *  @param fromTime 最后更新时间
 *
 *  @param toTime   当前时间
 *  @return NSDateComponents 时间差
 */
+ (NSDateComponents *)compareTimeFromDate:(NSString *)fromTime toTime:(NSDate *)toTime;

@end

NS_ASSUME_NONNULL_END
