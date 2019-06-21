//
//  UIWindow+TGExtension.m
//  TG
//
//  Created by kevin on 19/10/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "UIWindow+TGExtension.h"

@implementation UIWindow (TGExtension)

+ (UIViewController*)tg_currentViewController; {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}


@end
