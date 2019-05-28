//
//  DYAwemePlayListCell.h
//  Douyin
//
//  Created by Ternence on 2019/5/24.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMVideoPlayer.h"
#import "DYAwemeModel.h"
#import "AVPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYAwemePlayListCell : UITableViewCell

@property (nonatomic, strong) CMVideoPlayer *playerView;    //视频播放视图
//@property (nonatomic, strong) AVPlayerView *playerView;    //视频播放视图

@property (nonatomic, strong) DYAwemeModel *awemeModel;

- (void)initData:(DYAwemeModel *)aweme;

- (void)play;
- (void)pause;
- (void)replay;
- (void)startDownloadBackgroundTask;
- (void)startDownloadHighPriorityTask;

@end

NS_ASSUME_NONNULL_END
