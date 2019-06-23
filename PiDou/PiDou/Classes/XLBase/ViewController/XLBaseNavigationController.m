//
//  XLBaseNavigationController.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseNavigationController.h"
#import "UIImage+TGExtension.h"

@interface XLBaseNavigationController ()

@end

@implementation XLBaseNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:COLOR_A(0xffffff, 1)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:XL_COLOR_DARKBLACK, NSFontAttributeName:[UIFont xl_mediumFontOfSiz:18.f]}];
}


/**
 * 拦截所有push进来的子控制器
 * @param viewController 每一次push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // if (不是第一个push进来的子控制器) {
    if (self.childViewControllers.count >= 1) {
        // 左上角的返回
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem leftItemWithImage:@"navi_arrow_black" highImage:nil target:self action:@selector(back)];
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }
    if ([self.topViewController isMemberOfClass:[viewController class]]) {
        return;
    }
    
    [super pushViewController:viewController animated:animated];
    
    [self restoreTabBarFrame];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    // 左上角的返回
    XLBaseNavigationController *navC = (XLBaseNavigationController *)viewControllerToPresent;
    navC.topViewController.navigationItem.leftBarButtonItem = [UIBarButtonItem leftItemWithImage:@"public_close" highImage:nil target:self action:@selector(dismiss)];
    navC.topViewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    
    [self restoreTabBarFrame];
}

- (void)restoreTabBarFrame {
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
