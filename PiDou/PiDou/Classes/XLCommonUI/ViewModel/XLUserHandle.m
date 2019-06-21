//
//  XLUserHandle.m
//  TG
//
//  Created by kevin on 6/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLUserHandle.h"

@interface XLUserHandle ()

@property (nonatomic, strong) XLAppUserModel *user;

@end

@implementation XLUserHandle
singleton_m(XLUserHandle)

- (XLAppUserModel *)user {
    if (!_user) {
        _user = [XLUserDatabase searchUser];
    }
    return _user;
}

#pragma mark - 当前用户
+ (XLAppUserModel *)currentUser {
    return [[self sharedXLUserHandle] currentUser];
}

- (XLAppUserModel *)currentUser {
    return self.user;
}


#pragma mark - 清除当前用户
+ (void)clearCurrentUser {
    [[self sharedXLUserHandle] clearCurrentUser];
}
- (void)clearCurrentUser {
    [XLUserDatabase deleteUser];
    self.user = nil;
}

#pragma mark - userid
+ (NSString *)userid {
    return [[self sharedXLUserHandle] userid];
}


- (NSString *)userid {
    return self.user.user_id;
}

#pragma mark - nickname
+ (NSString *)nickname {
    return [[self sharedXLUserHandle] nickname];
}
- (NSString *)nickname {
    return self.user.nickname;;
}

#pragma mark - realname
+ (NSString *)realname {
    return [[self sharedXLUserHandle] realname];
}



#pragma mark - token
+ (NSString *)token {
    return [[self sharedXLUserHandle] token];
}

- (NSString *)token {
    return self.user.token;
}

+ (BOOL)isVip {
    return [[self sharedXLUserHandle] isVip];
}

- (BOOL)isVip {
    return [self.user.vip boolValue];
}

/**手机号*/
+ (NSString *)phoneNum {
    return [[self sharedXLUserHandle] phoneNum];
}

- (NSString *)phoneNum {
    return self.user.phone_number;
}

#pragma mark - 刷新令牌
//+ (NSString *)refresh_token {
//    return [[self sharedXLUserHandle] refresh_token];
//}
//
//- (NSString *)refresh_token {
//    return self.user.refresh_token;
//}

#pragma mark - 用户信息更新就要调用这个方法
+ (void)userInfoUpdate {
    [[self sharedXLUserHandle] userInfoUpdate];
}
- (void)userInfoUpdate {
    // 刷新数据
    self.user = nil;
}

@end
