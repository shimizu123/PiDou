//
//  XLWalletExchangeController.h
//  PiDou
//
//  Created by kevin on 12/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLWalletExchangeController : XLBaseViewController

/**余额 rmb*/
@property (nonatomic, strong) NSNumber *balance;

/**单位rmb能兑换的星票数 如2则表示 1rmb兑换2星票*/
@property (nonatomic, strong) NSNumber *rmb2coin;

@end

NS_ASSUME_NONNULL_END
