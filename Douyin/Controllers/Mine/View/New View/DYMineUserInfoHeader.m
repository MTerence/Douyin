//
//  DYMineUserInfoHeader.m
//  Douyin
//
//  Created by Ternence on 2019/5/10.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYMineUserInfoHeader.h"
#import "LXDSegmentControl.h"

#define kTopbackgroundNormalHeight DY_SCALE_WIDTH(150)
#define kCornerRadius              3
#define kColorbg                   [UIColor colorWithR:31 g:34 b:44 a:1]
#define kSegmentControlHeight DY_SCALE_WIDTH(40)
#define kHeaderViewHeight     DY_SCALE_WIDTH(470)

@interface DYMineUserInfoHeader ()<LXDSegmentControlDelegate>

/** 顶部背景图 */
@property (nonatomic, strong) UIImageView *topbackgroundImageView;


/** 图片底部视图 */
@property (nonatomic, strong) UIView *bottombackgroundView;

/** 存放头像、昵称等控件的view */
@property (nonatomic, strong) UIView *contentView;

/** 头像 */
@property (nonatomic, strong) UIImageView *avatar;

/** 编辑资料 */
@property (nonatomic, strong) UIButton *editBtn;

/** 关注按钮 */
@property (nonatomic, strong) UIButton *followBtn;

/** 昵称 */
@property (nonatomic, strong) UILabel *nicknamelLabel;

/** 抖音号 */
@property (nonatomic, strong) UILabel *userIdLabel;

/** 抖音号与签名之间的线 */
@property (nonatomic, strong) UIView *line;


/** 个人签名 */
@property (nonatomic, strong) UILabel *signLabel;

/** 年龄性别 */
@property (nonatomic, strong) UIButton *ageGenderBtn;

/** 地区 */
@property (nonatomic, strong) UILabel *cityLabel;

/** 教育 */
@property (nonatomic, strong) UILabel *educationLabel;

/** 获赞 */
@property (nonatomic, strong) UILabel *likedNumLabel;

/** 关注 */
@property (nonatomic, strong) UILabel *followNumLabel;

/** 粉丝 */
@property (nonatomic, strong) UILabel *fansNumLabel;


/** 随拍 */
@property (nonatomic, strong) UIButton *freeShootBtn;

/** 选择器 */
@property (nonatomic, strong) LXDSegmentControl *segmentControl;

@end

@implementation DYMineUserInfoHeader

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UIButton class]]) {
        return view;
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.clipsToBounds = NO;
        [self setupUI];
        [self setupConstrains];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = kColorbg;
    
    [self addSubview:self.topbackgroundImageView];
    [self addSubview:self.bottombackgroundView];
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.avatar];
    [self.contentView addSubview:self.nicknamelLabel];
    [self.contentView addSubview:self.userIdLabel];
    [self.contentView addSubview:self.editBtn];
    [self.contentView addSubview:self.followBtn];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.signLabel];
    [self.contentView addSubview:self.ageGenderBtn];
    [self.contentView addSubview:self.cityLabel];
    [self.contentView addSubview:self.educationLabel];
    [self.contentView addSubview:self.likedNumLabel];
    [self.contentView addSubview:self.followNumLabel];
    [self.contentView addSubview:self.fansNumLabel];
    [self.contentView addSubview:self.freeShootBtn];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.contentView addSubview:self.segmentControl];
