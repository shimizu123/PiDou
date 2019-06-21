//
//  XLCommonMacros.h
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#ifndef XLCommonMacros_h
#define XLCommonMacros_h

/// 是否第一次登录
#define KFIRST_RUN_TGAPP             @"FIRST_RUN_TGAPP"

/// 登入
#define XLUserLoginNotification      @"kXLUserLogin"
/// 登出
#define XLUserLogoutNotification     @"kXLUserLogout"
/// 注册成功跳到登录
#define XLUserRegistNotification     @"kXLUserRegist"
/// 头像更新通知
#define XLUpdateIconNotification     @"kXLUpdateUserIcon"
/// 用户信息更新
#define XLUpdateInfoNotification     @"kXLUpdateInfo"
/// 密码修改成功
#define XLUpdatePwdNotification      @"kXLUpdatePassword"

/// 发布结束
#define XLFinishPublishNotification  @"kXLFinishPublish"

/// 删除帖子更新
#define XLDelMyPublishNotification  @"kXLDelMyPublish"

/// 支付成功
#define XLPaySuccessNotification    @"kXLPaySuccess"

/// 对话题关注成功
#define XLTopicFocusNotification    @"kXLTopicFocus"

#endif /* XLCommonMacros_h */
