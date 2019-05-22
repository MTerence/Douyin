//
//  DYMineUserInfoHeader.h
//  Douyin
//
//  Created by Ternence on 2019/5/10.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXDSegmentControl.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DYUserInfoHeaderDelegate <NSObject>

- (void)delegate_segmentControl:(LXDSegmentControl *)segmentControl didSelectAtIndex:(NSUInteger)index;

@end

@interface DYMineUserInfoHeader : UIView

/** scrollView content 选择器 */
@property (nonatomic, strong) LXDSegmentControl *segmentControl;

- (void)tableDidScroll:(CGFloat)offsetY;
- (void)scrollToTopAction:(CGFloat)offsetY;
- (void)setSegmentCurrentIndex: (NSUInteger)currentIndex;

@property (nonatomic, weak) id<DYUserInfoHeaderDelegate>userInfoDelegate;

@end

NS_ASSUME_NONNULL_END
