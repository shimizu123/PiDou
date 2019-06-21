//
//  XLPublishHandle.h
//  PiDou
//
//  Created by kevin on 29/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLPublishHandle : NSObject


/**
 发布视频、图片、文字和链接

 @param category 类型 video为视频 pic图片 text文字 link链接
 @param topics 话题
 @param content 内容
 @param urls 视频、图片、链接的url [xxx] 发布文字时非必填
 @param success 成功
 @param failure 失败
 */
+ (void)publishWithCategory:(NSString *)category topics:(NSArray *)topics content:(NSString *)content urls:(NSArray *)urls success:(XLSuccess)success failure:(XLFailure)failure;

/**获取阿里云视频上传信息*/
+ (void)getAliyunVideoOSSWithFileName:(NSString *)fileName coverUrl:(NSString *)coverUrl success:(XLSuccess)success failure:(XLFailure)failure;

/**获取阿里云图片上传信息*/
+ (void)getAliyunPhotoOSSWithType:(NSString *)type ext:(NSString *)ext count:(int)count success:(XLSuccess)success failure:(XLFailure)failure;

@end

NS_ASSUME_NONNULL_END
