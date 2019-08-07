//
//  XLAppUserModel.h
//  TG
//
//  Created by kevin on 8/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+BGModel.h>

@interface XLAppUserModel : NSObject


/**Oauth统一认证用户ID*/
@property (nonatomic, copy) NSString *user_id;
/**昵称*/
@property (nonatomic, copy) NSString *nickname;
/**头像*/
@property (nonatomic, copy) NSString *avatar;
/**签名*/
@property (nonatomic, copy) NSString *sign;
/**访问令牌*/
@property (nonatomic, copy) NSString *token;
/**是否为神评鉴定师 0否 1是*/
@property (nonatomic, assign) NSNumber *appraiser;
/**是否为大V 0否 1是*/
@property (nonatomic, assign) NSNumber *vip;
/**性别*/
@property (nonatomic, copy) NSString *sex;
/**邀请码*/
@property (nonatomic, copy) NSString *invitation_code;
/**手机号*/
@property (nonatomic, copy) NSString *phone_number;
/**微信号*/
@property (nonatomic, copy) NSString *wechat_id;
/**粉丝数量*/
@property (nonatomic, copy) NSString *fans;
/**关注数量*/
@property (nonatomic, copy) NSString *followers;
/**PDCoin数量*/
@property (nonatomic, copy) NSString *pdcoin_count;

/**是否关注用户*/
@property (nonatomic, strong) NSNumber *followed;
/**评论id*/
@property (nonatomic, copy) NSString *cid;
/**是否点赞0否 1是*/
@property (nonatomic, strong) NSNumber *do_liked;

/**点赞条数*/
@property (nonatomic, copy) NSString *do_like_count;

@property (nonatomic, copy) NSString *validate_token;

/*1 优质内容贡献者、2 神评鉴定师、3 皮逗音乐达人、4 皮逗搞笑达人、5 皮逗正能量传播者，6 皮逗军事达人*/
@property (nonatomic, copy) NSArray *biaoqian;

///**1官方标识,0非官方*/
//@property (nonatomic, assign) NSInteger user_sign;
///***/
//@property (nonatomic, assign) double lasttime;
///**1.付费用户 0非付费*/
//@property (nonatomic, assign) NSInteger userispay;

///**刷新令牌*/
//@property (nonatomic, copy) NSString *refresh_token;
///**过期时间（秒）*/
//@property (nonatomic, copy) NSString *expires_in;
///**令牌类型*/
//@property (nonatomic, copy) NSString *token_type;
///**范围*/
//@property (nonatomic, copy) NSString *scope;
/**用户编号=smguserid*/
//@property (nonatomic, copy) NSString *uid;
///**kevin记录保存上次刷新access_token的时间*/
//@property (nonatomic, copy) NSString *updateTokenDate;

@property (nonatomic, copy) NSString *entity_id;
@property (nonatomic, assign) BOOL isTopic;
@property (nonatomic, copy) NSString *content;

+ (NSString *)bg_uniqueKey;

@end
