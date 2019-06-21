//
//  CALayer+XLExtension.h
//  TG
//
//  Created by kevin on 13/12/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (XLExtension)

@property (nonatomic, assign) CGFloat xl_x;
@property (nonatomic, assign) CGFloat xl_y;
@property (nonatomic, assign) CGFloat xl_w;
@property (nonatomic, assign) CGFloat xl_h;
@property (nonatomic, assign) CGSize  xl_size;
@property (nonatomic, assign) CGPoint xl_origin;
@property (nonatomic, assign) CGFloat xl_centerX;
@property (nonatomic, assign) CGFloat xl_centerY;
@property (nonatomic, assign) CGPoint xl_center;

- (void)removeAllSublayers;
- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;
- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius cornerRadius:(CGFloat)cornerRadius;


@end
