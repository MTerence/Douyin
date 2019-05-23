//
//  DYUserResponse.h
//  Douyin
//
//  Created by Ternence on 2019/5/23.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYBaseResponse.h"
#import "DYUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYUserResponse : DYBaseResponse

@property (nonatomic, strong) DYUserModel *data;

@end

NS_ASSUME_NONNULL_END
