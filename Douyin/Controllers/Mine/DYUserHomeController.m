//
//  DYUserHomeController.m
//  Douyin
//
//  Created by Ternence on 2019/5/10.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYUserHomeController.h"
#import "DYMineContentScrollView.h"
#import "DYMineUserInfoHeader.h"
#import "LXDSegmentControl.h"
#import "DYVideoListView.h"
#import "DYVideoListCollectionView.h"
#import "DYUserDynamicsTableView.h"

//#define kHeaderViewHeight     DY_SCALE_WIDTH(470)
//#define kSegmentControlHeight DY_SCALE_WIDTH(40)
#define itemWidth   (self.view.width/3.0f - 1)
#define itemHeight  (itemWidth * 1.35f)

@interface DYUserHomeController ()<UIScrollViewDelegate,UITableViewDelegate,LXDSegmentControlDelegate,DYVideoListViewDelegate,DYVideoListCollectionViewDelegate,DYUserDynamicsTableView>

@property (nonatomic, strong) DYMineUserInfoHeader *headerView;

@property (nonatomic, strong) UIView *tableViewHeaderView;

@property (nonatomic, strong) DYMineContentScrollView *scrollView;

@property (nonatomic, strong) DYUserDynamicsTableView *tableView1;
@property (nonatomic, strong) DYUserDynamicsTableView *tableView2;
@property (nonatomic, strong) DYUserDynamicsTableView *tableView3;

@property (nonatomic, strong) LXDSegmentControl *segmentControl;


/** 我的作品listView */
@property (nonatomic, strong) DYVideoListView *myVideoList;

/** 我的作品listView */
@property (nonatomic, strong) DYVideoListCollectionView *myVideos;

/** 我喜欢的视频listView */
@property (nonatomic, strong) DYVideoListCollectionView *mylikeVideoList;


@end

@implementation DYUserHomeController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarClear];
//    [self setNavigationBarNoneClear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Amen"];
    [self setupContentView];
    
    [self setupHeaderView];
}

- (void)setupContentView{
    self.scrollView = [[DYMineContentScrollView alloc]initWithFrame:CGRectMake(0, -NAVIBar_H, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT)];
    self.scrollView.delaysContentTouches = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView = self.scrollView;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *3, 0);
    
    self.tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderViewHeight+kSegmentControlHeight)];
    self.tableViewHeaderView.backgroundColor = [UIColor blueColor];
    
//    self.tableView1 = [[DYUserDynamicsTableView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
//    self.tableView1.delegate = self;
//    self.tableView1.tableHeaderView = self.tableViewHeaderView;
//    [self.scrollView addSubview:self.tableView1];
    
//    self.myVideoList = [[DYVideoListView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
//    self.myVideoList.delegate = self;
//    [self.scrollView addSubview:self.myVideoList];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.myVideos = [[DYVideoListCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) collectionViewLayout:layout];
    self.myVideos.backgroundColor = [UIColor clearColor];
    self.myVideos.videoListDelegate = self;
    if (@available(iOS 11.0, *)) {
        self.myVideos.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.scrollView addSubview:self.myVideos];
    
    self.tableView2 = [[DYUserDynamicsTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
    self.tableView2.dynamicsDelegate = self;
    self.tableView2.tableHeaderView = self.tableViewHeaderView;
    [self.scrollView addSubview:self.tableView2];
    
    UICollectionViewFlowLayout *likeVideosLayout = [[UICollectionViewFlowLayout alloc]init];
    likeVideosLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    likeVideosLayout.minimumLineSpacing = 1;
    likeVideosLayout.minimumInteritemSpacing = 1;
    likeVideosLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.mylikeVideoList = [[DYVideoListCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, self.scrollView.width, self.scrollView.height) collectionViewLayout:layout];
    self.mylikeVideoList.backgroundColor = [UIColor clearColor];
    self.mylikeVideoList.videoListDelegate = self;
    if (@available(iOS 11.0, *)) {
        self.mylikeVideoList.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.scrollView addSubview:self.mylikeVideoList];
}

- (void)setupHeaderView{
    self.headerView = [[DYMineUserInfoHeader alloc]initWithFrame:CGRectMake(0, -NAVIBar_H, SCREEN_WIDTH, kHeaderViewHeight+ kSegmentControlHeight)];
    [self.view addSubview:self.headerView];
    
    [self.headerView addSubview:self.segmentControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView || !scrollView.window) {
        return;
    }
    CGFloat offsetY      = scrollView.contentOffset.y;
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

    NSLog(@"======originy: %lf  %lf  %lf",offsetY, originY, kHeaderViewHeight - kSegmentControlHeight);
    
    if (offsetY >= kHeaderViewHeight - NAVIBar_H) {
        self.headerView.frame = CGRectMake(0, -kHeaderViewHeight, SCREEN_WIDTH, kHeaderViewHeight+kSegmentControlHeight);
    }else{
        self.headerView.frame = CGRectMake(0, originY-NAVIBar_H, SCREEN_WIDTH, kHeaderViewHeight+kSegmentControlHeight);
    }
    
    for ( int i = 0; i < 3; i++ ) {
        // 解决 UITableView 高度问题
//        UITableView *contentView = self.scrollView.subviews[i];
        UIScrollView *contentView = self.scrollView.subviews[i];
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
    
    if (offsetY < 0) {
        [self.headerView tableDidScroll:offsetY];
    }else{
        [self.headerView scrollToTopAction:offsetY];
        [self updateNaviBar:offsetY];
    }
}

- (void)updateNaviBar:(CGFloat)offsetY{

    if (kHeaderViewHeight - self.navigationController.navigationBar.height*2 > offsetY) {
        [self setNavigationBarTitleColor:[UIColor clearColor]];
        
    }
    
    if (kHeaderViewHeight - self.navigationController.navigationBar.height*2 < offsetY && offsetY < kHeaderViewHeight - self.navigationController.navigationBar.height) {
        CGFloat alphaRatio =  1.0f - (kHeaderViewHeight - self.navigationController.navigationBar.height - offsetY)/self.navigationController.navigationBar.height;
        UIColor *color = [UIColor colorWithR:1.0f g:1.0f b:1.0f a:alphaRatio];
        [self setNavigationBarTitleColor:color];
    }
    
    if (offsetY > kHeaderViewHeight - self.navigationController.navigationBar.height) {
        [self setNavigationBarTitleColor:[UIColor whiteColor]];
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

#pragma mark - delegate
- (void)delegate_videoList:(DYVideoListCollectionView *)videoList scrollDidScroll:(CGPoint)offset{
    [self scrollViewDidScroll:videoList];
}

- (void)delegate_dynamicsList:(DYUserDynamicsTableView *)dynamicsList scrollDidScroll:(CGPoint)offset{
    [self scrollViewDidScroll:dynamicsList];
}

- (LXDSegmentControl *)segmentControl{
    if (_segmentControl == nil) {
        LXDSegmentControlConfiguration * configuration = [LXDSegmentControlConfiguration configurationWithControlType: LXDSegmentControlTypeSlideBlock items: @[@"作品 18",@"动态 18",@"喜欢 213"]];
        //使用配置对象创建分栏控制器
        _segmentControl = [LXDSegmentControl segmentControlWithFrame:CGRectMake(0, kHeaderViewHeight, SCREEN_WIDTH, kSegmentControlHeight) configuration: configuration delegate: self];
        _segmentControl.backgroundColor = [UIColor redColor];
    }
    return _segmentControl;
}


@end
