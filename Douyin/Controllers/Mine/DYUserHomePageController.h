//
//  DYUserHomePageController.h
//  Douyin
//
//  Created by Ternence on 2019/5/7.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYUserHomePageController : DYBaseViewController

/** 选中的视频Index， 用于转场 */
@property (nonatomic, strong) UICollectionView *collectionView;

/** 选中的视频Index， 用于转场 */
@property (nonatomic, assign) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
