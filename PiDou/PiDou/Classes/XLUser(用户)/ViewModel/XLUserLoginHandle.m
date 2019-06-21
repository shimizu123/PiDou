//
//  XLUserLoginHandle.m
//  PiDou
//
//  Created by ice on 2019/4/27.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLUserLoginHandle.h"

@implementation XLUserLoginHandle

#pragma mark - 注册
+ (void)userRegisterWithPhoneNum:(NSString *)phoneNum code:(NSString *)code password:(NSString *)password invitationCode:(NSString *)invitationCode success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone_number"] = phoneNum;
    params[@"sms_code"] = code;
    params[@"password"] = password;
    params[@"invitation_code"] = invitationCode;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Register];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLAppUserModel *user = [XLAppUserModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(user);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 绑定微信
+ (void)userBindWechatWithData:(NSDictionary *)data success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"data"] = data.mj_JSONString;

    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_BindWechat];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            if (success) {
                success(msg);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 登陆
+ (void)userLoginWithPhoneNum:(NSString *)phoneNum password:(NSString *)password success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone_number"] = phoneNum;
    params[@"password"] = password;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Login];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLAppUserModel *user = [XLAppUserModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(user);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - 获取验证码
+ (void)userCodeWithPhoneNum:(NSString *)phoneNum success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone_number"] = phoneNum;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_GetCode];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            if (success) {
                success(msg);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 修改密码
+ (void)userChangePasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newpassword success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"old_password"] = oldPassword;
    params[@"new_password"] = newpassword;
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_ChangePassword];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            if (success) {
                success(msg);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - 校验验证码
+ (void)userCheckCodeWithPhoneNum:(NSString *)phoneNum action:(NSString *)action code:(NSString *)code success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone_number"] = phoneNum;
    params[@"action"] = action;
    params[@"sms_code"] = code;
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_CheckSmsCode];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSString *validateToken = [[responseObject valueForKey:@"data"] valueForKey:@"validate_token"];
            if (success) {
                success(validateToken);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 忘记密码-重置密码
+ (void)userForgetPasswordWithPhoneNum:(NSString *)phoneNum validateToken:(NSString *)validateToken newPassword:(NSString *)newPassword success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone_number"] = phoneNum;
    params[@"validate_token"] = validateToken;
    params[@"new_password"] = newPassword;
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_ForgetPassword];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            if (success) {
                success(msg);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - 更换手机
+ (void)userChangePhoneWithPhoneNum:(NSString *)phoneNum validateToken:(NSString *)validateToken code:(NSString *)code success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone_number"] = phoneNum;
    params[@"validate_token"] = validateToken;
    params[@"sms_code"] = code;
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_ChangePhone];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 201) {
            if (success) {
                success(msg);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -  我的个人信息
+ (void)userInfoWithSuccess:(XLSuccess)success failure:(XLFailure)failure {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_MyInfo];
    [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLAppUserModel *user = [XLAppUserModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(user);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**神评鉴定师申请*/
+ (void)userApplyAppraiserWithSuccess:(XLSuccess)success failure:(XLFailure)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_ApplyAppraiser];
    [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            if (success) {
                success(msg);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**微信登录*/
+ (void)wechatLoginWithData:(NSDictionary *)data success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"data"] = data.mj_JSONString;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_WechatLogin];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLAppUserModel *user = [XLAppUserModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(user);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**微信登录-绑定手机*/
+ (void)wechatBindWithPhone:(NSString *)phone validate_token:(NSString *)validate_token sms_code:(NSString *)sms_code password:(NSString *)password invitation_code:(NSString *)invitation_code success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"validate_token"] = validate_token;
    params[@"phone_number"] = phone;
    params[@"sms_code"] = sms_code;
    params[@"password"] = password;
    if (!XLStringIsEmpty(invitation_code)) {
        params[@"invitation_code"] = invitation_code;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_WechatBind];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLAppUserModel *user = [XLAppUserModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(user);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
