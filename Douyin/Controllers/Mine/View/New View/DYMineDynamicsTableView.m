//
//  DYMineDymicTableView.m
//  Douyin
//
//  Created by Ternence on 2019/5/10.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYMineDynamicsTableView.h"

@interface DYMineDynamicsTableView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DYMineDynamicsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
//        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
}

- (void)setContentOffset:(CGPoint)contentOffset{
    if (self.window) {
        [super setContentOffset:contentOffset];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试:%ld", indexPath.row];
    cell.backgroundColor = [UIColor brownColor];
    return cell;
}

@end
