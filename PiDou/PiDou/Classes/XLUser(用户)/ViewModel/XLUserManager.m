//
//  XLUserManager.m
//  TG
//
//  Created by kevin on 3/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLUserManager.h"
#import "XLLaunchManager.h"

@implementation XLUserManager
singleton_m(XLUserManager)

+ (void)userIconDidChange {
    [[self sharedXLUserManager] userIconDidChange];
}


+ (void)addUserIconNotificationWithObserver:(id)target selector:(SEL)selector {
    [[self sharedXLUserManager] addUserIconNotificationWithObserver:target selector:selector];
}

/**登入*/
+ (void)loginWithUser:(XLAppUserModel *)user {
    [[self sharedXLUserManager] loginWithUser:user];
}

/**登出*/
+ (void)logout {
    [[self sharedXLUserManager] logout];
}

/**登入addObserver*/
+ (void)addUserLoginNotificationWithObserver:(id)target selector:(SEL)selector {
    [[self sharedXLUserManager] addUserLoginNotificationWithObserver:target selector:selector];
}
/**等出addObserver*/
+ (void)addUserLogoutNotificationWithObserver:(id)target selector:(SEL)selector {
    [[self sharedXLUserManager] addUserLogoutNotificationWithObserver:target selector:selector];
}

- (void)userIconDidChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:XLUpdateIconNotification object:nil];
}

- (void)addUserIconNotificationWithObserver:(id)target selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:XLUpdateIconNotification object:nil];
}

/**登入addObserver*/
- (void)addUserLoginNotificationWithObserver:(id)target selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:XLUserLoginNotification object:nil];
}
/**等出addObserver*/
- (void)addUserLogoutNotificationWithObserver:(id)target selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:XLUserLogoutNotification object:nil];
}

/**登入*/
- (void)loginWithUser:(XLAppUserModel *)user {
    // 将用户信息存储到数据库
    [XLUserDatabase addUser:user];
    [[NSNotificationCenter defaultCenter] postNotificationName:XLUserLoginNotification object:nil];
    // 告诉服务求极光推送的registrationID
    // 登录成功，则获取投顾信息

}


/**登出*/
- (void)logout {
    [XLUserHandle clearCurrentUser];
    [[NSNotificationCenter defaultCenter] postNotificationName:XLUserLogoutNotification object:nil];
}

+ (NSString *)userIconPathWithUid:(NSString *)uid {
    return [[self sharedXLUserManager] userIconPathWithUid:uid];
}

- (NSString *)userIconPathWithUid:(NSString *)uid {
    return [XLDocumentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"userIcon_%@",uid]];
}

@end
