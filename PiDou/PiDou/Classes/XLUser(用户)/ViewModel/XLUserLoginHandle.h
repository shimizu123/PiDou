//
//  XLUserLoginHandle.h
//  PiDou
//
//  Created by ice on 2019/4/27.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLUserLoginHandle : NSObject

/**
 注册
 
 @param phoneNum 手机号
 @param code 验证码
 @param password 密码
 @param invitationCode 邀请码
 @param success 成功
 @param failure 失败
 */
+ (void)userRegisterWithPhoneNum:(NSString *)phoneNum code:(NSString *)code password:(NSString *)password invitationCode:(NSString *)invitationCode success:(XLSuccess)success failure:(XLFailure)failure;


/**
 绑定微信

 @param data 微信返回的用户信息，需全部传入
 @param success 成功
 @param failure 失败
 */
+ (void)userBindWechatWithData:(id)data success:(XLSuccess)success failure:(XLFailure)failure;


/**
 登录

 @param phoneNum 手机号
 @param password 密码
 @param success 成功
 @param failure 失败
 */
+ (void)userLoginWithPhoneNum:(NSString *)phoneNum password:(NSString *)password success:(XLSuccess)success failure:(XLFailure)failure;



/**
 获取验证码

 @param phoneNum 手机号
 @param success 成功
 @param failure 失败
 */
+ (void)userCodeWithPhoneNum:(NSString *)phoneNum token:(NSString *)token success:(XLSuccess)success failure:(XLFailure)failure;



/**
 修改密码

 @param oldPassword 老密码
 @param newpassword 新密码
 @param success 成功
 @param failure 失败
 */
+ (void)userChangePasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newpassword success:(XLSuccess)success failure:(XLFailure)failure;


/**
 校验验证码

 @param phoneNum 手机号
 @param action 将进行什么操作。如进行忘记密码，则传入 forget_password，更新手机号则传入change_phone
 @param code 短信验证码
 @param success 成功
 @param failure 失败
 */
+ (void)userCheckCodeWithPhoneNum:(NSString *)phoneNum action:(NSString *)action code:(NSString *)code success:(XLSuccess)success failure:(XLFailure)failure;


/**
 忘记密码-重置密码

 @param phoneNum 手机号
 @param validateToken check_sms_code接口返回的validate_token
 @param newPassword 新密码
 @param success 成功
 @param failure 失败
 */
+ (void)userForgetPasswordWithPhoneNum:(NSString *)phoneNum validateToken:(NSString *)validateToken newPassword:(NSString *)newPassword success:(XLSuccess)success failure:(XLFailure)failure;



/**
 更换手机

 @param phoneNum 手机号
 @param validateToken check_sms_code接口返回的validate_token
 @param code 验证码
 @param success 成功
 @param failure 失败
 */
+ (void)userChangePhoneWithPhoneNum:(NSString *)phoneNum validateToken:(NSString *)validateToken code:(NSString *)code success:(XLSuccess)success failure:(XLFailure)failure;


/**
 我的个人信息

 @param success 成功
 @param failure 失败
 */
+ (void)userInfoWithSuccess:(XLSuccess)success failure:(XLFailure)failure;

/**神评鉴定师申请*/
+ (void)userApplyAppraiserWithSuccess:(XLSuccess)success failure:(XLFailure)failure;

/**微信登录*/
+ (void)wechatLoginWithData:(id)data success:(XLSuccess)success failure:(XLFailure)failure;

/**微信登录-绑定手机*/
+ (void)wechatBindWithPhone:(NSString *)phone validate_token:(NSString *)validate_token sms_code:(NSString *)sms_code password:(NSString *)password invitation_code:(NSString *)invitation_code success:(XLSuccess)success failure:(XLFailure)failure;

@end

NS_ASSUME_NONNULL_END
