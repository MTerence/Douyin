//
//  CMVideoPlayer.h
//  Douyin
//
//  Created by Ternence on 2019/5/27.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CMVideoPlayer;

@protocol CMVideoPlayerDelegate <NSObject>


/**
 播放状态回调
 
 @param player playerView
 @param status AVPlayerItemStatus
 */
- (void)delegate_player:(CMVideoPlayer *)player statusChanged:(AVPlayerItemStatus)status;

/**
 播放进度回调
 
 @param player playerView
 @param currentTime 当前播放的时间
 @param totalTime 视频总时长
 @param progress 播放进度
 */
- (void)delegate_player:(CMVideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress;

@end


@interface CMVideoPlayer : UIView

/** delegate */
@property (nonatomic, weak) id<CMVideoPlayerDelegate>delegate;


/**
 设置播放url
 
 @param url url
 */
- (void)setPlayerWithURL:(NSString *)url;


/**
 取消播放
 */
- (void)cancelLoading;


/**
 开始视频资源下载任务
 
 @param URL url
 @param isBackground 后台
 */
- (void)startDownloadTask:(NSURL *)URL isBackfround:(BOOL)isBackground;


/**
 更新AVPlayer播放状态， 当前播放则暂停，当前暂停则播放
 */
- (void)updatePlayerState;


/**
 开始播放
 */
- (void)play;

/**
 暂停播放
 */
- (void)pause;


/**
 重新播放
 */
- (void)replay;


/**
 播放速度
 
 @return 播放速度
 */
- (CGFloat)rate;

/**
 重新请求
 */
- (void)retry;

@end

NS_ASSUME_NONNULL_END
