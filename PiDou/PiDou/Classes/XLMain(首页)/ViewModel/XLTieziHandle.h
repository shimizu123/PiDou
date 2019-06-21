//
//  XLTieziHandle.h
//  PiDou
//
//  Created by ice on 2019/4/30.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLTieziHandle : NSObject


/**
 首页内容列表

 @param page 页码
 @param category 类型 视频 video 图片pic 段子text 推荐时请置为空或不传入
 @param success 成功
 @param failure 失败
 */
+ (void)tieziListWithPage:(int)page category:(NSString *)category success:(XLSuccess)success failure:(XLFailure)failure;



/**
 内容详情

 @param entityID 内容id
 @param success 成功
 @param failure 失败
 */
+ (void)tieziDetailWithEntityID:(NSString *)entityID success:(XLSuccess)success failure:(XLFailure)failure;

/**
 内容点赞
 
 @param entityID 内容id
 @param success 成功
 @param failure 失败
 */
+ (void)tieziDolikeWithEntityID:(NSString *)entityID success:(XLSuccess)success failure:(XLFailure)failure;


/**
 第一次调用为收藏 第二次调用为取消收藏

 @param entityID 内容id
 @param success 成功
 @param failure 失败
 */
+ (void)tieziCollectWithEntityID:(NSString *)entityID success:(XLSuccess)success failure:(XLFailure)failure;

/**
 分享
 
 @param entityID 内容id
 @param success 成功
 @param failure 失败
 */
+ (void)tieziShareWithEntityID:(NSString *)entityID success:(XLSuccess)success failure:(XLFailure)failure;

@end

NS_ASSUME_NONNULL_END
