//
//  UIImage+TGExtension.h
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TGExtension)

/**颜色转图片*/
+ (UIImage *)imageWithColor:(UIColor *)color;
/**通过颜色生成纯色图片*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
/**通过图片生成圆形图片*/
+ (UIImage *)circleImage:(UIImage *)image diameter:(NSUInteger)diameter;

/**设置uiimage 的radius*/
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)radius;

/**设置uiimage 的圆角*/
+ (id)createCircleRectImage:(UIImage*)image;

/**获取屏幕截屏*/
+ (UIImage *)getScreenSnap;
/**
 *  截图功能，根据尺寸截取view成为一张图片
 *
 *  @param view 需要截取的View
 *
 *  @return 新生成的已截取的图片
 */
+ (UIImage *)imageWithCaputureView:(UIView *)view;

+ (UIImage *)imageCreateWithImage:(UIImage *)image frame:(CGRect)frame;



/**图片压缩到指定大小*/
- (UIImage *)tg_resizedImage:(CGSize)newSize
        interpolationQuality:(CGInterpolationQuality)quality;

/**获得视频首帧图片*/
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**图片限制大小*/
- (NSData *)compressWithMaxLength:(NSUInteger)maxLength;


@end
