//
//  DYTabBarControllerConfig.m
//  Douyin
//
//  Created by Ternence on 2019/5/6.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYTabBarControllerConfig.h"
#import <UIKit/UIKit.h>
#import "DYHomeViewController.h"
#import "DYFollowViewController.h"
#import "DYChatListViewController.h"
#import "DYMineViewController.h"

@interface CYLBaseNavigationController : UINavigationController
@end

@implementation CYLBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

@end

@interface DYTabBarControllerConfig ()<CYLTabBarControllerDelegate>

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation DYTabBarControllerConfig


- (NSArray *)viewControllers{
    DYHomeViewController     *homeVC       = [[DYHomeViewController alloc]init];
    DYFollowViewController   *followVC     = [[DYFollowViewController alloc]init];
    DYChatListViewController *chatlistVC   = [[DYChatListViewController alloc]init];
    DYMineViewController     *mineVC       = [[DYMineViewController alloc]init];
    
    UIViewController         *homeNavi     = [[CYLBaseNavigationController alloc]initWithRootViewController:homeVC];
    UIViewController         *followNavi   = [[CYLBaseNavigationController alloc]initWithRootViewController:followVC];
    UIViewController         *chatlistNavi = [[CYLBaseNavigationController alloc]initWithRootViewController:chatlistVC];
    UIViewController         *mineNavi     = [[CYLBaseNavigationController alloc]initWithRootViewController:mineVC];

    NSArray *viewControllers = @[homeNavi,followNavi,chatlistNavi,mineNavi];
    
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController{
    
    
    NSDictionary *firstTabBarItemsAttributes = @{CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"ic_home_unselect",
                                                 CYLTabBarItemSelectedImage : @"ic_home_select",};
    NSDictionary *secondTabBarItemsAttributes = @{CYLTabBarItemTitle : @"关注",
                                                  CYLTabBarItemImage : @"ic_score_unselect",
                                                  CYLTabBarItemSelectedImage : @"ic_score_select",};
    NSDictionary *thirdTabBarItemsAttributes = @{CYLTabBarItemTitle : @"消息",
                                                 CYLTabBarItemImage : @"ic_chat_unselect",
                                                 CYLTabBarItemSelectedImage : @"ic_chat_select"};
    
    NSDictionary *fourthTabBarItemsAttributes= @{CYLTabBarItemTitle : @"我",
                                                 CYLTabBarItemImage : @"ic_mine_unselect",
                                                 CYLTabBarItemSelectedImage : @"ic_mine_select"};
    
    NSArray *tabBarItemsAttributesForController = @[firstTabBarItemsAttributes,
                                                    secondTabBarItemsAttributes,
                                                    thirdTabBarItemsAttributes,
                                                    fourthTabBarItemsAttributes];
    
    return tabBarItemsAttributesForController;
}
@end




