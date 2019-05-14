//
//  DYVideoListView.h
//  Douyin
//
//  Created by Ternence on 2019/5/7.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DYVideoListView;

@protocol DYVideoListViewDelegate <NSObject>

- (void)delegate_videoList:(DYVideoListView *)videoList scrollDidScroll:(CGPoint)offset;

@end

@interface DYVideoListView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id<DYVideoListViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
