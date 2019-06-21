//
//  UIFont+TGExtension.m
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import "UIFont+TGExtension.h"

@implementation UIFont (TGExtension)


+ (UIFont *)xl_fontOfSize:(CGFloat)fontSize {
    return [self systemFontOfSize:fontSize * kWidthRatio6s];
}

+ (UIFont *)xl_boldFontOfSize:(CGFloat)fontSize {
    return [self boldSystemFontOfSize:fontSize * kWidthRatio6s];
}

+ (UIFont *)xl_mediumFontOfSiz:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize * kWidthRatio6s];
}

@end
