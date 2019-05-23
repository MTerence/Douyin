//
//  DYGlobalMacro.h
//  Douyin
//
//  Created by Ternence on 2019/5/7.
//  Copyright © 2019 Ternence. All rights reserved.
//

#ifndef DYGlobalMacro_h
#define DYGlobalMacro_h

//字体
#define DYSystemFontSize(a)       [UIFont systemFontOfSize:a]
#define DYSystemBoldFontSize(a)   [UIFont boldSystemFontOfSize:a]
#define DYFONT(NAME,FONTSIZE)     [UIFont fontWithName:(NAME)size:(FONTSIZE)]
#define kFont_PingFangSC_Medium   @"PingFangSC-Medium"
#define kFont_PingFangSC_Light    @"PingFangSC-Light"
#define kFont_PingFangSC_Regular  @"PingFangSC-Regular"
#define kFont_PingFangSC_Bold     @"PingFangSC-Semibold"
#define kFont_PingFangSC_Thin     @"PingFangSC-Thin"
#define kFont_DINAlternate_Bold   @"DINAlternate-Bold"
#define kFont_FuturaLT            @"Futura LT Medium"

//机型判断
#define iphoneX                 [DYTools isIPhoneX]
#define isPad           ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define kiPhone4        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define kiPhone5        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6 6s 7系列
#define kiPhone6x       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6p 6sp 7p系列
#define kiPhone6Plus    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define kiPHONE_X       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXR
#define kiPHONE_Xr      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXsMax
#define kiPHONE_Xs_Max  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)


/** 控件缩放比例，按照宽度计算 */
#define DY_SCALE_WIDTH(w)   (round([UIScreen mainScreen].bounds.size.width)/375.0*(w))
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height
#define STATUSBAR_HIGHT     [[UIApplication sharedApplication] statusBarFrame].size.height

#define NAVIBar_H               (iphoneX ? 88 : 64)
#define TABBAR_HEIGHT           self.tabBarController.tabBar.height

#define kNaviBarNormalColor     [UIColor colorWithR:64 g:66 b:76 a:1]


#define kHeaderViewHeight     DY_SCALE_WIDTH(470)
#define kSegmentControlHeight DY_SCALE_WIDTH(40)


/** Json */
#define kJsonCodeSuccess      0
#define kJsonMsgSuccess       @"success"

#endif /* DYGlobalMacro_h */
