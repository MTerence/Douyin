//
//  DYVideoListCollectionCell.m
//  Douyin
//
//  Created by Ternence on 2019/5/8.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYVideoListCollectionCell.h"

@interface DYVideoListCollectionCell ()

/** 视频动态预览图*/
@property (nonatomic, strong) YYAnimatedImageView *awemeImageView;

@end

@implementation DYVideoListCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.awemeImageView.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.awemeImageView];
    [self.awemeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (void)refreshData:(DYAwemeModel *)awemeModel{
    [self.awemeImageView yy_setImageWithURL:[NSURL URLWithString:awemeModel.video.dynamic_cover.url_list.firstObject] placeholder:nil];
}


- (YYAnimatedImageView *)awemeImageView{
    if (_awemeImageView == nil) {
        _awemeImageView = [[YYAnimatedImageView alloc]init];
        _awemeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _awemeImageView.clipsToBounds = YES;
    }
    return _awemeImageView;
}

@end
