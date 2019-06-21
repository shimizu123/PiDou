//
//  XLWalletWithDrawController.h
//  PiDou
//
//  Created by kevin on 12/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLWalletWithDrawController : XLBaseViewController

/**余额*/
@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic, assign) NSInteger selectType;

@end

NS_ASSUME_NONNULL_END
