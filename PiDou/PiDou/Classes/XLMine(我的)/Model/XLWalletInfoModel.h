//
//  XLWalletInfoModel.h
//  PiDou
//
//  Created by kevin on 7/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLWalletInfoModel : NSObject

/**用户id*/
@property (nonatomic, copy) NSString *uid;
/**余额 rmb*/
@property (nonatomic, strong) NSNumber *balance;
/**星票余额*/
@property (nonatomic, strong) NSNumber *coin;
/**持有PDcoin数*/
@property (nonatomic, strong) NSNumber *pdcoin;
/**冻结PDcoin数*/
@property (nonatomic, strong) NSNumber *freeze_pdcoin;
/**当天是否参与了社区回馈0否 1是*/
@property (nonatomic, strong) NSNumber *join_profit;
/**单位rmb能兑换的星票数 如2则表示 1rmb兑换2星票*/
@property (nonatomic, strong) NSNumber *rmb2coin;
/**打赏时 1星票可以生成的PDcoin数  特定时间产生PDcoin*/
@property (nonatomic, copy) NSString *coin2pdcoin;
/**是否产生PDcoin 0否 1是*/
@property (nonatomic, strong) NSNumber *generate_pdcoin;

@end

NS_ASSUME_NONNULL_END
