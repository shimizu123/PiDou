//
//  UIButton+TG.m
//  TG
//
//  Created by kevin on 28/7/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "UIButton+TG.h"

@implementation UIButton (TG)

- (void)xl_setTitle:(NSString *)title color:(UIColor *)color size:(CGFloat)size {
    [self setTitle:title forState:(UIControlStateNormal)];
    [self setTitleColor:color forState:(UIControlStateNormal)];
    self.titleLabel.font = [UIFont xl_fontOfSize:size];
}

- (void)xl_setTitle:(NSString *)title color:(UIColor *)color size:(CGFloat)size target:(id)target action:(SEL)action {
    [self xl_setTitle:title color:color size:size];
    [self addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)xl_setImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    [self setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    [self addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)xl_setImageName:(NSString *)imageName selectImage:(NSString *)selectImage target:(id)target action:(SEL)action {
    [self setImage:[UIImage imageNamed:selectImage] forState:(UIControlStateSelected)];
    [self xl_setImageName:imageName target:target action:action];
}

@end
