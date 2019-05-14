//
//  DYUserDynamicsTableView.m
//  Douyin
//
//  Created by Ternence on 2019/5/14.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYUserDynamicsTableView.h"
#import "DYUserDynamicsTableCell.h"

NSString *const kDYUserDynamicsTableCell = @"DYUserDynamicsTableCell";

@interface DYUserDynamicsTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DYUserDynamicsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[DYUserDynamicsTableCell class] forCellReuseIdentifier:kDYUserDynamicsTableCell];
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.inputViewController.automaticallyAdjustsScrollViewInsets = NO;
        }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DY_SCALE_WIDTH(500);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DYUserDynamicsTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kDYUserDynamicsTableCell];
    if (cell == nil) {
        cell = [[DYUserDynamicsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDYUserDynamicsTableCell];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.dynamicsDelegate && [self.dynamicsDelegate respondsToSelector:@selector(delegate_dynamicsList:scrollDidScroll:)]) {
        [self.dynamicsDelegate delegate_dynamicsList:self scrollDidScroll:scrollView.contentOffset];
    }
}


@end
