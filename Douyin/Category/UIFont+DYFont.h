//
//  UIFont+DYFont.h
//  Douyin
//
//  Created by Ternence on 2019/5/7.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (DYFont)


/**
 根据不同设备返回字体大小

 @param size 字体大小
 @return 返回适配的字体大小
 */
+ (CGFloat)DY_FontSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
