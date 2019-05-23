//
//  DYMusicModel.h
//  Douyin
//
//  Created by Ternence on 2019/5/23.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface Cover_large : NSObject
@property (nonatomic, copy)     NSString                *uri;
@property (nonatomic, strong)   NSArray <NSString *>    *url_list;
@end


@interface Cover_thumb : NSObject
@property (nonatomic, copy) NSString                    *uri;
@property (nonatomic, strong) NSArray <NSString *>      *url_list;
@end


@interface Cover_hd : NSObject
@property (nonatomic, copy) NSString                    *uri;
@property (nonatomic, strong) NSArray <NSString *>      *url_list;
@end


@interface Play_url : NSObject
@property (nonatomic, copy) NSString                    *uri;
@property (nonatomic, strong) NSArray <NSString *>      *url_list;
@end


@interface Cover_medium : NSObject
@property (nonatomic, copy) NSString                    *uri;
@property (nonatomic, strong) NSArray <NSString *>      *url_list;
@end



@interface DYMusicModel : NSObject

@property (nonatomic, copy)     NSString      *music_id;
@property (nonatomic, copy)     NSString      *uid;
@property (nonatomic, copy)     NSString      *extra;
@property (nonatomic, copy)     NSString      *offline_desc;
@property (nonatomic, copy)     NSString      *title;
@property (nonatomic, copy)     NSString      *author;
@property (nonatomic, copy)     NSString      *mid;
@property (nonatomic, copy)     NSString      *id_str;
@property (nonatomic, copy)     NSString      *schema_url;

@property (nonatomic, assign)   NSInteger     status;
@property (nonatomic, assign)   NSInteger     source_platform;
@property (nonatomic, assign)   NSInteger     duration;
@property (nonatomic, assign)   NSInteger     user_count;

@property (nonatomic, assign)   BOOL          is_original;
@property (nonatomic, assign)   BOOL          is_restricted;

@property (nonatomic, strong)   Cover_large   *cover_large;
@property (nonatomic, strong)   Cover_thumb   *cover_thumb;
@property (nonatomic, strong)   Cover_hd      *cover_hd;
@property (nonatomic, strong)   Play_url      *play_url;
@property (nonatomic, strong)   Cover_medium  *cover_medium;

@end

NS_ASSUME_NONNULL_END
