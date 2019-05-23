//
//  DYUserModel.m
//  Douyin
//
//  Created by Ternence on 2019/5/22.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYUserModel.h"

@implementation Avatar
@end

@implementation Video_icon
@end

@implementation Activity
@end

@implementation Geofencing
@end

@implementation DYUserModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"avatar_larger"   :@"Avatar",
             @"avatar_thumb"    :@"Avatar",
             @"avatar_medium"   :@"Avatar",
             @"video_icon"      :@"Video_icon",
             @"activity"        :@"Activity"};
}

@end
