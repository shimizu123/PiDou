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
 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) XLAppUserModel *user_info;
/**时间戳*/
@property (nonatomic, copy) NSString *created;

@property (nonatomic, strong) XLTieziModel *entity;

@property (nonatomic, strong) XLCommentModel *comment;

/**金额 冻结PDcoin和打赏时有值*/
@property (nonatomic, copy) NSString *amount;

@end

NS_ASSUME_NONNULL_END
