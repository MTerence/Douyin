//
//  DYMineTableCell.m
//  Douyin
//
//  Created by Ternence on 2019/5/8.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYMineTableCell.h"
#import "DYMineHorizontalCollectionCell.h"
#import "DYMineTableHeader.h"

#define kHeaderViewHeight  DY_SCALE_WIDTH(450) + NAVIBar_H

@interface DYMineTableCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *horizontalCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, strong) DYMineTableHeader         *tableHeader;

@end

@implementation DYMineTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableHeader.frame = CGRectMake(0, -0, SCREEN_WIDTH, kHeaderViewHeight);
    self.horizontalCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
    
    self.itemWidth = self.width;
    self.itemHeight = self.height;
    self.layout.itemSize = CGSizeMake(self.itemWidth, self.itemHeight);
    [self.horizontalCollectionView setCollectionViewLayout:self.layout];
    self.horizontalCollectionView.contentInset = UIEdgeInsetsMake(self.tableHeader.bottom, 0, 0, 0);
}

- (void)setupUI{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self addSubview:self.tableHeader];
        [self addSubview:self.horizontalCollectionView];
        [self insertSubview:self.tableHeader aboveSubview:self.horizontalCollectionView];
    });
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    DYMineHorizontalCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.backgroundColor = [UIColor redColor];
    }else if (indexPath.item == 1){
        cell.backgroundColor = [UIColor lightGrayColor];
    }else{
        cell.backgroundColor = [UIColor yellowColor];
    }
    return cell;
}

- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing =1;
        _layout.minimumInteritemSpacing = 1;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (DYMineTableHeader *)tableHeader{
    if (!_tableHeader) {
        _tableHeader = [[DYMineTableHeader alloc]initWithFrame:CGRectMake(0, -0, SCREEN_WIDTH, kHeaderViewHeight)];
    }
    return _tableHeader;
}

- (UICollectionView *)horizontalCollectionView{
    if (_horizontalCollectionView == nil) {
        _horizontalCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height-self.tableHeader.height) collectionViewLayout:self.layout];
        _horizontalCollectionView.delegate = self;
        _horizontalCollectionView.dataSource = self;
        _horizontalCollectionView.pagingEnabled = YES;
        _horizontalCollectionView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight, 0, 0, 0);
        _horizontalCollectionView.backgroundColor = [UIColor orangeColor];
        [_horizontalCollectionView registerClass:[DYMineHorizontalCollectionCell class] forCellWithReuseIdentifier:@"cellId"];
        
        //设置collection不偏移
        if (@available(iOS 11.0, *)) {
            _horizontalCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _horizontalCollectionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGPoint hitPoint = [self.tableHeader convertPoint:point fromView:self];
    if ([self.tableHeader pointInside:hitPoint withEvent:event]) {
        DYMineHorizontalCollectionCell *cell = (DYMineHorizontalCollectionCell *)[self.horizontalCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
        
        return cell.videoList.collectionView;
//        return self.horizontalCollectionView;
    }
    return [super hitTest:point withEvent:event];
}

@end