//        
//    });
    
    //测试赋值
    self.nicknamelLabel.text = @"Amen";
    self.userIdLabel.text = @"抖音号:983928533";
    self.signLabel.text = @"你的眼里，藏着深海";
    self.cityLabel.text = @"北京市·朝阳区";
    self.educationLabel.text = @"内蒙古农业大学";
    self.likedNumLabel.text = @"31获赞";
    self.followNumLabel.text = @"7关注";
    self.fansNumLabel.text = @"1024粉丝";
    
    self.likedNumLabel.attributedText = [DYTools attributeTextWithStrings:@[@"31",@" 获赞"] colors:@[[UIColor colorWithR:255 g:255 b:255 a:1],[UIColor colorWithR:143 g:145 b:151 a:1]] fonts:@[DYFONT(kFont_PingFangSC_Medium, [UIFont DY_FontSize:16]), DYFONT(kFont_PingFangSC_Light, [UIFont DY_FontSize:14])]];
    self.followNumLabel.attributedText = [DYTools attributeTextWithStrings:@[@"7",@" 关注"] colors:@[[UIColor colorWithR:255 g:255 b:255 a:1],[UIColor colorWithR:143 g:145 b:151 a:1]] fonts:@[DYFONT(kFont_PingFangSC_Medium, [UIFont DY_FontSize:16]), DYFONT(kFont_PingFangSC_Light, [UIFont DY_FontSize:14])]];
    self.fansNumLabel.attributedText = [DYTools attributeTextWithStrings:@[@"1024",@" 粉丝"] colors:@[[UIColor colorWithR:255 g:255 b:255 a:1],[UIColor colorWithR:143 g:145 b:151 a:1]] fonts:@[DYFONT(kFont_PingFangSC_Medium, [UIFont DY_FontSize:16]), DYFONT(kFont_PingFangSC_Light, [UIFont DY_FontSize:14])]];
}

- (void)setupConstrains{
    float avatarRadius = 48;
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(DY_SCALE_WIDTH(35) + NAVIBar_H));
        make.left.equalTo(@(DY_SCALE_WIDTH(15)));
        make.size.mas_equalTo(CGSizeMake(avatarRadius * 2, avatarRadius * 2));
    }];
    self.avatar.layer.cornerRadius = avatarRadius;
    
    [self.nicknamelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_left);
        make.top.equalTo(self.avatar.mas_bottom).with.offset(DY_SCALE_WIDTH(20));
    }];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-DY_SCALE_WIDTH(15)));
        make.centerY.equalTo(self.avatar.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DY_SCALE_WIDTH(45), DY_SCALE_WIDTH(45)));
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatar.mas_right).with.offset(DY_SCALE_WIDTH(20));
        make.right.equalTo(self.followBtn.mas_left).with.offset(-DY_SCALE_WIDTH(5));
        make.centerY.equalTo(self.avatar.mas_centerY);
        make.height.equalTo(@(DY_SCALE_WIDTH(45)));
    }];
    
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknamelLabel.mas_left);
        make.top.equalTo(self.nicknamelLabel.mas_bottom).with.offset(5);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIdLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.avatar.mas_left);
        make.right.equalTo(self.followBtn.mas_right);
        make.height.equalTo(@(1));
    }];
    
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).with.offset(DY_SCALE_WIDTH(10));
        make.left.equalTo(self.line.mas_left);
        make.right.equalTo(self.line.mas_right);
        make.height.equalTo(@(DY_SCALE_WIDTH(15)));
    }];
    
    [self.ageGenderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signLabel.mas_bottom).with.offset(DY_SCALE_WIDTH(10));
        make.left.equalTo(self.signLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(DY_SCALE_WIDTH(50), DY_SCALE_WIDTH(25)));
    }];
    
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageGenderBtn.mas_right).with.offset(DY_SCALE_WIDTH(5));
        make.centerY.equalTo(self.ageGenderBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DY_SCALE_WIDTH(90), DY_SCALE_WIDTH(25)));
    }];
    
    [self.educationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityLabel.mas_right).with.offset(DY_SCALE_WIDTH(5));
        make.centerY.equalTo(self.ageGenderBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(DY_SCALE_WIDTH(100), DY_SCALE_WIDTH(25)));
    }];
    
    [self.likedNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_left);
        make.top.equalTo(self.ageGenderBtn.mas_bottom).with.offset(DY_SCALE_WIDTH(20));
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(10, 10));
    }];
    
    [self.followNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likedNumLabel.mas_right).with.offset(DY_SCALE_WIDTH(15));
        make.top.equalTo(self.ageGenderBtn.mas_bottom).with.offset(DY_SCALE_WIDTH(20));
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(10, 10));
    }];
    
    [self.fansNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followNumLabel.mas_right).with.offset(DY_SCALE_WIDTH(15));
        make.top.equalTo(self.ageGenderBtn.mas_bottom).with.offset(DY_SCALE_WIDTH(20));
        make.size.mas_greaterThanOrEqualTo(CGSizeMake(10, 10));
    }];
    [self.freeShootBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likedNumLabel.mas_bottom).with.offset(DY_SCALE_WIDTH(10));
        make.left.equalTo(self.line.mas_left);
        make.right.equalTo(self.line.mas_right);
        make.height.equalTo(@(DY_SCALE_WIDTH(45)));
    }];
}

