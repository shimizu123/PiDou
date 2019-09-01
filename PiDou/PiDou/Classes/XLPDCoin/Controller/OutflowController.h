//
//  OutflowController.h
//  PiDou
//
//  Created by 邓康大 on 2019/8/29.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OutflowController : XLBaseViewController
singleton_h(OutflowController)

@property (nonatomic, copy) NSString *pdcBalance;

- (void)outflowTo;

@end

NS_ASSUME_NONNULL_END
