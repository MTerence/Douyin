//
//  DYMainRootViewController.h
//  Douyin
//
//  Created by Ternence on 2019/5/7.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYMainRootViewController : UINavigationController

+ (void)customizeInterfaceWithTabBarController:(CYLTabBarController *)tabBarController;
- (void)createNewTabBar;

@end

NS_ASSUME_NONNULL_END
