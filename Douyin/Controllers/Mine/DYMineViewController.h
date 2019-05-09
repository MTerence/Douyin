//
//  DYMineViewController.h
//  Douyin
//
//  Created by Ternence on 2019/5/6.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYMineViewController : DYBaseViewController

@property (nonatomic, strong) UICollectionView *verticalCollectionView;

@property (nonatomic, assign) NSInteger         selectIndex;

@end

NS_ASSUME_NONNULL_END
