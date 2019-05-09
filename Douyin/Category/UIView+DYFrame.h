//
//  UIView+DYFrame.h
//  Douyin
//
//  Created by Ternence on 2019/5/8.
//  Copyright © 2019 Ternence. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIView (DYFrame)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGSize size;


@property (nonatomic, assign) CGFloat top;

@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGPoint origin;

@end

NS_ASSUME_NONNULL_END
