//
//  XLMsgModel.h
//  PiDou
//
//  Created by kevin on 10/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XLCommentModel;
@class XLTieziModel;

@interface XLMsgModel : NSObject

/**
 类型 详细见下文
 1 评论内容
 2 回复
 3 赞
 4 关注
 5 PDcoin被冻结
 6  打赏
 7 解冻pdc
 8 成功转入PDC
 9 转出PDC失败
 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) XLAppUserModel *user_info;
/**时间戳*/
@property (nonatomic, copy) NSString *created;

@property (nonatomic, strong) XLTieziModel *entity;

@property (nonatomic, strong) XLCommentModel *comment;

/**金额 冻结PDcoin和打赏时有值*/
@property (nonatomic, copy) NSString *amount;

//已读消息
@property (nonatomic, copy) NSString *isread;
@property (nonatomic, copy) NSString *message_id;

@property (nonatomic, copy) NSString *transfer_type;
@property (nonatomic, copy) NSString *transfer_telphone;

@end

NS_ASSUME_NONNULL_END
