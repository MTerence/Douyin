//
//  DYMineHorizontalCollectionCell.m
//  Douyin
//
//  Created by Ternence on 2019/5/9.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYMineHorizontalCollectionCell.h"


@implementation DYMineHorizontalCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.videoList = [[DYVideoListView alloc]initWithFrame:self.bounds];
    [self addSubview:self.videoList];
}



@end
