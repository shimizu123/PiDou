//
//  HUDController.m
//  ElementFresh
//
//  Created by Bingjie on 14-7-7.
//  Copyright (c) 2014年 Bingjie. All rights reserved.
//

#import "HUDController.h"
#import <MBProgressHUD.h>

#define HIDE_TIME    1.0f

@implementation HUDController

+ (void)checkHUDInKeyWindow
{
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[MBProgressHUD class]]) {
            [[self class] hideHUD];
            break;
        }
    }
}

+ (void)showCustomView:(UIView *)customview
{
    [[self class] checkHUDInKeyWindow];
    
    MBProgressHUD *HUD = [[self class] setHUDWithText:nil inView:[UIApplication sharedApplication].keyWindow];
    
	HUD.customView = customview;
	
	HUD.mode = MBProgressHUDModeCustomView;
	
	[HUD showAnimated:YES];
}

+ (void)hideCustomView:(UIView *)customview afterDelay:(CGFloat)time
{
    [[self class] checkHUDInKeyWindow];
    
    MBProgressHUD *HUD = [[self class] setHUDWithText:nil inView:[UIApplication sharedApplication].keyWindow];
    
	HUD.customView = customview;
	
	HUD.mode = MBProgressHUDModeCustomView;
	
	[HUD showAnimated:YES];
	[HUD hideAnimated:YES afterDelay:time];
}

+ (void)showProgressLabel:(NSString *)text
{
    [[self class] checkHUDInKeyWindow];
    
    MBProgressHUD *hud = [[self class] setHUDWithText:text inView:[UIApplication sharedApplication].keyWindow];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
}

+ (void)hideHUDWithText:(NSString *)text {
    
    [[self class] hideHUD];
    if (text && text.length != 0) {
       [[self class] showTextOnly:text]; 
    }
}


+ (void)showTextOnly:(NSString *)text
{
    MBProgressHUD *hud = [[self class] setHUDWithText:text inView:[UIApplication sharedApplication].keyWindow];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    hud.yOffset = 150.f;
#pragma clang diagnostic pop
    
    [hud hideAnimated:YES afterDelay:HIDE_TIME];
}

+ (void)xl_showHUD {
    [self showProgressLabel:@"请稍等"];
}

+ (void)showProgressLabel:(NSString *)text inView:(UIView*)view
{
    [[self class] checkHUDInKeyWindow];
    
    MBProgressHUD *hud = [[self class] setHUDWithText:text inView:view];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
}

+ (void)xl_hideHUDWithResult:(id)result {
    if (![result isKindOfClass:[NSError class]]) {
        if ([result isEqualToString:@"参数错误1"]) {
            [self hideHUDWithText:@"请登录"];
        } else {
            [self hideHUDWithText:result];
        }
    } else {
        [self hideHUDWithText:@"网络异常，请检查您的网络"];
    }
}

+ (void)hideHUDWithText:(NSString *)text fromView:(UIView*)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
    if (text && text.length != 0) {
        [[self class] showTextOnly:text];
    }
}


+ (void)hideHUD
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

+ (MBProgressHUD *)setHUDWithText:(NSString *)text
                            inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}



@end
