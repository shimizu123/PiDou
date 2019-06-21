//
//  UIImage+QRCode.h
//  QRCodeDemo
//
//  Created by 张鹏 on 2017/12/14.
//  Copyright © 2017年 zhangpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 获取二维码

 @param string 二维码中的信息
 @param size 二维码Size
 @param waterImg 水印图片
 @return 一个二维码图片，水印在二维码中央
 */
+ (UIImage *)qrImgForString:(NSString *)string size:(CGSize)size waterImg:(UIImage *)waterImg;

/**
 镶嵌图片

 @param img1 图片1
 @param img2 图片2
 @param location 图片2的起点
 @return 镶嵌后的图片
 */
+ (UIImage *)spliceImg1:(UIImage *)img1 img2:(UIImage *)img2 img2Location:(CGPoint)location;

/**
 修改二维码颜色
 
 @param image 二维码图片
 @param red red
 @param green green
 @param blue blue
 @return 修改颜色后的二维码图片
 */
+ (UIImage *)changeColorWithQRCodeImg:(UIImage *)image red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue;

@end
