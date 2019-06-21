//
//  UIImage+XLBlurGlass.h
//  TG
//
//  Created by kevin on 31/10/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XLBlurGlass)

- (UIImage *)blur;

/**
 * 高斯模糊图片
 * @prama radius: 越大越模糊
 */
+ (UIImage *)tg_imageWithBlurImage:(const UIImage *)theImage intputRadius:(const CGFloat)radius;

+ (UIImage *)tg_boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
