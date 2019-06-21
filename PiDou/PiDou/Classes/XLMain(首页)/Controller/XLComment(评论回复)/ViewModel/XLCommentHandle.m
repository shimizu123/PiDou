//
//  XLCommentHandle.m
//  PiDou
//
//  Created by ice on 2019/5/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCommentHandle.h"
#import "XLCommentModel.h"

@implementation XLCommentHandle

#pragma mark - 评论列表
+ (void)commentListWithEntity_id:(NSString *)entity_id page:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    params[@"entity_id"] = entity_id;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Comment];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *tieziArr= [XLCommentModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
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


#pragma mark - 评论回复列表
+ (void)replyListWithCid:(NSString *)cid page:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    params[@"cid"] = cid;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Reply];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLCommentModel *comment = [XLCommentModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(comment);
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


#pragma mark - 添加评论
+ (void)postCommentWithEntity_id:(NSString *)entity_id cid:(NSString *)cid rid:(NSString *)rid data:(id)data success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!XLStringIsEmpty(entity_id)) {
        params[@"entity_id"] = entity_id;
    }
    if (!XLStringIsEmpty(cid)) {
        params[@"cid"] = cid;
    }
    if (!XLStringIsEmpty(rid)) {
        params[@"rid"] = rid;
    }
    params[@"data"] = data;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_AddComment];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            // 新增评论的评论id
            //NSString *cid= [[responseObject valueForKey:@"data"] valueForKey:@"cid"];
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


#pragma mark - 评论点赞
+ (void)doLikeCommentWithCid:(NSString *)cid success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cid"] = cid;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_likeComment];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            // 新增评论的评论id
            //NSNumber *do_like_count= [[responseObject valueForKey:@"data"] valueForKey:@"do_like_count"];
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

/**分析评论*/
+ (void)commentShareWithCid:(NSString *)cid success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cid"] = cid;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_CommentShare];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            // 新增评论的评论id
            //NSNumber *do_like_count= [[responseObject valueForKey:@"data"] valueForKey:@"do_like_count"];
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

@end
