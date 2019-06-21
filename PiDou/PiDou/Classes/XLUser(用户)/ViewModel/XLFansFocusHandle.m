//
//  XLFansFocusHandle.m
//  PiDou
//
//  Created by ice on 2019/4/28.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLFansFocusHandle.h"
#import "XLFansModel.h"
#import "XLTopicModel.h"
#import "XLTieziModel.h"

@implementation XLFansFocusHandle

/**粉丝列表*/
+ (void)fansListWithPage:(int)page user_id:(NSString *)user_id success:(XLSuccess)success failure:(XLFailure)failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = user_id;
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Fans];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [XLFansModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
            if (success) {
                success(data);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**关注列表*/
+ (void)focusListWithUser_id:(NSString *)user_id success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = user_id;
    //params[@"page"] = page;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Followers];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [XLFansModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
            if (success) {
                success(data);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**关注用户*/
+ (void)followUserWithUid:(NSString *)uid success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = uid;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_FollowUser];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 201) {
            if (success) {
                success(msg);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**取消关注*/
+ (void)unfollowUserWithUid:(NSString *)uid success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = uid;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_UnfollowUser];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 201) {
            if (success) {
                success(msg);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**关注的话题*/
+ (void)myFollowTopicsWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = [XLUserHandle userid];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_MyFollowTopic];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [XLTopicModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
            for (XLTopicModel *topic in data) {
                topic.followed = @1;
            }
            if (success) {
                success(data);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**热门话题*/
+ (void)hotTopicsWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = [XLUserHandle userid];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_HotTopic];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [XLTopicModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
            if (success) {
                success(data);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**关注取消话题*/
+ (void)followTopicWithTopicID:(NSString *)topicID success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"topic_id"] = topicID;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_FollowTopic];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 201) {
            //NSNumber *followed = [[responseObject valueForKey:@"data"] valueForKey:@"followed"];
            if (success) {
                success(msg);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**我的收藏*/
+ (void)myCollectedWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_MyCollected];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];

        if (code == 200) {
            NSMutableArray *tieziArr= [XLTieziModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
            if (success) {
                success(tieziArr);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**话题详细*/
+ (void)topicDetailWithTopic_id:(NSString *)topic_id page:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    params[@"topic_id"] = topic_id;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_TopicDetail];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLTopicModel *topicDetail= [XLTopicModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(topicDetail);
            }
        } else {
            if (failure) {
                failure(msg);
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
