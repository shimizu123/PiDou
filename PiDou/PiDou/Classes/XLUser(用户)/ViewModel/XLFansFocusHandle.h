//
//  XLFansFocusHandle.h
//  PiDou
//
//  Created by ice on 2019/4/28.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLFansFocusHandle : NSObject

/**粉丝列表*/
+ (void)fansListWithPage:(int)page user_id:(NSString *)user_id success:(XLSuccess)success failure:(XLFailure)failure;

/**关注列表*/
+ (void)focusListWithUser_id:(NSString *)user_id success:(XLSuccess)success failure:(XLFailure)failure;

/**关注用户*/
+ (void)followUserWithUid:(NSString *)uid success:(XLSuccess)success failure:(XLFailure)failure;

/**取消关注*/
+ (void)unfollowUserWithUid:(NSString *)uid success:(XLSuccess)success failure:(XLFailure)failure;

/**关注的话题*/
+ (void)myFollowTopicsWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

/**热门话题*/
+ (void)hotTopicsWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

/**关注取消话题*/
+ (void)followTopicWithTopicID:(NSString *)topicID success:(XLSuccess)success failure:(XLFailure)failure;

/**我的收藏*/
+ (void)myCollectedWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

/**话题详细*/
+ (void)topicDetailWithTopic_id:(NSString *)topic_id page:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

@end

NS_ASSUME_NONNULL_END
