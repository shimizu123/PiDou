//
//  UIColor+XLExtension.h
//  TG
//
//  Created by kevin on 6/12/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XLExtension)

+ (UIColor *)colorWithYield:(double)yield;

/**
 颜色渐变

 @param fromColor 初始颜色
 @param toColor 转变后的颜色
 @param progress 进度条
 @return color
 */
+ (UIColor *)transformFromColor:(UIColor*)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress;

@end
