//
//  CMVideoPlayerManager.h
//  Douyin
//
//  Created by Ternence on 2019/5/27.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMVideoPlayerManager : NSObject
@property (nonatomic, strong) NSMutableArray <AVPlayer *> *playerArray; //用于存储AVPlayer的数组

+ (CMVideoPlayerManager *)shareManager;
+ (void)setAudioModel;
- (void)play:(AVPlayer *)player;
- (void)pause:(AVPlayer *)player;
- (void)pauseAll;
- (void)replay:(AVPlayer *)player;
- (void)removeAllPlayers;

@end

NS_ASSUME_NONNULL_END
