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
#import "DYVideoListCollectionView.h"
#import "DYUserDynamicsTableView.h"
#import "DYUserModel.h"
#import "DYAwemeModel.h"
#import "DYUserResponse.h"
#import "DYAwemeListResponse.h"
#import "DYAwemePlayListController.h"

#define itemWidth   (self.view.width/3.0f - 1)
#define itemHeight  (itemWidth * 1.35f)
//#define itemWidth   ((SCREEN_WIDTH - (CGFloat)(((NSInteger)(SCREEN_WIDTH)) % 3)) / 3.0f - 1.0f)

@interface DYUserHomeController ()
<UIScrollViewDelegate,
UITableViewDelegate,
DYVideoListCollectionViewDelegate,
DYUserDynamicsTableView,
DYUserInfoHeaderDelegate>

/** userInfoHader */
@property (nonatomic, strong) DYMineUserInfoHeader      *userInfoHeader;
/** scrollView 纵向滑动的tableview和collectionview 上层*/
@property (nonatomic, strong) DYMineContentScrollView   *scrollView;
/** 个人作品listView */
@property (nonatomic, strong) DYVideoListCollectionView *userWorkVideoList;
/** 用户动态listView */
@property (nonatomic, strong) DYUserDynamicsTableView   *userDynamicsTableView;
/** 用户喜欢的视频listView */
@property (nonatomic, strong) DYVideoListCollectionView *userLikeVideoList;
/** 个人作品Array */
@property (nonatomic, strong) NSMutableArray<DYAwemeModel *> *userWorkAwemeArray;
/** 个人动态Array */
@property (nonatomic, strong) NSMutableArray *dynamicsArray;
/** 个人喜欢视频Array */
@property (nonatomic, strong) NSMutableArray *likeVideosArray;
/** userModel */
@property (nonatomic, strong) DYUserModel *userModel;

@end

@implementation DYUserHomeController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarClear];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setTitle:@"Amen"];
    [self setRightBtnWithNormalName:@"icon_titlebar_addfriend" highName:@"" selectName:@""];
    [self setupContentView];
    
    [self setupHeaderView];
    
    [self loadData_UserInfo];
    [self loadData_UserWorkVideoList];
    
//    CGFloat i =  (SCREEN_WIDTH - (CGFloat)(((NSInteger)(SCREEN_WIDTH)) % 3)) / 3.0f - 1.0f;
}


