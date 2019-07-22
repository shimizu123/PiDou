//
//  XLMgsHandle.h
//  PiDou
//
//  Created by kevin on 10/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLMgsHandle : NSObject

/**消息*/
+ (void)messageWithPage:(int)page category:(NSString *)category success:(XLSuccess)success failure:(XLFailure)failure;

//未读消息总数
+ (void)unreadMessageCount:(XLSuccess)success failure:(XLFailure)failure;

//消息标记为已读
+ (void)messageReaded:(NSString *)messageId success:(XLSuccess)success failure:(XLFailure)failure;

@end

NS_ASSUME_NONNULL_END
