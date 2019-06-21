//
//  XLLaunchManager.m
//  TG
//
//  Created by kevin on 22/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLLaunchManager.h"
#import "XLRootManager.h"
#import "UIWindow+TGExtension.h"
#import "XLUserManager.h"
#import "XLLoginController.h"
#import "XLBaseNavigationController.h"

@implementation XLLaunchManager
singleton_m(XLLaunchManager)

+ (void)isLogin {
    [[self sharedXLLaunchManager] isLogin];
}

/**判断审核状态*/
+ (void)isIdentity {
    [[self sharedXLLaunchManager] isIdentity];
}


+ (void)goLoginWithTarget:(id)target {
    [[self sharedXLLaunchManager] goLoginWithTarget:target];
}

+ (void)goLoginWithTarget:(id)target finish:(XLFinishBlock)finish {
    [[self sharedXLLaunchManager] goLoginWithTarget:target finish:finish];
}

- (void)goLoginWithTarget:(UIViewController *)target finish:(XLFinishBlock)finish {
    XLLoginController *loginVC = [[XLLoginController alloc] init];
    XLBaseNavigationController *naviC = [[XLBaseNavigationController alloc] initWithRootViewController:loginVC];
    [target.navigationController presentViewController:naviC animated:YES completion:^{
        if (finish) {
            finish();
        }
    }];
}

- (void)goLoginWithTarget:(UIViewController *)target {
    XLLoginController *loginVC = [[XLLoginController alloc] init];
    XLBaseNavigationController *naviC = [[XLBaseNavigationController alloc] initWithRootViewController:loginVC];
    [target.navigationController presentViewController:naviC animated:YES completion:^{
    }];
}

- (void)isLogin {
    // 已经登录
    [self goMain];
//    if (!XLStringIsEmpty([XLUserHandle userid])) {
//        // 已经登录
//        [self goMain];
//    } else {
//        // 跳转到登录页面
//        [self goLogin];
//        
//    }

}


#pragma mark - 登录成功
- (void)loginSuccess {
    [XLRootManager rootToMainTabBarVC];
}


#pragma mark - 跳转到登录页面
+ (void)goLogin {
    [[self sharedXLLaunchManager] goLogin];
}
- (void)goLogin {
    [XLUserManager logout];
    [XLRootManager rootToLoginVC];
}

- (void)goMain {
    [XLRootManager rootToMainTabBarVC];
}


@end
