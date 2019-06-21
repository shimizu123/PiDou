//
//  XLCommentHandle.h
//  PiDou
//
//  Created by ice on 2019/5/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLCommentHandle : NSObject

/**
 评论列表

 @param entity_id 内容id
 @param page 页码 默认1
 @param success 成功
 @param failure 失败
 */
+ (void)commentListWithEntity_id:(NSString *)entity_id page:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

/**
 评论回复列表
 
 @param cid 内容id
 @param page 页码 默认1
 @param success 成功
 @param failure 失败
 */
+ (void)replyListWithCid:(NSString *)cid page:(int)page success:(XLSuccess)success failure:(XLFailure)failure;


/**
 添加评论

 @param entity_id 内容id
 @param cid 评论的评论id 评论评论时必须填
 @param rid 回复的评论id 回复某人评论时必填
 @param data 评论数据，请看示例数据
 @param success 成功
 @param failure 失败
 */
+ (void)postCommentWithEntity_id:(NSString *)entity_id cid:(NSString *)cid rid:(NSString *)rid data:(id)data success:(XLSuccess)success failure:(XLFailure)failure;



/**
 评论点赞

 @param cid 评论id
 @param success 成功
 @param failure 失败
 */
+ (void)doLikeCommentWithCid:(NSString *)cid success:(XLSuccess)success failure:(XLFailure)failure;

/**分享评论*/
+ (void)commentShareWithCid:(NSString *)cid success:(XLSuccess)success failure:(XLFailure)failure;

@end

NS_ASSUME_NONNULL_END
