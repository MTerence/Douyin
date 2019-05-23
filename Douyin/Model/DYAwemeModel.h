//
//  DYAwemeModel.h
//  Douyin
//
//  Created by Ternence on 2019/5/23.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYVideoModel.h"
#import "DYUserModel.h"
#import "DYMusicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Risk_infos : NSObject
@property (nonatomic, copy)     NSString    *content;
@property (nonatomic, assign)   NSInteger   type;
@property (nonatomic, assign)   BOOL        warn;
@property (nonatomic, assign)   BOOL        risk_sink;
@end


@interface Label_top : NSObject
@property (nonatomic, copy)     NSString              *uri;
@property (nonatomic, strong)   NSArray <NSString *>  *url_list;
@end


@interface Statistics : NSObject
@property (nonatomic, copy)     NSString    *aweme_id;
@property (nonatomic, assign)   NSInteger   play_count;
@property (nonatomic, assign)   NSInteger   comment_count;
@property (nonatomic, assign)   NSInteger   share_count;
@property (nonatomic, assign)   NSInteger   digg_count;
@end

@interface Status : NSObject
@property (nonatomic, assign)   BOOL        with_goods;
@property (nonatomic, assign)   BOOL        is_delete;
@property (nonatomic, assign)   BOOL        with_fusion_goods;
@property (nonatomic, assign)   BOOL        allow_comment;
@property (nonatomic, assign)   BOOL        allow_share;
@property (nonatomic, assign)   BOOL        is_private;
@property (nonatomic, assign)   NSInteger   private_status;
@end


@interface Descendants : NSObject
@property (nonatomic, copy)     NSString             *notify_msg;
@property (nonatomic, strong)   NSArray <NSString *> *platforms;
@end

@interface Share_info : NSObject
@property (nonatomic, copy)     NSString    *share_weibo_desc;
@property (nonatomic, copy)     NSString    *share_title;
@property (nonatomic, copy)     NSString    *share_url;
@property (nonatomic, copy)     NSString    *share_desc;
@end


@interface Video_labels : NSObject
@end

@interface Video_text : NSObject
@end

@interface Text_extra : NSObject
@end

@interface Cha_list : NSObject
@end

@interface DYAwemeModel : NSObject

@property (nonatomic, copy)     NSString    *aweme_id;
@property (nonatomic, copy)     NSString    *share_url;
@property (nonatomic, copy)     NSString    *sort_label;
@property (nonatomic, copy)     NSString    *desc;
@property (nonatomic, copy)     NSString    *region;

@property (nonatomic, assign)   NSInteger   author_user_id;
@property (nonatomic, assign)   NSInteger   rate;
@property (nonatomic, assign)   NSInteger   create_time;
@property (nonatomic, assign)   NSInteger   vr_type;
@property (nonatomic, assign)   NSInteger   bodydance_score;
@property (nonatomic, assign)   NSInteger   is_hash_tag;
@property (nonatomic, assign)   NSInteger   is_top;
@property (nonatomic, assign)   NSInteger   aweme_type;
@property (nonatomic, assign)   NSInteger   scenario;
@property (nonatomic, assign)   NSInteger   user_digged;

@property (nonatomic, assign)   BOOL        can_play;
@property (nonatomic, assign)   BOOL        is_vr;
@property (nonatomic, assign)   BOOL        cmt_swt;
@property (nonatomic, assign)   BOOL        is_ads;
@property (nonatomic, assign)   BOOL        law_critical_country;
@property (nonatomic, assign)   BOOL        is_pgcshow;
@property (nonatomic, assign)   BOOL        is_relieve;

@property (nonatomic, strong)   Risk_infos      *risk_infos;
@property (nonatomic, strong)   Label_top       *label_top;
@property (nonatomic, strong)   DYVideoModel    *video;
@property (nonatomic, strong)   Statistics      *statistics;
@property (nonatomic, strong)   DYUserModel     *author;
@property (nonatomic, strong)   DYMusicModel    *music;
@property (nonatomic, strong)   Status          *status;
@property (nonatomic, strong)   Descendants     *descendants;
@property (nonatomic, strong)   Share_info      *share_info;
@property (nonatomic, strong)   Video_labels    *video_labels;
@property (nonatomic, strong)   Video_text      *video_text;
@property (nonatomic, strong)   Geofencing      *geofencing;
@property (nonatomic, strong)   Text_extra      *text_extra;
@property (nonatomic, strong)   Cha_list        *cha_list;

@end

NS_ASSUME_NONNULL_END
