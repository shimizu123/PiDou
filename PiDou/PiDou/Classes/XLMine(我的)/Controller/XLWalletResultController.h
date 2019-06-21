//
//  XLWalletResultController.h
//  PiDou
//
//  Created by kevin on 12/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLWalletResultType) {
    XLWalletResultType_commit = 0,
    XLWalletResultType_buy,
};

@interface XLWalletResultController : XLBaseViewController

@property (nonatomic, assign) XLWalletResultType resultType;

@end

NS_ASSUME_NONNULL_END
