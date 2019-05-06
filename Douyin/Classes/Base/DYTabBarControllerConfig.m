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

- (CYLTabBarController *)tabBarController{
    if (_tabBarController == nil) {
        /**
         * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
         * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
         * 更推荐后一种做法。
         */
        UIEdgeInsets imageInsets = UIEdgeInsetsZero;
        UIOffset titlePositionAdjustment = UIOffsetZero;
        
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                 
                                                                                   tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                             imageInsets:imageInsets
                                                 
                                                                                 titlePositionAdjustment:titlePositionAdjustment
                                                                                                 context:self.context
                                                 ];
        [self customizeTabBarAppearance:tabBarController];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}


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

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
#warning CUSTOMIZE YOUR TABBAR APPEARANCE
    // Customize UITabBar height
    // 自定义 TabBar 高度
//        tabBarController.tabBarHeight = CYL_IS_IPHONE_X ? 65 : 44;
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#666666"];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#F2438E"];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    //    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    UITabBar *tabBarAppearance = [UITabBar appearance];
    
    //FIXED: #196
    UIImage *tabBarBackgroundImage = [UIImage imageNamed:@"tab_bar"];
    UIImage *scanedTabBarBackgroundImage = [[self class] scaleImage:tabBarBackgroundImage toScale:1.0];
    //     [tabBarAppearance setBackgroundImage:scanedTabBarBackgroundImage];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    // iOS10 后 需要使用 `-[CYLTabBarController hideTabBadgeBackgroundSeparator]` 见 AppDelegate 类中的演示;
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake([UIScreen mainScreen].bounds.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end




