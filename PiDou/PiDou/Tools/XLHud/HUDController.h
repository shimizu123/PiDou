//
//  HUDController.h
//  ElementFresh
//
//  Created by Bingjie on 14-7-7.
//  Copyright (c) 2014年 Bingjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUDController : NSObject

+ (void)xl_showHUD;
+ (void)xl_hideHUDWithResult:(id)result;

+ (void)showCustomView:(UIView *)customview;

+ (void)hideCustomView:(UIView *)customview afterDelay:(CGFloat)time;

+ (void)showProgressLabel:(NSString *)text;

+ (void)showTextOnly:(NSString *)text;

+ (void)hideHUDWithText:(NSString *)text;

+ (void)hideHUD;



+ (void)showProgressLabel:(NSString *)text inView:(UIView*)view;

+ (void)hideHUDWithText:(NSString *)text fromView:(UIView*)view;

@end
