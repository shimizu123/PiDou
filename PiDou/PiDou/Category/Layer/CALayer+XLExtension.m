//
//  CALayer+XLExtension.m
//  TG
//
//  Created by kevin on 13/12/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "CALayer+XLExtension.h"

@implementation CALayer (XLExtension)

- (void)setXl_x:(CGFloat)xl_x {
    CGRect frame = self.frame;
    frame.origin.x = xl_x;
    self.frame = frame;
}

- (CGFloat)xl_x {
    return self.frame.origin.x;
}

- (void)setxl_y:(CGFloat)xl_y {
    CGRect frame = self.frame;
    frame.origin.y = xl_y;
    self.frame = frame;
}

- (CGFloat)xl_y {
    return self.frame.origin.y;
}

- (void)setxl_w:(CGFloat)xl_w {
    CGRect frame = self.frame;
    frame.size.width = xl_w;
    self.frame = frame;
}

- (CGFloat)xl_w {
    return self.frame.size.width;
}

- (void)setxl_h:(CGFloat)xl_h {
    CGRect frame = self.frame;
    frame.size.height = xl_h;
    self.frame = frame;
}

- (CGFloat)xl_h {
    return self.frame.size.height;
}

- (void)setxl_size:(CGSize)xl_size {
    CGRect frame = self.frame;
    frame.size = xl_size;
    self.frame = frame;
}

- (CGSize)xl_size {
    return self.frame.size;
}

- (void)setxl_origin:(CGPoint)xl_origin {
    CGRect frame = self.frame;
    frame.origin = xl_origin;
    self.frame = frame;
}

- (CGPoint)xl_origin {
    return self.frame.origin;
}


- (void)setxl_center:(CGPoint)xl_center {
    CGRect frame = self.frame;
    frame.origin.x = xl_center.x - frame.size.width * 0.5;
    frame.origin.y = xl_center.y - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGPoint)xl_center {
    return CGPointMake(self.frame.origin.x + self.frame.size.width * 0.5,
                       self.frame.origin.y + self.frame.size.height * 0.5);
}

- (void)setxl_centerX:(CGFloat)xl_centerX {
    CGRect frame = self.frame;
    frame.origin.x = xl_centerX - frame.size.width * 0.5;
    self.frame = frame;
}

- (CGFloat)xl_centerX {
    return self.frame.origin.x + self.frame.size.width * 0.5;
}


- (void)setxl_centerY:(CGFloat)xl_centerY {
    CGRect frame = self.frame;
    frame.origin.y = xl_centerY - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGFloat)xl_centerY {
    return self.frame.origin.y + self.frame.size.height * 0.5;
}

- (void)removeAllSublayers {
    while (self.sublayers.count) {
        [self.sublayers.lastObject removeFromSuperlayer];
    }
}

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = 1;
    self.shouldRasterize = YES;
    self.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius cornerRadius:(CGFloat)cornerRadius {
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = 1;
    self.shouldRasterize = YES;
    self.rasterizationScale = [UIScreen mainScreen].scale;
    self.cornerRadius = cornerRadius;
}

@end
