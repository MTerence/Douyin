//
//  DYUserModel.h
//  Douyin
//
//  Created by Ternence on 2019/5/22.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Avatar : NSObject
@property (nonatomic, copy)   NSString              *uri;
@property (nonatomic, strong) NSArray<NSString *>   *url_list;
@end

@interface Video_icon : NSObject
@property (nonatomic, copy)   NSString                *uri;
@property (nonatomic, strong) NSArray<NSString *>     *url_list;
@end

@interface Activity : NSObject
@property (nonatomic, assign) NSInteger                use_music_count;
@property (nonatomic, assign) NSInteger                digg_count;
@end

@interface Geofencing : NSObject
@end

@interface DYUserModel : NSObject

@property (nonatomic, copy)   NSString      *uid;

@property (nonatomic, copy)   NSString      *youtube_channel_title;

@property (nonatomic, copy)   NSString      *youtube_channel_id;

@property (nonatomic, copy)   NSString      *share_qrcode_uri;

@property (nonatomic, copy)   NSString      *enterprise_verify_reason;

@property (nonatomic, copy)   NSString      *original_music_qrcode;

@property (nonatomic, copy)   NSString      *short_id;

@property (nonatomic, copy)   NSString      *account_region;

@property (nonatomic, copy)   NSString      *video_icon_virtual_URI;

@property (nonatomic, copy)   NSString      *school_name;

@property (nonatomic, copy)   NSString      *custom_verify;

@property (nonatomic, copy)   NSString      *school_poi_id;

@property (nonatomic, copy)   NSString      *region;

@property (nonatomic, copy)   NSString      *weibo_schema;

@property (nonatomic, copy)   NSString      *bind_phone;

@property (nonatomic, copy)   NSString      *weibo_url;

@property (nonatomic, copy)   NSString      *weibo_name;

@property (nonatomic, copy)   NSString      *twitter_id;

@property (nonatomic, copy)   NSString      *create_time;

@property (nonatomic, copy)   NSString      *verify_info;

@property (nonatomic, copy)   NSString      *google_account;

@property (nonatomic, copy)   NSString      *birthday;

@property (nonatomic, copy)   NSString      *nickname;

@property (nonatomic, copy)   NSString      *original_music_cover;

@property (nonatomic, copy)   NSString      *ins_id;

@property (nonatomic, copy)   NSString      *twitter_name;

@property (nonatomic, copy)   NSString      *avatar_uri;

@property (nonatomic, copy)   NSString      *signature;

@property (nonatomic, copy)   NSString      *weibo_verify;

@property (nonatomic, copy)   NSString      *unique_id;


@property (nonatomic, assign) NSInteger     following_count;

@property (nonatomic, assign) NSInteger     comment_setting;

@property (nonatomic, assign) NSInteger     user_rate;

@property (nonatomic, assign) NSInteger     live_verify;

@property (nonatomic, assign) NSInteger     secret;

@property (nonatomic, assign) NSInteger     reflow_page_gid;

@property (nonatomic, assign) NSInteger     aweme_count;

@property (nonatomic, assign) NSInteger     special_lock;

@property (nonatomic, assign) NSInteger     shield_comment_notice;

@property (nonatomic, assign) NSInteger     total_favorited;

@property (nonatomic, assign) NSInteger     favoriting_count;

@property (nonatomic, assign) NSInteger     gender;

@property (nonatomic, assign) NSInteger     live_agreement;

@property (nonatomic, assign) NSInteger     live_agreement_time;

@property (nonatomic, assign) NSInteger     commerce_user_level;

@property (nonatomic, assign) NSInteger     story_count;

@property (nonatomic, assign) NSInteger     constellation;

@property (nonatomic, assign) NSInteger     apple_account;

@property (nonatomic, assign) NSInteger     need_recommend;

@property (nonatomic, assign) NSInteger     shield_digg_notice;

@property (nonatomic, assign) NSInteger     verification_type;

@property (nonatomic, assign) NSInteger     follower_status;

@property (nonatomic, assign) NSInteger     neiguang_shield;

@property (nonatomic, assign) NSInteger     room_id;

@property (nonatomic, assign) NSInteger     follower_count;

@property (nonatomic, assign) NSInteger     authority_status;

@property (nonatomic, assign) NSInteger     reflow_page_uid;

@property (nonatomic, assign) NSInteger     duet_setting;

@property (nonatomic, assign) NSInteger     shield_follow_notice;

@property (nonatomic, assign) NSInteger     follow_status;

@property (nonatomic, assign) NSInteger     unique_id_modify_time;

@property (nonatomic, assign) NSInteger     school_type;

@property (nonatomic, assign) NSInteger     status;



@property (nonatomic, assign) BOOL          story_open;

@property (nonatomic, assign) BOOL          is_gov_media_vip;

@property (nonatomic, assign) BOOL          is_binded_weibo;

@property (nonatomic, assign) BOOL          is_verified;

@property (nonatomic, assign) BOOL          hide_search;

@property (nonatomic, assign) BOOL          with_commerce_entry;

@property (nonatomic, assign) BOOL          user_canceled;

@property (nonatomic, assign) BOOL          hide_location;

@property (nonatomic, assign) BOOL          has_email;

@property (nonatomic, assign) BOOL          prevent_download;

@property (nonatomic, assign) BOOL          accept_private_policy;

@property (nonatomic, assign) BOOL          has_orders;

@property (nonatomic, assign) BOOL          is_ad_fake;

@property (nonatomic, assign) BOOL          is_phone_binded;


@property (nonatomic, strong) Avatar        *avatar_larger;

@property (nonatomic, strong) Avatar        *avatar_thumb;

@property (nonatomic, strong) Avatar        *avatar_medium;

@property (nonatomic, strong) Video_icon    *video_icon;

@property (nonatomic, strong) Activity      *activity;


@property (nonatomic, strong) NSArray <Geofencing *> *geofencing;

@end


NS_ASSUME_NONNULL_END
