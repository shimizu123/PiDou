//
//  XLRootManager.m
//  TG
//
//  Created by kevin on 25/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import "XLRootManager.h"
#import "XLMainTabBarController.h"
#import "XLLaunchController.h"
#import "XLLoginController.h"
#import "XLBaseNavigationController.h"

@implementation XLRootManager

+ (id)getRootController {
    if (![self isFirstRunApp]) {
        return [self getMainController];
    }
    [self hasRunApp];
    return [self getLaunchController];
}

#pragma mark - 主TabBar控制器
+ (UIViewController *)getMainController {
    return [[XLMainTabBarController alloc] init];
}

#pragma mark - Launch控制器
+ (UIViewController *)getLaunchController {
    return [[XLLaunchController alloc] init];
}

#pragma mark - 登录导航控制器
+ (UIViewController *)getLoginController {
    return [[XLLoginController alloc] init];
}


+ (void)rootToMainTabBarVC {
    [UIApplication sharedApplication].keyWindow.rootViewController = [self getMainController];
}

+ (void)rootToLaunchVC {
    [UIApplication sharedApplication].keyWindow.rootViewController = [self getLaunchController];
}

+ (void)rootToLoginVC {

    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            XLBaseNavigationController *naviC = [[XLBaseNavigationController alloc] initWithRootViewController:[self getLoginController]];
            [UIApplication sharedApplication].keyWindow.rootViewController = naviC;
        });
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - 判断是否是第一次启动APP
+ (BOOL)isFirstRunApp {
    return ![[XLUserDefaults xl_valueForKey:KFIRST_RUN_TGAPP] boolValue];
}

#pragma makr -启动了APP
+ (void)hasRunApp {
    [XLUserDefaults xl_setValue:@1 forKey:KFIRST_RUN_TGAPP];
}

@end
