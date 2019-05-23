//
//  DYVideoModel.h
//  Douyin
//
//  Created by Ternence on 2019/5/23.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Origin_cover : NSObject
@property (nonatomic, copy)     NSString                *uri;
@property (nonatomic, strong)   NSArray <NSString *>    *url_list;
@end

@interface Play_addr : NSObject
@property (nonatomic, copy)     NSString                *uri;
@property (nonatomic, strong)   NSArray <NSString *>    *url_list;
@end

@interface Cover : NSObject
@property (nonatomic, copy)     NSString                *uri;
@property (nonatomic, strong)   NSArray <NSString *>    *url_list;
@end

@interface Download_addr : NSObject
@property (nonatomic, copy)     NSString                *uri;
@property (nonatomic, strong)   NSArray <NSString *>    *url_list;
@end

@interface Play_addr_lowbr : NSObject
@property (nonatomic, copy)     NSString *uri;
@property (nonatomic, strong)   NSArray <NSString *>    *url_list;
@end

@interface Dynamic_cover : NSObject
@property (nonatomic, copy)     NSString                *uri;
@property (nonatomic, strong)   NSArray <NSString *>    *url_list;
@end

@interface Bit_rate : NSObject
@property (nonatomic, assign)   NSInteger bit_rate;
@property (nonatomic, assign)   NSInteger quality_type;
@property (nonatomic, copy)     NSString *gear_name;
@end



@interface DYVideoModel : NSObject

@property (nonatomic, copy)     NSString           *vide_id;
@property (nonatomic, copy)     NSString           *ratio;

@property (nonatomic, assign)   NSInteger          height;
@property (nonatomic, assign)   NSInteger          width;
@property (nonatomic, assign)   NSInteger          duration;

@property (nonatomic, assign)   BOOL               has_watermark;

@property (nonatomic, strong)   Origin_cover       *origin_cover;
@property (nonatomic, strong)   Play_addr          *play_addr;
@property (nonatomic, strong)   Cover              *cover;
@property (nonatomic, strong)   Download_addr      *download_addr;
@property (nonatomic, strong)   Play_addr_lowbr    *play_addr_lowbr;
@property (nonatomic, strong)   Dynamic_cover      *dynamic_cover;
@property (nonatomic, strong)   NSArray <Bit_rate *> *bit_rate;

@end

NS_ASSUME_NONNULL_END
