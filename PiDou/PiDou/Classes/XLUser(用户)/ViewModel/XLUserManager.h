//
//  XLUserManager.h
//  TG
//
//  Created by kevin on 3/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLUserManager : NSObject
singleton_h(XLUserManager)

/**post用户头像改变通知*/
+ (void)userIconDidChange;

/**用户头像改变addObserver*/
+ (void)addUserIconNotificationWithObserver:(id)target selector:(SEL)selector;
/**登入addObserver*/
+ (void)addUserLoginNotificationWithObserver:(id)target selector:(SEL)selector;
/**等出addObserver*/
+ (void)addUserLogoutNotificationWithObserver:(id)target selector:(SEL)selector;

/**登入*/
+ (void)loginWithUser:(XLAppUserModel *)user;
/**登出*/
+ (void)logout;

/**用户头像地址*/
+ (NSString *)userIconPathWithUid:(NSString *)uid;

@end
