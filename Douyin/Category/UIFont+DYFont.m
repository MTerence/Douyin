//
//  UIFont+DYFont.m
//  Douyin
//
//  Created by Ternence on 2019/5/7.
//  Copyright © 2019 Ternence. All rights reserved.
//

#import "UIFont+DYFont.h"

@implementation UIFont (DYFont)

+ (CGFloat)DY_FontSize:(CGFloat)size{
    if (kiPhone4) {
        size *= 0.84;
    }
    
    if (kiPhone5) {
        size *= 0.84;
    }
    
    if (kiPhone6x) {
        size *= 1;
    }
    
    if (kiPhone6Plus) {
        size *= 1.104;
    }
    
    if (kiPHONE_X || kiPHONE_Xr || kiPHONE_Xs_Max) {
        size *= 1.2;
    }
    return size;
}

@end
