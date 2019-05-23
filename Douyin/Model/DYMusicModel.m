//
//  DYMusicModel.m
//  Douyin
//
//  Created by Ternence on 2019/5/23.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "DYMusicModel.h"

@implementation Cover_large
@end
@implementation Cover_thumb
@end
@implementation Cover_hd
@end
@implementation Play_url
@end
@implementation Cover_medium
@end

@implementation DYMusicModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"cover_large" : @"Cover_large",
             @"cover_thumb" : @"Cover_thumb",
             @"cover_hd"    : @"Cover_hd",
             @"play_url"    : @"Play_url",
             @"cover_medium": @"Cover_medium"};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"music_id":@"id"};
}
@end
