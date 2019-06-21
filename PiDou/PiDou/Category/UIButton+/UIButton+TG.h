//
//  UIButton+TG.h
//  TG
//
//  Created by kevin on 28/7/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TG)

- (void)xl_setTitle:(NSString *)title color:(UIColor *)color size:(CGFloat)size target:(id)target action:(SEL)action;

- (void)xl_setTitle:(NSString *)title color:(UIColor *)color size:(CGFloat)size;

- (void)xl_setImageName:(NSString *)imageName target:(id)target action:(SEL)action;

- (void)xl_setImageName:(NSString *)imageName selectImage:(NSString *)selectImage target:(id)target action:(SEL)action;

@end
