//
//  DYVideoModel.m
//  Douyin
//
//  Created by Ternence on 2019/5/23.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYVideoModel.h"

@implementation Origin_cover
@end
@implementation Play_addr
@end
@implementation Cover
@end
@implementation Download_addr
@end
@implementation Play_addr_lowbr
@end
@implementation Dynamic_cover
@end


@implementation DYVideoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"origin_cover"    : @"Origin_cover",
             @"play_addr"       : @"Play_addr",
             @"cover"           : @"Cover",
             @"download_addr"   : @"Download_addr",
             @"play_addr_lowbr" : @"Play_addr_lowbr",
             @"dynamic_cover"   : @"Dynamic_cover"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"vide_id":@"id"};
}

@end
