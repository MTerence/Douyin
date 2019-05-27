//
//  DYUserDynamicsTableCell.m
//  Douyin
//
//  Created by Ternence on 2019/5/14.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYUserDynamicsTableCell.h"

#define kVideoWidth     (SCREEN_WIDTH - DY_SCALE_WIDTH(15) - DY_SCALE_WIDTH(100))
#define kVideoHeight    (kVideoWidth*4/3)
@interface DYUserDynamicsTableCell ()

/** 头像 */
@property (nonatomic, strong) UIImageView *avatar;
/** 昵称 */
@property (nonatomic, strong) UILabel *nicknameLabel;
/** 更多按钮 */
@property (nonatomic, strong) UIButton *moreButton;
/** 动态描述内容 */
@property (nonatomic, strong) UILabel *descLabel;
/** 动态视频播放器 */
@property (nonatomic, strong) UIImageView *video;
/** 发布时间 */
@property (nonatomic, strong) UILabel *timeLabel;
/** 分享按钮 */
@property (nonatomic, strong) UIButton *shareButton;
/** 评论按钮 */
@property (nonatomic, strong) UIButton *commentButton;
/** 点赞按钮 */
@property (nonatomic, strong) UIButton *supportButton;

@end

@implementation DYUserDynamicsTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupMasonry];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.avatar];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.moreButton];
    [self addSubview:self.descLabel];
    [self addSubview:self.video];
    [self addSubview:self.timeLabel];
    [self addSubview:self.shareButton];
    [self addSubview:self.commentButton];
    [self addSubview:self.supportButton];
}

- (void)setupMasonry{
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(DY_SCALE_WIDTH(15)));
        make.top.equalTo(@(DY_SCALE_WIDTH(15)));
        make.size.mas_equalTo(CGSizeMake(DY_SCALE_WIDTH(30), DY_SCALE_WIDTH(30)));
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatar.mas_centerY);
        make.right.equalTo(@(-DY_SCALE_WIDTH(15)));
        make.size.mas_equalTo(CGSizeMake(DY_SCALE_WIDTH(20), DY_SCALE_WIDTH(20)));
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).with.offset(DY_SCALE_WIDTH(5));
        make.centerY.equalTo(self.avatar.mas_centerY);
        make.height.equalTo(@(DY_SCALE_WIDTH(20)));
        make.right.equalTo(self.moreButton.mas_left).with.offset(-DY_SCALE_WIDTH(15));
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatar.mas_bottom).with.offset(DY_SCALE_WIDTH(15));
        make.left.equalTo(self.avatar.mas_left);
        make.right.greaterThanOrEqualTo(@(-DY_SCALE_WIDTH(15)));
        make.height.greaterThanOrEqualTo(@(DY_SCALE_WIDTH(30)));
    }];
    
    [self.video mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_left);
        make.top.equalTo(self.descLabel.mas_bottom).with.offset(DY_SCALE_WIDTH(15));
        make.size.mas_equalTo(CGSizeMake(kVideoWidth, kVideoHeight));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_left);
        make.top.equalTo(self.video.mas_bottom).with.offset(DY_SCALE_WIDTH(15));
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(DY_SCALE_WIDTH(20), DY_SCALE_WIDTH(15)));
    }];
    
    [self.supportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-DY_SCALE_WIDTH(15)));
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DY_SCALE_WIDTH(30), DY_SCALE_WIDTH(30)));
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.supportButton.mas_left).with.offset(-DY_SCALE_WIDTH(10));
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DY_SCALE_WIDTH(30), DY_SCALE_WIDTH(30)));
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentButton.mas_left).with.offset(-DY_SCALE_WIDTH(10));
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DY_SCALE_WIDTH(30), DY_SCALE_WIDTH(30)));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIImageView *)avatar{
    if (_avatar == nil) {
        _avatar = [[UIImageView alloc]init];
        _avatar.backgroundColor = [UIColor lightGrayColor];
        _avatar.layer.cornerRadius = DY_SCALE_WIDTH(30)/2;
    }
    return _avatar;
}

- (UILabel *)nicknameLabel{
    if (_nicknameLabel == nil) {
        _nicknameLabel = [[UILabel alloc]init];
        _nicknameLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _nicknameLabel;
}

- (UIButton *)moreButton{
    if (_moreButton == nil) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.backgroundColor = [UIColor lightGrayColor];
    }
    return _moreButton;
}

- (UILabel *)descLabel{
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _descLabel;
}

- (UIImageView *)video{
    if (_video == nil) {
        _video = [[UIImageView alloc]init];
        _video.backgroundColor = [UIColor lightGrayColor];
        _avatar.layer.cornerRadius = 5;
    }
    return _video;
}

- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}

- (UIButton *)shareButton{
    if (_shareButton == nil) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.backgroundColor = [UIColor lightGrayColor];
    }
    return _shareButton;
}

- (UIButton *)commentButton{
    if (_commentButton == nil) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.backgroundColor = [UIColor lightGrayColor];
    }
    return _commentButton;
}

- (UIButton *)supportButton{
    if (_supportButton == nil) {
        _supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _supportButton.backgroundColor = [UIColor lightGrayColor];
    }
    return _supportButton;
}

@end
