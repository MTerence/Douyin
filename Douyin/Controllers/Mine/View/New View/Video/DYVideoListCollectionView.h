//
//  DYVideoListCollectionView.h
//  Douyin
//
//  Created by Ternence on 2019/5/14.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYAwemeModel.h"

NS_ASSUME_NONNULL_BEGIN

@class DYVideoListCollectionView;

@protocol DYVideoListCollectionViewDelegate <NSObject>

- (void)delegate_videoList:(DYVideoListCollectionView *)videoList scrollDidScroll:(CGPoint)offset;

@end

@interface DYVideoListCollectionView : UICollectionView

@property (nonatomic, weak) id<DYVideoListCollectionViewDelegate>videoListDelegate;

/** Awemes Array */
@property (nonatomic, strong)NSMutableArray<DYAwemeModel *> *awemesArray;

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