#pragma mark - action
- (void)action_onEditBtnClick:(UIButton *)sender{
    
}

- (void)action_onFollowBtnClick:(UIButton *)sender{
    
}

- (void)scrollToTopAction:(CGFloat)offsetY{
    CGFloat alphaRatio = offsetY/(kHeaderViewHeight - kSegmentControlHeight - STATUSBAR_HIGHT);
    self.contentView.alpha = 1.0f - alphaRatio;
}

- (void)tableDidScroll:(CGFloat)offsetY{
    CGFloat scaleRatio = fabs(offsetY)/370.f;
    CGFloat scaleHeight = (370.f * scaleRatio)/2;
    self.topbackgroundImageView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scaleRatio + 1.0f, scaleRatio + 1.0f), CGAffineTransformMakeTranslation(0, -scaleHeight));
}

#pragma mark - getter and setter
- (UIImageView *)topbackgroundImageView{
    if (_topbackgroundImageView == nil) {
        _topbackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DY_SCALE_WIDTH(50) + NAVIBar_H)];
        _topbackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topbackgroundImageView.image = [UIImage imageNamed:@"headerbg1"];
        _topbackgroundImageView.clipsToBounds = NO;
    }
    return _topbackgroundImageView;
}

- (UIView *)bottombackgroundView{
    if (_bottombackgroundView == nil) {
        _bottombackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, DY_SCALE_WIDTH(50) + NAVIBar_H, SCREEN_WIDTH, self.height - DY_SCALE_WIDTH(50) - NAVIBar_H)];
        _bottombackgroundView.backgroundColor = kColorbg;
    }
    return _bottombackgroundView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:self.bounds];
    }
    return _contentView;
}

- (UIImageView *)avatar{
    if (_avatar == nil) {
        _avatar = [[UIImageView alloc]init];
        _avatar.contentMode = UIViewContentModeScaleAspectFill;
        _avatar.backgroundColor = [UIColor lightGrayColor];
        _avatar.layer.masksToBounds = true;
        
    }
    return _avatar;
}

