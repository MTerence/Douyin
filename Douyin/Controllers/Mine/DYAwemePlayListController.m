//
//  DYAwemePlayListController.m
//  Douyin
//
//  Created by Ternence on 2019/5/24.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYAwemePlayListController.h"
#import "DYAwemePlayListCell.h"

NSString *const kDYAwemePlayListCell = @"DYAwemePlayListCell";

@interface DYAwemePlayListController ()<UITableViewDelegate, UITableViewDataSource>

/** 需要播放的aweme Array*/
@property (nonatomic, strong) NSMutableArray<DYAwemeModel *> *awemesArray;

@property (nonatomic, strong) NSMutableArray<DYAwemeModel *> *awemws;

@end

@implementation DYAwemePlayListController

- (instancetype)initWithVideoData:(NSMutableArray<DYAwemeModel *> *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize uid:(NSString *)uid{
    if (self = [super init]) {
        self.awemesArray = [data mutableCopy];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.awemesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DYAwemePlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:kDYAwemePlayListCell];
//    if (cell == nil) {
//        cell = [[DYAwemePlayListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDYAwemePlayListCell];
//    }
    
    [cell initData:self.awemesArray[indexPath.row]];
    [cell startDownloadBackgroundTask];
    
    return cell;
}

#pragma mark - getters
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pagingEnabled = YES;
        
        if (@available(iOS 11.0, *)) {_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;}
        else {self.automaticallyAdjustsScrollViewInsets = NO;}
        
        [_tableView registerClass:[DYAwemePlayListCell class] forCellReuseIdentifier:kDYAwemePlayListCell];
    }
    return _tableView;
}

@end
