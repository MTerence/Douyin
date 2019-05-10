//
//  DYMineContentScrollView.m
//  Douyin
//
//  Created by Ternence on 2019/5/10.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYMineContentScrollView.h"
#define kMineHeaderViewHeight   DY_SCALE_WIDTH(450) + NAVIBar_H

@implementation DYMineContentScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)setOffset:(CGPoint)offset{
    _offset = offset;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    
    BOOL hitHead = point.y < (kMineHeaderViewHeight - self.offset.y);
    if (hitHead || !view)
    {
        self.scrollEnabled = NO;
        if (!view) {
            for (UIView *subview in self.subviews) {
                if (subview.x == self.contentOffset.x) {
                    view = subview;
                }
            }
        }
        return view;
    }
    else{
        self.scrollEnabled = YES;
        return view;
    }
    
}
@end
