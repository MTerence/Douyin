//
//  DYVideoListController.m
//  Douyin
//
//  Created by Ternence on 2019/5/9.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYVideoListController.h"
#import "DYVideoListCollectionCell.h"
#import "GKPageScrollView.h"

#define itemWidth   (self.view.width/3.0f - 1)
#define itemHeight  (itemWidth * 1.35f)
NSString *const kVideoListControllerCollectionCell = @"DYVideoListCollectionCell";

@interface DYVideoListController ()<UICollectionViewDelegate, UICollectionViewDataSource,GKPageListViewDelegate>

@property (nonatomic, copy) void(^listScrollViewScrollBlock)(UIScrollView *scrollView);


@end

@implementation DYVideoListController

- (void)viewDidLoad{
    [self setupUI];
}

- (void)setupUI{
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    DYVideoListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoListControllerCollectionCell forIndexPath:indexPath];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    !self.listScrollViewScrollBlock ? : self.listScrollViewScrollBlock(scrollView);
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView * _Nonnull))callback {
    self.listScrollViewScrollBlock = callback;
}

- (UIScrollView *)listScrollView{
    return self.collectionView;
}

#pragma mark - Getter and setter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DYVideoListCollectionCell class] forCellWithReuseIdentifier:kVideoListControllerCollectionCell];
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.inputViewController.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}




@end
