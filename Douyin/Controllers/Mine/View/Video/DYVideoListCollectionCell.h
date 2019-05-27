//
//  DYVideoListCollectionCell.h
//  Douyin
//
//  Created by Ternence on 2019/5/8.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYAwemeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYVideoListCollectionCell : UICollectionViewCell

- (void)refreshData:(DYAwemeModel *)awemeModel;

@end

NS_ASSUME_NONNULL_END
