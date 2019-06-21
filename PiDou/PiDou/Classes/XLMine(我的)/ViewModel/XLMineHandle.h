//
//  XLMineHandle.h
//  PiDou
//
//  Created by kevin on 6/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLMineHandle : NSObject

/**钱包信息*/
+ (void)walletInfoWithSuccess:(XLSuccess)success failure:(XLFailure)failure;

/**余额记录*/
+ (void)walletBillWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

/**
 提现申请
 to: 提现到哪 1 微信 2支付宝（暂无）
 */
+ (void)walletTransferWithAmount:(NSString *)amount to:(int)to Success:(XLSuccess)success failure:(XLFailure)failure;


/**
 用户帖子

 @param user_id 用户id 当为本人动态时，传入本人id
 @param page 页码 默认1
 @param success 成功
 @param failure 失败
 */
+ (void)userEntityWithUser_id:(NSString *)user_id page:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

/**用户评论*/
+ (void)userCommentsWithUser_id:(NSString *)user_id page:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

/**用户动态*/
+ (void)userDynamicWithUser_id:(NSString *)user_id page:(int)page success:(XLSuccess)success failure:(XLFailure)failure;


/**
 意见反馈

 @param title 标题 最大字符数 250
 @param nickname 昵称
 @param phone_number 手机号
 @param content 意见内容
 @param success 成功
 @param failure 失败
 */
+ (void)userAdviserWithTitle:(NSString *)title nickname:(NSString *)nickname phone_number:(NSString *)phone_number content:(NSString *)content success:(XLSuccess)success failure:(XLFailure)failure;


/**
 我的邀请

 @param direct 1直接邀请 2间接邀请 默认1
 @param page 页码 默认1
 @param success 成功
 @param failure 失败
 */
+ (void)myInviteWithDirect:(NSInteger)direct page:(int)page success:(XLSuccess)success failure:(XLFailure)failure;


/**
 更新用户信息

 @param nickname 昵称
 @param sign 签名
 @param success 成功
 @param failure 失败
 */
+ (void)userInfoUpdateWithNickname:(NSString *)nickname sign:(NSString *)sign sex:(NSString *)sex avatar:(NSString *)avatar success:(XLSuccess)success failure:(XLFailure)failure;


/**
 兑换星票

 @param amount 金额
 @param success 成功
 @param failure 失败  
 */
+ (void)exchangeXingCoinWithAmount:(double)amount success:(XLSuccess)success failure:(XLFailure)failure;

/**星票记录*/
+ (void)xingCoinBillWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

/**星票打赏*/
+ (void)xingCoinRewardWithEntity_id:(NSString *)entity_id amount:(NSString *)amount success:(XLSuccess)success failure:(XLFailure)failure;

/**公告列表*/
+ (void)announcementWithSuccess:(XLSuccess)success failure:(XLFailure)failure;
/**公告详情*/
+ (void)announcementDetailWithAid:(NSString *)aid success:(XLSuccess)success failure:(XLFailure)failure;

/**用户信息*/
+ (void)userInfoWithUser_id:(NSString *)user_id success:(XLSuccess)success failure:(XLFailure)failure;

/**用户注销*/
+ (void)userCancelWithSuccess:(XLSuccess)success failure:(XLFailure)failure;

/**删除帖子*/
+ (void)entityDeleteWithEntity_id:(NSString *)entity_id success:(XLSuccess)success failure:(XLFailure)failure;

/**删除评论*/
+ (void)commentDeletewithCid:(NSString *)cid success:(XLSuccess)success failure:(XLFailure)failure;

/**微信预支付*/
+ (void)wechatPrePayWithCoin:(NSNumber *)coin success:(XLSuccess)success failure:(XLFailure)failure;

/**申请鉴定师页内容*/
+ (void)applyAppraiserPageWithSuccess:(XLSuccess)success failure:(XLFailure)failure;

@end

NS_ASSUME_NONNULL_END
