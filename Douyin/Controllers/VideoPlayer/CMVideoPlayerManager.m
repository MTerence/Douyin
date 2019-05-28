//
//  CMVideoPlayerManager.m
//  Douyin
//
//  Created by Ternence on 2019/5/27.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "CMVideoPlayerManager.h"

@interface CMVideoPlayerManager ()

@end

@implementation CMVideoPlayerManager

+ (CMVideoPlayerManager *)shareManager {
    static dispatch_once_t once;
    static CMVideoPlayerManager *manager;
    dispatch_once(&once, ^{
        manager = [CMVideoPlayerManager new];
    });
    return manager;
}

+ (void)setAudioModel{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
}

- (instancetype)init{
    if (self = [super init]) {
        _playerArray = [NSMutableArray array];
    }
    return self;
}

- (void)play:(AVPlayer *)player{
    [_playerArray enumerateObjectsUsingBlock:^(AVPlayer * obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
    if(![_playerArray containsObject:player]) {
        [_playerArray addObject:player];
    }
    [player play];
}

- (void)pause:(AVPlayer *)player{
    if([_playerArray containsObject:player]) {
        [player pause];
    }
}

- (void)pauseAll{
    [_playerArray enumerateObjectsUsingBlock:^(AVPlayer * obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
}

- (void)replay:(AVPlayer *)player{
    [_playerArray enumerateObjectsUsingBlock:^(AVPlayer * obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
    if([_playerArray containsObject:player]) {
        [player seekToTime:kCMTimeZero];
        [self play:player];
    }else {
        [_playerArray addObject:player];
        [self play:player];
    }
}

- (void)removeAllPlayers{
    [_playerArray removeAllObjects];
}


@end
