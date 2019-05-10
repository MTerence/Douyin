//
//  DYUserHomeController.m
//  Douyin
//
//  Created by Ternence on 2019/5/10.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYUserHomeController.h"
#import "DYMineContentScrollView.h"
#import "DYMineDynamicsTableView.h"
#import "DYMineUserInfoHeader.h"
#import "LXDSegmentControl.h"

#define kHeaderViewHeight     DY_SCALE_WIDTH(400)
#define kSegmentControlHeight DY_SCALE_WIDTH(40)

@interface DYUserHomeController ()<UIScrollViewDelegate,UITableViewDelegate,LXDSegmentControlDelegate>

@property (nonatomic, strong) DYMineUserInfoHeader *headerView;

@property (nonatomic, strong) UIView *tableViewHeaderView;

@property (nonatomic, strong) DYMineContentScrollView *scrollView;

@property (nonatomic, strong) DYMineDynamicsTableView *tableView1;
@property (nonatomic, strong) DYMineDynamicsTableView *tableView2;
@property (nonatomic, strong) DYMineDynamicsTableView *tableView3;

@property (nonatomic, strong) LXDSegmentControl *segmentControl;

@end

@implementation DYUserHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContentView];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    [self setupHeaderView];
}

- (void)setupContentView{
//    self.scrollView = [[DYMineContentScrollView alloc]init];
    self.scrollView = [[DYMineContentScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT)];
    self.scrollView.delaysContentTouches = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView = self.scrollView;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *3, 0);
    
    self.tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderViewHeight+kSegmentControlHeight)];
    self.tableViewHeaderView.backgroundColor = [UIColor blueColor];
    
    self.tableView1 = [[DYMineDynamicsTableView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
    self.tableView1.delegate = self;
    self.tableView1.tableHeaderView = self.tableViewHeaderView;
    [self.scrollView addSubview:self.tableView1];
    
    self.tableView2 = [[DYMineDynamicsTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
    self.tableView2.delegate = self;
    self.tableView2.tableHeaderView = self.tableViewHeaderView;
    [self.scrollView addSubview:self.tableView2];
    
    self.tableView3 = [[DYMineDynamicsTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
    self.tableView3.delegate = self;
    self.tableView3.tableHeaderView = self.tableViewHeaderView;
    [self.scrollView addSubview:self.tableView3];
}

- (void)setupHeaderView{
    self.headerView = [[DYMineUserInfoHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderViewHeight+ kSegmentControlHeight)];
    [self.view addSubview:self.headerView];
    
    [self.headerView addSubview:self.segmentControl];
    
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.top.mas_equalTo(self.headerView.top);
//    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView || !scrollView.window) {
        return;
    }
    CGFloat offsetY      = scrollView.contentOffset.y;
    NSLog(@"-------offsetY:%lf",offsetY);
    CGFloat originY      = 0;
    CGFloat otherOffsetY = 0;
    if (offsetY <= kHeaderViewHeight) {
        originY              = -offsetY;
        if (offsetY < 0) {
            otherOffsetY         = 0;
        } else {
            otherOffsetY         = offsetY;
        }
    } else {
        originY              = -kHeaderViewHeight;
        otherOffsetY         = kHeaderViewHeight;
    }
    
    self.headerView.frame = CGRectMake(0, originY + NAVIBar_H, SCREEN_WIDTH, kHeaderViewHeight+kSegmentControlHeight);
    for ( int i = 0; i < 3; i++ ) {
        // 解决 UITableView 高度问题
        UITableView *contentView = self.scrollView.subviews[i];
        if (contentView.contentSize.height < SCREEN_HEIGHT + kHeaderViewHeight - kSegmentControlHeight) {
            contentView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + kHeaderViewHeight - kSegmentControlHeight);
        }
        if (i != self.segmentControl.currentIndex) {
            CGPoint offset = CGPointMake(0, otherOffsetY);
            if ([contentView isKindOfClass:[UITableView class]]) {
                if (contentView.contentOffset.y < kHeaderViewHeight || offset.y < kHeaderViewHeight) {
                    [contentView setContentOffset:offset animated:NO];
                    self.scrollView.offset = offset;
                }
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        NSInteger index = offsetX/SCREEN_WIDTH + 0.5;
        [self.segmentControl setCurrentIndex:index];
    }
}

- (void)segmentControl:(LXDSegmentControl *)segmentControl didSelectAtIndex:(NSUInteger)index{
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (LXDSegmentControl *)segmentControl{
    if (_segmentControl == nil) {
        LXDSegmentControlConfiguration * configuration = [LXDSegmentControlConfiguration configurationWithControlType: LXDSegmentControlTypeSlideBlock items: @[@"作品 18",@"动态 18",@"喜欢 213"]];
        //使用配置对象创建分栏控制器
        _segmentControl = [LXDSegmentControl segmentControlWithFrame:CGRectMake(0, kHeaderViewHeight, SCREEN_WIDTH, kSegmentControlHeight) configuration: configuration delegate: self];
    }
    return _segmentControl;
}


@end
