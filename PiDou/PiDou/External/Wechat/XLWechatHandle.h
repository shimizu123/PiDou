//
//  XLWechatHandle.h
//  PiDou
//
//  Created by kevin on 28/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLWechatHandle : NSObject

/**通过code获取access_token的接口。*/
+ (void)getAccessTokenWithCode:(NSString *)code success:(XLSuccess)success failure:(XLFailure)failure;

/**获取用户个人信息（UnionID机制）*/
+ (void)getWechatInfoWithAccesstoken:(NSString *)accesstoken openid:(NSString *)openid success:(XLSuccess)success failure:(XLFailure)failure;

@end

NS_ASSUME_NONNULL_END