#pragma mark - 数据请求
- (void)loadData_UserInfo{
    
    __weak typeof(self)weakSelf = self;
    NSDictionary *params = @{@"uid":@"97795069353"};
    [NetworkRequestTool GetWithURL:kURL_UserInfo params:params success:^(id  _Nonnull json) {
        NSLog(@"--json: %@",json);
        DYUserResponse *response = [DYUserResponse mj_objectWithKeyValues:json];
        
        weakSelf.userModel = response.data;
        weakSelf.userInfoHeader.userModel = weakSelf.userModel;
        [weakSelf setTitle:weakSelf.userModel.nickname];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)loadData_UserWorkVideoList{
    __weak typeof(self)weakSelf = self;
    NSDictionary *params = @{@"page":@"1",@"size":@"10",@"uid":@"97795069353"};
    
    [NetworkRequestTool GetWithURL:kURL_UserWorkVideoList params:params success:^(id  _Nonnull json) {
        NSLog(@"--json: %@",json);
        DYAwemeListResponse *response = [DYAwemeListResponse mj_objectWithKeyValues:json];
        [weakSelf.userWorkAwemeArray addObjectsFromArray:response.data];
        weakSelf.userWorkVideoList.awemesArray = weakSelf.userWorkAwemeArray;
        [weakSelf.userWorkVideoList refresh];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupContentView{

    [self.view addSubview:self.scrollView];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    [self.scrollView addSubview:self.userWorkVideoList];
    [self.scrollView addSubview:self.userDynamicsTableView];
    [self.scrollView addSubview:self.userLikeVideoList];
    
    if (@available(iOS 11.0, *)) {
        self.userWorkVideoList.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.userLikeVideoList.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.userDynamicsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupHeaderView{
    self.userInfoHeader = [[DYMineUserInfoHeader alloc]initWithFrame:CGRectMake(0, -NAVIBar_H, SCREEN_WIDTH, kHeaderViewHeight + kSegmentControlHeight)];
    self.userInfoHeader.userInfoDelegate = self;
    [self.view addSubview:self.userInfoHeader];
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
    
    if (offsetY >= kHeaderViewHeight - NAVIBar_H) {
        self.userInfoHeader.frame = CGRectMake(0, -kHeaderViewHeight, SCREEN_WIDTH, kHeaderViewHeight+kSegmentControlHeight);
    }else{
        self.userInfoHeader.frame = CGRectMake(0, originY-NAVIBar_H, SCREEN_WIDTH, kHeaderViewHeight+kSegmentControlHeight);
    }
    
    for ( int i = 0; i < 3; i++ ) {
        // 解决 UITableView 高度问题
//        UITableView *contentView = self.scrollView.subviews[i];
        UIScrollView *contentView = self.scrollView.subviews[i];
        if (contentView.contentSize.height < SCREEN_HEIGHT + kHeaderViewHeight - kSegmentControlHeight) {
            contentView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + kHeaderViewHeight - kSegmentControlHeight);
        }
        
        if (i != self.userInfoHeader.segmentControl.currentIndex) {
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
        [self.userInfoHeader tableDidScroll:offsetY];
    }else{
        [self.userInfoHeader scrollToTopAction:offsetY];
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
        [self.userInfoHeader setSegmentCurrentIndex:index];
    }
}

- (void)delegate_segmentControl:(LXDSegmentControl *)segmentControl didSelectAtIndex:(NSUInteger)index{
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}

#pragma mark - delegate
- (void)delegate_videoList:(DYVideoListCollectionView *)videoList scrollDidScroll:(CGPoint)offset{
    [self scrollViewDidScroll:videoList];
}

- (void)delegate_videoList:(DYVideoListCollectionView *)videoList didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DYAwemePlayListController *vc = [[DYAwemePlayListController alloc]initWithVideoData:self.userWorkAwemeArray currentIndex:indexPath.item pageIndex:10 pageSize:10 uid:@""];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)delegate_dynamicsList:(DYUserDynamicsTableView *)dynamicsList scrollDidScroll:(CGPoint)offset{
    [self scrollViewDidScroll:dynamicsList];
}


#pragma mark - getter and setter
- (DYMineContentScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[DYMineContentScrollView alloc]initWithFrame:CGRectMake(0, -NAVIBar_H, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT)];
        _scrollView.delaysContentTouches = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH *3, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (DYUserDynamicsTableView *)userDynamicsTableView{
    if (_userDynamicsTableView == nil) {
        _userDynamicsTableView = [[DYUserDynamicsTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
        _userDynamicsTableView.dynamicsDelegate = self;
    }
    return _userDynamicsTableView;
}

- (DYVideoListCollectionView *)userWorkVideoList{
    if (_userWorkVideoList == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _userWorkVideoList = [[DYVideoListCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height) collectionViewLayout:layout];
        _userWorkVideoList.backgroundColor = [UIColor clearColor];
        _userWorkVideoList.videoListDelegate = self;
    }
    return _userWorkVideoList;
}

- (DYVideoListCollectionView *)userLikeVideoList{
    if (_userLikeVideoList == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _userLikeVideoList = [[DYVideoListCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, self.scrollView.width, self.scrollView.height) collectionViewLayout:layout];
        _userLikeVideoList.backgroundColor = [UIColor clearColor];
        _userLikeVideoList.videoListDelegate = self;
    }
    return _userLikeVideoList;
}

- (NSMutableArray<DYAwemeModel *> *)userWorkAwemeArray{
    if (_userWorkAwemeArray == nil) {
        _userWorkAwemeArray = [NSMutableArray array];
    }
    return _userWorkAwemeArray;
}

@end
