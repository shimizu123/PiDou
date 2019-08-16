//
//  XLTieziHandle.m
//  PiDou
//
//  Created by ice on 2019/4/30.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLTieziHandle.h"
#import "XLTieziModel.h"

@implementation XLTieziHandle


#pragma mark - 首页内容列表
+ (void)tieziListWithPage:(int)page category:(NSString *)category success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page_no"] = [NSString stringWithFormat:@"%d",page];
    params[@"type"] = category;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Entity];
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



#pragma mark - 内容详情
+ (void)tieziDetailWithEntityID:(NSString *)entityID success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"entity_id"] = entityID;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_EntityDetail];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLTieziModel *tiezi= [XLTieziModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(tiezi);
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

#pragma mark - 内容点赞
+ (void)tieziDolikeWithEntityID:(NSString *)entityID success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"entity_id"] = entityID;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_TieziLike];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            //点赞数量
            //NSNumber *do_like_count= [[responseObject valueForKey:@"data"] valueForKey:@"do_like_count"];
            if (success) {
                success(msg);
            }
        } else if (code == 777) {
            if (failure) {
                failure([NSNumber numberWithInteger:code]);
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

#pragma mark - 第一次调用为收藏 第二次调用为取消收藏
+ (void)tieziCollectWithEntityID:(NSString *)entityID success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"entity_id"] = entityID;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Collect];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 201) {
            //总收藏次数
            //NSNumber *collect_count= [[responseObject valueForKey:@"data"] valueForKey:@"collect_count"];
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

#pragma mark - 分享
+ (void)tieziShareWithEntityID:(NSString *)entityID success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"entity_id"] = entityID;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Share];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            //总收藏次数
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
