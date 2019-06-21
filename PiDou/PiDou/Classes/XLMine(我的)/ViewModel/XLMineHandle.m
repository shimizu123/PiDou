//
//  XLMineHandle.m
//  PiDou
//
//  Created by kevin on 6/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineHandle.h"
#import "XLWalletInfoModel.h"
#import "XLPDRecordModel.h"
#import "XLTieziModel.h"
#import "XLCommentModel.h"
#import "XLFansModel.h"
#import "XLAnnouncement.h"
#import "XLPayOrderModel.h"

@implementation XLMineHandle

/**钱包信息*/
+ (void)walletInfoWithSuccess:(XLSuccess)success failure:(XLFailure)failure {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_WalletInfo];
    [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLWalletInfoModel *info= [XLWalletInfoModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(info);
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

/**余额记录*/
+ (void)walletBillWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_WalletBill];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data= [XLPDRecordModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
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

/**提现申请*/
+ (void)walletTransferWithAmount:(NSString *)amount to:(int)to Success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"amount"] = amount;
    params[@"to"] = @(to);
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_WalletTransfer];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
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

/**
 用户帖子
 
 @param user_id 用户id 当为本人动态时，传入本人id
 @param page 页码 默认1
 @param success 成功
 @param failure 失败
 */
+ (void)userEntityWithUser_id:(NSString *)user_id page:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = user_id;
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_UserEntity];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [XLTieziModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
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

/**用户评论*/
+ (void)userCommentsWithUser_id:(NSString *)user_id page:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = user_id;
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_UserComments];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [XLCommentModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
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

/**用户动态*/
+ (void)userDynamicWithUser_id:(NSString *)user_id page:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = user_id;
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_UserDynamic];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [NSMutableArray array];
            for (NSMutableDictionary *dic in [responseObject valueForKey:@"data"]) {
                NSString *category = dic[@"category"];
                if ([category isEqualToString:@"comment"]) {
                    XLCommentModel *commentModel = [XLCommentModel mj_objectWithKeyValues:dic];
                    [data addObject:commentModel];
                } else {
                    XLTieziModel *tieziModel = [XLTieziModel mj_objectWithKeyValues:dic];
                    [data addObject:tieziModel];
                }
            }
            //NSMutableArray *data = [XLTieziModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
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

/**
 意见反馈
 */
+ (void)userAdviserWithTitle:(NSString *)title nickname:(NSString *)nickname phone_number:(NSString *)phone_number content:(NSString *)content success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"title"] = title;
    params[@"nickname"] = nickname;
    params[@"phone_number"] = phone_number;
    params[@"content"] = content;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_UserAdvise];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
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


/**
 我的邀请
 */
+ (void)myInviteWithDirect:(NSInteger)direct page:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"direct"] = [NSString stringWithFormat:@"%ld",direct];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_MyInvite];
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

/**
 更新用户信息
 */
+ (void)userInfoUpdateWithNickname:(NSString *)nickname sign:(NSString *)sign sex:(NSString *)sex avatar:(NSString *)avatar success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!XLStringIsEmpty(nickname)) {
        params[@"nickname"] = nickname;
    }
    if (!XLStringIsEmpty(sign)) {
        params[@"sign"] = sign;
    }
    if (!XLStringIsEmpty(sex)) {
        params[@"sex"] = sex;
    }
    if (!XLStringIsEmpty(avatar)) {
        params[@"avatar"] = avatar;
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_UserInfoUpdate];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 201) {
            [[NSNotificationCenter defaultCenter] postNotificationName:XLUpdateInfoNotification object:nil];
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

/**
 兑换星票
 */
+ (void)exchangeXingCoinWithAmount:(double)amount success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"amount"] = [NSString stringWithFormat:@"%f",amount];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_ExchangeCoin];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
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

/**星票记录*/
+ (void)xingCoinBillWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_XingCoinBill];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [XLPDRecordModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
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

/**星票打赏*/
+ (void)xingCoinRewardWithEntity_id:(NSString *)entity_id amount:(NSString *)amount success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"entity_id"] = entity_id;
    params[@"amount"] = amount;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_XingReward];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
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

/**公告列表*/
+ (void)announcementWithSuccess:(XLSuccess)success failure:(XLFailure)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Announcement];
    [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [XLAnnouncement mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
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

/**公告详情*/
+ (void)announcementDetailWithAid:(NSString *)aid success:(XLSuccess)success failure:(XLFailure)failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = aid;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_AnnoDetail];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLAnnouncement *model= [XLAnnouncement mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(model);
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

/**用户信息*/
+ (void)userInfoWithUser_id:(NSString *)user_id success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = user_id;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_UserInfo];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLAppUserModel *user = [XLAppUserModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(user);
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

/**用户注销*/
+ (void)userCancelWithSuccess:(XLSuccess)success failure:(XLFailure)failure {

    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_UserCancel];
    [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
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

/**删除帖子*/
+ (void)entityDeleteWithEntity_id:(NSString *)entity_id success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"entity_id"] = entity_id;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_EntityDelete];
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

/**删除评论*/
+ (void)commentDeletewithCid:(NSString *)cid success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cid"] = cid;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_CommentDelete];
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

/**微信预支付*/
+ (void)wechatPrePayWithCoin:(NSNumber *)coin success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"coin"] = [NSString stringWithFormat:@"%@",coin];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_WechatPrePay];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            if (success) {
                XLPayOrderModel *order = [XLPayOrderModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
                success(order);
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

/**申请鉴定师页内容*/
+ (void)applyAppraiserPageWithSuccess:(XLSuccess)success failure:(XLFailure)failure {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_AppraiserPage];
    [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            if (success) {
                NSString *content = [[responseObject valueForKey:@"data"] valueForKey:@"content"];
                success(content);
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
