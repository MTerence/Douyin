//
//  DYAwemePlayListCell.m
//  Douyin
//
//  Created by Ternence on 2019/5/24.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYAwemePlayListCell.h"

@interface DYAwemePlayListCell ()<AVPlayerUpdateDelegate,CMVideoPlayerDelegate>

@end

@implementation DYAwemePlayListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor lightGrayColor];
    
    _playerView = [CMVideoPlayer new];
    _playerView.delegate = self;
    [self.contentView addSubview:_playerView];
    
    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)initData:(DYAwemeModel *)aweme{
    _awemeModel = aweme;
}

- (void)play{
    [_playerView play];
}

- (void)startDownloadBackgroundTask{
    NSString *playURL = self.awemeModel.video.play_addr.url_list.firstObject;
    [_playerView setPlayerWithURL:playURL];
    [self play];
}
- (void)onProgressUpdate:(CGFloat)current total:(CGFloat)total{
    
}

- (void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status{
    
}

@end
