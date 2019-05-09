//
//  DYMineVerticalCollectionCell.m
//  Douyin
//
//  Created by Ternence on 2019/5/9.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYMineVerticalCollectionCell.h"

NSString *const kDYMineHorizontalCollectionCell = @"DYMineHorizontalCollectionCell";

@interface DYMineVerticalCollectionCell ()<UICollectionViewDelegate, UICollectionViewDataSource>



@end

@implementation DYMineVerticalCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.horizontalCollectionView];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    DYMineHorizontalCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDYMineHorizontalCollectionCell forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.backgroundColor = [UIColor redColor];
    }else if (indexPath.item == 1){
        cell.backgroundColor = [UIColor lightGrayColor];
    }else{
        cell.backgroundColor = [UIColor yellowColor];
    }
    return cell;
}

- (UICollectionView *)horizontalCollectionView{
    if (_horizontalCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing =1;
        layout.minimumInteritemSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.width, self.height);
        
        _horizontalCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _horizontalCollectionView.delegate = self;
        _horizontalCollectionView.dataSource = self;
        _horizontalCollectionView.pagingEnabled = YES;
        
        [_horizontalCollectionView registerClass:[DYMineHorizontalCollectionCell class] forCellWithReuseIdentifier:kDYMineHorizontalCollectionCell];
        
        //设置collection不偏移
        if (@available(iOS 11.0, *)) {
            _horizontalCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _horizontalCollectionView;
}

@end
