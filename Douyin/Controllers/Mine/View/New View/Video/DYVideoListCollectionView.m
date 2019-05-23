//
//  DYVideoListCollectionView.m
//  Douyin
//
//  Created by Ternence on 2019/5/14.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYVideoListCollectionView.h"
#import "DYVideoListCollectionCell.h"
#import "DYVideoListCollectionHeader.h"

#define itemWidth   (self.width/3.0f - 1)
#define itemHeight  (itemWidth * 1.35f)

#define kVideoListCollectionCell @"DYVideoListCollectionCell"
#define kDYVideoListCollectionHeader @"DYVideoListCollectionHeader"
//NSString *const kVideoListCollectionCell = @"DYVideoListCollectionCell";
//NSString *const kDYVideoListCollectionHeader = @"DYVideoListCollectionHeader";

@interface DYVideoListCollectionView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation DYVideoListCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        [self setCollectionViewLayout:layout];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[DYVideoListCollectionCell class] forCellWithReuseIdentifier:kVideoListCollectionCell];
        [self registerClass:[DYVideoListCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDYVideoListCollectionHeader];
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.inputViewController.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[DYVideoListCollectionCell class] forCellWithReuseIdentifier:kVideoListCollectionCell];
        [self registerClass:[DYVideoListCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDYVideoListCollectionHeader];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.awemesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    DYVideoListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoListCollectionCell forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        DYVideoListCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDYVideoListCollectionHeader forIndexPath:indexPath];
        return header;
    }
    
    return [UICollectionReusableView new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, kHeaderViewHeight + kSegmentControlHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.videoListDelegate && [self.videoListDelegate respondsToSelector:@selector(delegate_videoList:scrollDidScroll:)]) {
        [self.videoListDelegate delegate_videoList:self scrollDidScroll:scrollView.contentOffset];
    }
}


#pragma mark - publish methond
- (void)refresh{
    [self reloadData];
}

#pragma mark - Getter and setter
- (NSMutableArray <DYAwemeModel *>*)awemesArray{
    if (_awemesArray == nil) {
        _awemesArray = [NSMutableArray array];
    }
    return _awemesArray;
}


@end
