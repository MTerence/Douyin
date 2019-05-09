//
//  DYMineVerticalCollectionLayout.h
//  Douyin
//
//  Created by Ternence on 2019/5/9.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYMineVerticalCollectionLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat topHeight;

- (instancetype)initWithTopHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
