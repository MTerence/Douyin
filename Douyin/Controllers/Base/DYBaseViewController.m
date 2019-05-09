//
//  DYBaseViewController.m
//  Douyin
//
//  Created by Ternence on 2019/5/6.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYBaseViewController.h"

@interface DYBaseViewController ()

@end

@implementation DYBaseViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
}

#pragma mark - 设置导航栏
- (void)setNavigationBar{
    self.navigationController.navigationBar.hidden = NO;
    
    //隐藏导航栏分割线
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    UIView *navLine = backgroundView.subviews.firstObject;
    navLine.hidden = YES;
    
    //导航栏颜色
    self.navigationController.navigationBar.barTintColor = kNaviBarNormalColor;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 设置导航栏背景是否透明
- (void)setNavigationBarClear{
    //设置导航栏背景色为透明色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去除导航栏透明时导航栏下方的阴影
     [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)setNavigationBarNoneClear{
    //设置导航栏背景色为非透明色
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //导航栏透明时导航栏下方的阴影
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark - 设置返回按钮
- (void)setBackBtnWithNormalName:(NSString *)normalName
                     highName:(NSString *)highName
            selectedName:(NSString *)selectedName{
    NSString *path = [NSString stringWithFormat:@"%@.png",normalName];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 38, 44);
    UIImage *normaleImage = [UIImage imageNamed:path];
    [leftButton setImage:normaleImage forState:UIControlStateNormal];
    
    path = [NSString stringWithFormat:@"%@.png",highName];
    [leftButton setImage:[UIImage imageNamed:path] forState:UIControlStateHighlighted];
    
    path = [NSString stringWithFormat:@"%@.png",selectedName];
    [leftButton setImage:[UIImage imageNamed:path] forState:UIControlStateSelected];
    
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(4, -8, 4, 8)];
    [leftButton addTarget:self action:@selector(action_onBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationItem setLeftBarButtonItem:item];
}

- (void)action_onBackBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 导航栏右按钮
- (void)setRightBtnWithNormalName:(NSString *)normalName highName:(NSString *)highName selectName:(NSString *)selectName{
    NSString *path = [NSString stringWithFormat:@"%@.png",normalName];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 38, 44);
    UIImage *normaleImage = [UIImage imageNamed:path];
    [rightButton setImage:normaleImage forState:UIControlStateNormal];
    
    path = [NSString stringWithFormat:@"%@.png",highName];
    [rightButton setImage:[UIImage imageNamed:path] forState:UIControlStateHighlighted];
    
    path = [NSString stringWithFormat:@"%@.png",selectName];
    [rightButton setImage:[UIImage imageNamed:path] forState:UIControlStateSelected];
    
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(4, -8, 4, 8)];
    [rightButton addTarget:self action:@selector(action_onRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationItem setLeftBarButtonItem:item];
}

- (void)action_onRightBtnClick:(UIButton *)sender{
    
}


@end
