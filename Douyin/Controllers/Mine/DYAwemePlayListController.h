//
//  DYAwemePlayListController.h
//  Douyin
//
//  Created by Ternence on 2019/5/24.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYBaseViewController.h"
#import "DYAwemeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYAwemePlayListController : DYBaseViewController

/** 存放播放视图的list */
@property (nonatomic, strong) UITableView *tableView;

/** 当前m播放的视频在总视频的index，记录用于返回的时候转场 */
@property (nonatomic, assign) NSInteger currentIndex;


- (instancetype)initWithVideoData:(NSMutableArray <DYAwemeModel *> *)data
                     currentIndex:(NSInteger)currentIndex
                        pageIndex:(NSInteger)pageIndex
                         pageSize:(NSInteger)pageSize
                              uid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
