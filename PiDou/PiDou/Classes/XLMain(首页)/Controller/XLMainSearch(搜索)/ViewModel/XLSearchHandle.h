//
//  XLSearchHandle.h
//  PiDou
//
//  Created by ice on 2019/5/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLSearchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLSearchHandle : NSObject


/**
 搜索

 @param keyword 关键词
 @param page 页码 默认1
 @param category 类别 综合时传入空字符或不设置 视频 video 图片pic 段子 text 用户user 话题 topic
 @param success 成功
 @param failure 失败
 */
+ (void)searchResultWithKeyword:(NSString *)keyword page:(int)page category:(NSString *)category success:(XLSuccess)success failure:(XLFailure)failure;

@end

NS_ASSUME_NONNULL_END
