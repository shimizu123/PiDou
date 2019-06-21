//
//  XLUserHandle.h
//  TG
//
//  Created by kevin on 6/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLAppUserModel.h"

@interface XLUserHandle : NSObject
singleton_h(XLUserHandle)


/**用户id*/
+ (NSString *)userid;
/**用户名*/
+ (NSString *)nickname;


/**判断是否是vip用户*/
+ (BOOL)isVip;
/**手机号*/
+ (NSString *)phoneNum;

/**星票数量*/
+ (NSString *)coin_count;

/**访问令牌*/
+ (NSString *)token;
/**刷新令牌*/
+ (NSString *)refresh_token;
/**获得当前用户*/
+ (XLAppUserModel *)currentUser;
/**清除当前用户*/
+ (void)clearCurrentUser;

/**用户信息更新就要调用这个方法*/
+ (void)userInfoUpdate;

@end
