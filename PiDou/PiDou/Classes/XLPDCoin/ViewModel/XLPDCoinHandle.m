//
//  XLPDCoinHandle.m
//  PiDou
//
//  Created by kevin on 6/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPDCoinHandle.h"
#import "XLPDCoinModel.h"
#import "XLGainPDCoinModel.h"
#import "XLAdvModel.h"
#import "PdcOutflowRecordModel.h"

@implementation XLPDCoinHandle

/**待领取PDCoin列表*/
+ (void)pdCoinListWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_PDCoin];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLPDCoinModel *pcCoinModel = [XLPDCoinModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
            if (success) {
                success(pcCoinModel);
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

/**领取PDCoin*/
+ (void)pdCoinPickWithPid:(NSString *)pid success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = pid;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_PDCoinPick];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            // 持有PDcoin数
            NSString *pdcoin_count= [[responseObject valueForKey:@"data"] valueForKey:@"pdcoin_count"];
            if (success) {
                success(pdcoin_count);
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

/**PDCoin账单明细*/
+ (void)pdCoinBillPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_PDCoinBill];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *tieziArr= [XLPDRecordModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
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


/**申请参与社区回馈*/
+ (void)joinProfitWithSuccess:(XLSuccess)success failure:(XLFailure)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_JoinProfit];
    [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
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

/**参与社区回馈记录*/
+ (void)joinProfitBillWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_JoinProfitBill];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [XLPDRecordModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
            for (XLPDRecordModel *record in data) {
                record.type = @(3);
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

/**获取PDcoin页面*/
+ (void)gainPDCoinWaysWithSuccess:(XLSuccess)success failure:(XLFailure)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_GainPDcoinWays];
    [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            XLGainPDCoinModel *model = [XLGainPDCoinModel mj_objectWithKeyValues:[responseObject valueForKey:@"data"]];
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

/**获取PDcoin*/
+ (void)gainPDCoinCode:(NSString *)code type:(NSString *)type success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"validate_code"] = code;
    params[@"type"] = type;
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_GainPDcoin];
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

/**广告*/
+ (void)advWithSuccess:(XLSuccess)success failure:(XLFailure)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_Adv];
    [XLAFNetworking post:url params:nil success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [XLAdvModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
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

// PDCoin转出
+ (void)pdCoinOutflow:(NSString *)amount transferType:(NSString *)transferType tel:(NSString *)telephone success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"amount"] = amount;
    params[@"transfer_type"] = transferType;
    params[@"telphone"] = telephone;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_PdcTurnOut];
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

// PDCoin转出转入明细
+ (void)outflowDetail:(int)page success:(XLSuccess)success failure:(XLFailure)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,Url_TurnOutBill];
    [XLAFNetworking post:url params:params success:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        
        if (code == 200) {
            NSMutableArray *data = [PdcOutflowRecordModel mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"data"]];
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

@end
