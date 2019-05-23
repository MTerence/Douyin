//
//  DYAwemeModel.m
//  Douyin
//
//  Created by Ternence on 2019/5/23.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYAwemeModel.h"

@implementation DYAwemeModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"risk_infos"  : @"Risk_infos",
             @"label_top"   : @"Label_top",
             @"video"       : @"DYVideoModel",
             @"statistics"  : @"Statistics",
             @"author"      : @"DYUserModel",
             @"music"       : @"DYMusicModel",
             @"status"      : @"Status",
             @"descendants" : @"Descendants",
             @"share_info"  : @"Share_info",
             @"video_labels": @"Video_labels",
             @"video_text"  : @"Video_text",
             @"geofencing"  : @"Geofencing",
             @"text_extra"  : @"Text_extra",
             @"cha_list"    : @"Cha_list"};
}
@end
