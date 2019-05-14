//
//  DYBaseViewController.h
//  Douyin
//
//  Created by Ternence on 2019/5/6.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYBaseViewController : UIViewController


/**
 设置返回按钮

 @param normalName   默认返回按钮图片名
 @param highName     高亮的返回按钮图片名
 @param selectedName 选中状态的图片
 */
- (void)setBackBtnWithNormalName:(NSString *)normalName
                     highName:(NSString *)highName
                 selectedName:(NSString *)selectedName;

- (void)setRightBtnWithNormalName:(NSString *)normalName
                         highName:(NSString *)highName
                       selectName:(NSString *)selectName;


/**
 设置导航栏透明
 */
- (void)setNavigationBarClear;

/**
 设置导航栏背景色为非透明（默认）
 */
- (void)setNavigationBarNoneClear;

- (void)setNavigationBarTitleColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
