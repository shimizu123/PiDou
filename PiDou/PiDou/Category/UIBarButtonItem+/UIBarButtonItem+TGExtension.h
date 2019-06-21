//
//  UIBarButtonItem+TGExtension.h
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TGExtension)

+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

+ (UIBarButtonItem*)itemWithTitle:(NSString*)titleName size:(CGFloat)size target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)leftItemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
