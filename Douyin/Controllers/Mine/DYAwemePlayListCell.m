//
//  DYAwemePlayListCell.m
//  Douyin
//
//  Created by Ternence on 2019/5/24.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYAwemePlayListCell.h"

@implementation DYAwemePlayListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor lightGrayColor];
}

@end
