//
//  DYMineUserInfoHeader.h
//  Douyin
//
//  Created by Ternence on 2019/5/10.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYMineUserInfoHeader : UIView

- (void)tableDidScroll:(CGFloat)offsetY;
- (void)scrollToTopAction:(CGFloat)offsetY;

@end

NS_ASSUME_NONNULL_END
