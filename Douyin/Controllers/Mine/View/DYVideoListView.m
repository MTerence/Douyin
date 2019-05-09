//
//  DYVideoListView.m
//  Douyin
//
//  Created by Ternence on 2019/5/7.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYVideoListView.h"
#import "DYVideoListCollectionCell.h"

#define itemWidth   (self.width/3.0f - 1)
#define itemHeight  (itemWidth * 1.35f)
NSString *const kVideoListCollectionCell = @"DYVideoListCollectionCell";

@interface DYVideoListView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation DYVideoListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    DYVideoListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoListCollectionCell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Getter and setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DYVideoListCollectionCell class] forCellWithReuseIdentifier:kVideoListCollectionCell];
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.inputViewController.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}



@end
