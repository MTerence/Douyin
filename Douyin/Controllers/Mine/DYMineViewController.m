//
//  DYMineViewController.m
//  Douyin
//
//  Created by Ternence on 2019/5/6.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYMineViewController.h"
#import "DYMineTableHeader.h"
#import "DYMineTableCell.h"
#import "DYVideoListView.h"
#import "DYMineTableSectionHeader.h"
#import "DYMineVerticalCollectionLayout.h"
#import "DYMineVerticalCollectionCell.h"
#import "DYMineVerticalCollectionHeader.h"
#import "GKPageScrollView.h"
#import "LXDSegmentControl.h"
#import "DYVideoListController.h"

NSString *const kDYMineTableCell = @"DYMineTableCell";
NSString *const kDYMineVerticalCollectionCell = @"DYMineVerticalCollectionCell";
NSString *const kDYMineVerticalCollectionHeader = @"DYMineVerticalCollectionHeader";

#define kHeaderViewHeight  DY_SCALE_WIDTH(450) + NAVIBar_H
#define kSliderBarHeight   DY_SCALE_WIDTH(40)

@interface DYMineViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, GKPageScrollViewDelegate, LXDSegmentControlDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) DYMineTableHeader         *tableHeader;
@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, strong) DYMineTableSectionHeader  *sectionHeader;
@property (nonatomic, strong) DYMineVerticalCollectionHeader *collectionHeader;

//new
@property (nonatomic, strong) GKPageScrollView *pageScrollView;

@property (nonatomic, strong) UIView            *pageView;
@property (nonatomic, strong) LXDSegmentControl *segmentControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *childVCs;


@end

@implementation DYMineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarClear];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    DYVideoListView *view = [[DYVideoListView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:view];
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
//    [self.view addSubview:self.tableView];
//    [self.tableView setTableHeaderView:self.tableHeader];
    
    
//    [self.view addSubview:self.verticalCollectionView];
    
    [self.view addSubview:self.pageScrollView];
    [self.pageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.pageScrollView reloadData];
}

#pragma mark - GKPageScrollViewDelegate
- (BOOL)shouldLazyLoadListInPageScrollView:(GKPageScrollView *)pageScrollView{
    return NO;
}

- (UIView *)headerViewInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.tableHeader;
}

- (UIView *)pageViewInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.pageView;
}

- (NSArray<id<GKPageListViewDelegate>> *)listViewsInPageScrollView:(GKPageScrollView *)pageScrollView{
    return self.childVCs;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView isMainCanScroll:(BOOL)isMainCanScroll{
    CGFloat offsetY = scrollView.contentOffset.y;
    //NSLog(@"-------content.y: %lf",offsetY);
    
    if (isMainCanScroll == NO) {
        if (scrollView.isDecelerating == YES) {
            NSLog(@"isDecelerating");
        }
    }
}

- (void)delegate_scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset isMainCanScroll:(BOOL)isMainCanScroll{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (isMainCanScroll == NO) {
        for (DYVideoListController *controller in self.childVCs) {
            
            [controller.collectionView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, velocity.y * 30) animated:YES];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSLog(@"=======volic.y: %lf",velocity.y );
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.pageScrollView horizonScrollViewWillBeginScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.pageScrollView horizonScrollViewDidEndedScroll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

#pragma mark - getters and setters
- (GKPageScrollView *)pageScrollView{
    if (_pageScrollView == nil) {
        _pageScrollView = [[GKPageScrollView alloc]initWithDelegate:self];
    }
    return _pageScrollView;
}

- (UIView *)pageView{
    if (_pageView == nil) {
        _pageView = [UIView new];
        _pageView.backgroundColor = [UIColor clearColor];
    
        [_pageView addSubview:self.segmentControl];
        [_pageView addSubview:self.scrollView];
    }
    return _pageView;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        CGFloat scrollW = SCREEN_WIDTH;
        CGFloat scrollH = SCREEN_HEIGHT - NAVIBar_H - 40.0f;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, scrollW, scrollH)];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.childVCs enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController:vc];
            [self->_scrollView addSubview:vc.view];
            
            vc.view.frame = CGRectMake(idx * scrollW, 0, scrollW, scrollH);
        }];
        _scrollView.contentSize = CGSizeMake(self.childVCs.count * scrollW, 0);
        
    }
    return _scrollView;
}

- (LXDSegmentControl *)segmentControl{
    if (_segmentControl == nil) {
        LXDSegmentControlConfiguration * configuration = [LXDSegmentControlConfiguration configurationWithControlType: LXDSegmentControlTypeSlideBlock items: self.titles];
        //使用配置对象创建分栏控制器
        _segmentControl = [LXDSegmentControl segmentControlWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DY_SCALE_WIDTH(40)) configuration: configuration delegate: self];
    }
    return _segmentControl;
}