- (UILabel *)nicknamelLabel{
    if (_nicknamelLabel == nil) {
        _nicknamelLabel = [[UILabel alloc]init];
        _nicknamelLabel.font = DYFONT(kFont_PingFangSC_Bold, [UIFont DY_FontSize:24]);
        _nicknamelLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _nicknamelLabel;
}

- (UILabel *)userIdLabel{
    if (_userIdLabel == nil) {
        _userIdLabel = [[UILabel alloc]init];
        _userIdLabel.font = DYFONT(kFont_PingFangSC_Bold, [UIFont DY_FontSize:12]);
        _userIdLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _userIdLabel;
}

- (UIButton *)editBtn{
    if (_editBtn == nil) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.backgroundColor = [UIColor colorWithR:64 g:66 b:76 a:1];
        [_editBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _editBtn.titleLabel.font = DYFONT(kFont_PingFangSC_Medium, [UIFont DY_FontSize:14]);
        [_editBtn addTarget:self action:@selector(action_onEditBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.layer.cornerRadius = kCornerRadius;
    }
    return _editBtn;
}

- (UIButton *)followBtn{
    if (_followBtn == nil) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.layer.cornerRadius = kCornerRadius;
        _followBtn.backgroundColor = [UIColor colorWithR:64 g:66 b:76 a:1];
        [_followBtn setImage:[UIImage imageNamed:@"icon_titlebar_addfriend"] forState:UIControlStateNormal];
        [_followBtn addTarget:self action:@selector(action_onFollowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithR:64 g:66 b:76 a:1];
    }
    return _line;
}

- (UILabel *)signLabel{
    if (_signLabel == nil) {
        _signLabel = [[UILabel alloc]init];
        _signLabel.textColor = [UIColor colorWithR:143 g:145 b:151 a:1];
        _signLabel.font = DYFONT(kFont_PingFangSC_Light, [UIFont DY_FontSize:12]);
    }
    return _signLabel;
}

- (UIButton *)ageGenderBtn{
    if (_ageGenderBtn == nil) {
        _ageGenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ageGenderBtn.backgroundColor = [UIColor colorWithR:44 g:46 b:57 a:1];
        [_ageGenderBtn setTitleColor:[UIColor colorWithR:143 g:145 b:151 a:1] forState:UIControlStateNormal];
        [_ageGenderBtn setTitle:@"26岁" forState:UIControlStateNormal];
        _ageGenderBtn.titleLabel.font = DYFONT(kFont_PingFangSC_Light, [UIFont DY_FontSize:12]);
        [_ageGenderBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _ageGenderBtn.layer.cornerRadius = 2;
    }
    return _ageGenderBtn;
}

- (UILabel *)educationLabel{
    if (_educationLabel == nil) {
        _educationLabel = [[UILabel alloc]init];
        _educationLabel.backgroundColor = [UIColor colorWithR:44 g:46 b:57 a:1];
        _educationLabel.textColor = [UIColor colorWithR:143 g:145 b:151 a:1];
        _educationLabel.font = DYFONT(kFont_PingFangSC_Light, [UIFont DY_FontSize:12]);
        _educationLabel.textAlignment = NSTextAlignmentCenter;
        _educationLabel.layer.masksToBounds = true;
        _educationLabel.layer.cornerRadius = 2;
    }
    return _educationLabel;
}

- (UILabel *)cityLabel{
    if (_cityLabel == nil) {
        _cityLabel = [[UILabel alloc]init];
        _cityLabel.backgroundColor = [UIColor colorWithR:44 g:46 b:57 a:1];
        _cityLabel.textColor = [UIColor colorWithR:143 g:145 b:151 a:1];
        _cityLabel.font = DYFONT(kFont_PingFangSC_Light, [UIFont DY_FontSize:12]);
        _cityLabel.textAlignment = NSTextAlignmentCenter;
        _cityLabel.layer.masksToBounds = true;
        _cityLabel.layer.cornerRadius = 2;
    }
    return _cityLabel;
}

- (UILabel *)likedNumLabel{
    if (_likedNumLabel == nil) {
        _likedNumLabel = [[UILabel alloc]init];
    }
    return _likedNumLabel;
}

- (UILabel *)followNumLabel{
    if (_followNumLabel == nil) {
        _followNumLabel = [[UILabel alloc]init];
    }
    return _followNumLabel;
}

- (UILabel *)fansNumLabel{
    if (_fansNumLabel == nil) {
        _fansNumLabel = [[UILabel alloc]init];
    }
    return _fansNumLabel;
}

- (UIButton *)freeShootBtn{
    if (_freeShootBtn == nil) {
        _freeShootBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _freeShootBtn.backgroundColor = [UIColor colorWithR:44 g:46 b:57 a:1];
        [_freeShootBtn setTitle:@"添加随拍" forState:UIControlStateNormal];
        [_freeShootBtn setImage:[UIImage imageNamed:@"iconShootblack"] forState:UIControlStateNormal];
        [_freeShootBtn setTitleColor:[UIColor colorWithR:143 g:145 b:151 a:1] forState:UIControlStateNormal];
        _freeShootBtn.titleLabel.font = DYFONT(kFont_PingFangSC_Medium, [UIFont DY_FontSize:14]);
        [_freeShootBtn addTarget:self action:@selector(action_onEditBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _freeShootBtn.layer.cornerRadius = kCornerRadius;
    }
    return _freeShootBtn;
}

- (LXDSegmentControl *)segmentControl{
    if (_segmentControl == nil) {
        LXDSegmentControlConfiguration * configuration = [LXDSegmentControlConfiguration configurationWithControlType: LXDSegmentControlTypeSlideBlock items: @[@"作品 18",@"动态 18",@"喜欢 213"]];
        //使用配置对象创建分栏控制器
        _segmentControl = [LXDSegmentControl segmentControlWithFrame:CGRectMake(0, self.freeShootBtn.bottom + DY_SCALE_WIDTH(10), SCREEN_WIDTH, kSegmentControlHeight) configuration: configuration delegate: self];
    }
    return _segmentControl;
}


@end
