//
//  XLWechatHandle.m
//  PiDou
//
//  Created by kevin on 28/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLWechatHandle.h"

@implementation XLWechatHandle

/**通过code获取access_token的接口。*/
+ (void)getAccessTokenWithCode:(NSString *)code success:(XLSuccess)success failure:(XLFailure)failure {
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",Wechat_APP_ID,Wechat_APP_Secret,code];
    [XLAFNetworking get:url params:nil success:^(id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**获取用户个人信息（UnionID机制）*/
+ (void)getWechatInfoWithAccesstoken:(NSString *)accesstoken openid:(NSString *)openid success:(XLSuccess)success failure:(XLFailure)failure {
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accesstoken,openid];
    [XLAFNetworking get:url params:nil success:^(id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
