//
//  DYUserDynamicsTableView.h
//  Douyin
//
//  Created by Ternence on 2019/5/14.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DYUserDynamicsTableView;
@protocol DYUserDynamicsTableView <NSObject>

- (void)delegate_dynamicsList:(DYUserDynamicsTableView *)dynamicsList scrollDidScroll:(CGPoint)offset;

@end

@interface DYUserDynamicsTableView : UITableView

@property (nonatomic, weak) id<DYUserDynamicsTableView>dynamicsDelegate;

@end

NS_ASSUME_NONNULL_END
