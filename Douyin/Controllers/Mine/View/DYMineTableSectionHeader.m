//
//  DYMineTableSectionHeader.m
//  Douyin
//
//  Created by Ternence on 2019/5/9.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYMineTableSectionHeader.h"
#import "LXDSegmentControl.h"

@interface DYMineTableSectionHeader ()<LXDSegmentControlDelegate>

@property (nonatomic, strong)LXDSegmentControl *segmanetControl;

@end

@implementation DYMineTableSectionHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor redColor];
    [self addSubview:self.segmanetControl];
}

- (LXDSegmentControl *)segmanetControl{
    if (_segmanetControl == nil) {
        LXDSegmentControlConfiguration * configuration = [LXDSegmentControlConfiguration configurationWithControlType: LXDSegmentControlTypeSlideBlock items: @[@"作品", @"动态", @"喜欢"]];
        //使用配置对象创建分栏控制器
        _segmanetControl = [LXDSegmentControl segmentControlWithFrame:CGRectMake(0, 0, self.width, self.height) configuration: configuration delegate: self];
    }
    return _segmanetControl;
}

@end