- (NSArray *)titles{
    if (_titles == nil) {
        _titles = @[@"作品 18",@"动态 18",@"喜欢 213"];
    }
    return _titles;
}

- (NSArray *)childVCs{
    if (_childVCs == nil) {
        
        DYVideoListController *listVC = [[DYVideoListController alloc]init];
        DYVideoListController *listVC1 = [[DYVideoListController alloc]init];
        DYVideoListController *listVC2 = [[DYVideoListController alloc]init];
        _childVCs = @[listVC, listVC1, listVC2];
    }
    return _childVCs;
}

#pragma mark - UITabBarDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 500;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DYMineTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kDYMineTableCell];
    if (!cell) {
        cell = [[DYMineTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDYMineTableCell];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return DY_SCALE_WIDTH(40);
    }
    return 0;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return self.sectionHeader;
//    }
//
//    return [UIView new];
//}

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"=======offsetY: %lf", offsetY);
    DYMineVerticalCollectionCell *cell = (DYMineVerticalCollectionCell *)[self.verticalCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    DYMineHorizontalCollectionCell *horizontalCell = (DYMineHorizontalCollectionCell *)[cell.horizontalCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    if (offsetY < 0) {
        [self.collectionHeader tableDidScroll:offsetY];
        horizontalCell.videoList.collectionView.scrollEnabled = NO;
//        [self.tableHeader tableDidScroll:offsetY];
    }else{
        [self updateNaviBar:offsetY];

        
        horizontalCell.videoList.collectionView.scrollEnabled = YES;
    }
}

 */
- (void)updateNaviBar:(CGFloat)offsetY{
    if (kHeaderViewHeight - self.navigationController.navigationBar.height*2 > offsetY) {
        [self setNavigationBarClear];
    }
    
    if (kHeaderViewHeight - self.navigationController.navigationBar.height*2 < offsetY && offsetY < kHeaderViewHeight - self.navigationController.navigationBar.height) {
        CGFloat alphaRatio =  1.0f - (kHeaderViewHeight - self.navigationController.navigationBar.height - offsetY)/self.navigationController.navigationBar.height;
        UIColor *color = [UIColor colorWithR:31 g:34 b:44 a:alphaRatio];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
    }
    
    if (offsetY > kHeaderViewHeight - self.navigationController.navigationBar.height) {
        [self setNavigationBarNoneClear];
    }
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DYMineVerticalCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDYMineVerticalCollectionCell forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && kind == UICollectionElementKindSectionHeader) {
        DYMineVerticalCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDYMineVerticalCollectionHeader forIndexPath:indexPath];
        self.collectionHeader = header;
        return header;
    }
    
    return [UICollectionReusableView new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, kHeaderViewHeight);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}


#pragma mark - Getter and setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[DYMineTableCell class] forCellReuseIdentifier:kDYMineTableCell];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (DYMineTableHeader *)tableHeader{
    if (!_tableHeader) {
        _tableHeader = [[DYMineTableHeader alloc]initWithFrame:CGRectMake(0, -0, SCREEN_WIDTH, kHeaderViewHeight)];
    }
    return _tableHeader;
}

- (DYMineTableSectionHeader *)sectionHeader{
    if (_sectionHeader == nil) {
        _sectionHeader = [[DYMineTableSectionHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DY_SCALE_WIDTH(40))];
    }
    return _sectionHeader;
}

- (UICollectionView *)verticalCollectionView{
    if (_verticalCollectionView == nil) {
        DYMineVerticalCollectionLayout *layout = [[DYMineVerticalCollectionLayout alloc]initWithTopHeight:NAVIBar_H + kSliderBarHeight];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        
        _verticalCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderViewHeight + SCREEN_WIDTH/3 * 1.35) collectionViewLayout:layout];
        _verticalCollectionView.backgroundColor = [UIColor clearColor];
        _verticalCollectionView.delegate = self;
        _verticalCollectionView.dataSource = self;
        _verticalCollectionView.clipsToBounds = NO;
        _verticalCollectionView.alwaysBounceVertical = YES;
        _verticalCollectionView.showsVerticalScrollIndicator = NO;
        
        [_verticalCollectionView registerClass:[DYMineVerticalCollectionCell class] forCellWithReuseIdentifier:kDYMineVerticalCollectionCell];
        [_verticalCollectionView registerClass:[DYMineVerticalCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDYMineVerticalCollectionHeader];
        if (@available(iOS 11.0, *)) {
            _verticalCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _verticalCollectionView;
}

@end
