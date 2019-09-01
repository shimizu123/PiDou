//
//  XLPDCoinHandle.h
//  PiDou
//
//  Created by kevin on 6/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLPDCoinHandle : NSObject

/**待领取PDCoin列表*/
+ (void)pdCoinListWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

/**领取PDCoin*/
+ (void)pdCoinPickWithPid:(NSString *)pid success:(XLSuccess)success failure:(XLFailure)failure;

/**PDCoin账单明细*/
+ (void)pdCoinBillPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

/**申请参与社区回馈*/
+ (void)joinProfitWithSuccess:(XLSuccess)success failure:(XLFailure)failure;

/**参与社区回馈记录*/
+ (void)joinProfitBillWithPage:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

/**获取PDcoin页面*/
+ (void)gainPDCoinWaysWithSuccess:(XLSuccess)success failure:(XLFailure)failure;

/**获取PDcoin*/
+ (void)gainPDCoinCode:(NSString *)code type:(NSString *)type success:(XLSuccess)success failure:(XLFailure)failure;

/**广告*/
+ (void)advWithSuccess:(XLSuccess)success failure:(XLFailure)failure;

// PDCoin转出
+ (void)pdCoinOutflow:(NSString *)amount transferType:(NSString *)transferType tel:(NSString *)telephone success:(XLSuccess)success failure:(XLFailure)failure;

// PDCoin转出转入明细
+ (void)outflowDetail:(int)page success:(XLSuccess)success failure:(XLFailure)failure;

@end

NS_ASSUME_NONNULL_END
