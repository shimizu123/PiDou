//
//  UIBarButtonItem+TGExtension.m
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import "UIBarButtonItem+TGExtension.h"

@implementation UIBarButtonItem (TGExtension)

+ (instancetype)leftItemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[[UIImage imageNamed:image] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateNormal];
    if (!XLStringIsEmpty(highImage)) {
        [button setImage:[[UIImage imageNamed:highImage] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    button.xl_w = 44;
    [button setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[[UIImage imageNamed:image] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateNormal];
    if (!XLStringIsEmpty(highImage)) {
        [button setImage:[[UIImage imageNamed:highImage] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateHighlighted];
    }
    
    [button sizeToFit];
    button.xl_w = 44;
    [button setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString*)titleName size:(CGFloat)size target:(id)target action:(SEL)action {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:titleName style:(UIBarButtonItemStylePlain) target:target action:action];
    item.tintColor = XL_COLOR_DARKBLACK;
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont xl_fontOfSize:size], NSFontAttributeName, nil] forState:(UIControlStateNormal)];
    return item;
}

@end
