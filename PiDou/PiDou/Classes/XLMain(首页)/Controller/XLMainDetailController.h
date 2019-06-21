//
//  XLMainDetailController.h
//  PiDou
//
//  Created by ice on 2019/4/7.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"
#import "XLMainDetailTable.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLMainDetailController : XLBaseViewController

@property (nonatomic, assign) XLMainType mainType;

@property (nonatomic, strong) NSString *entity_id;

@end

NS_ASSUME_NONNULL_END
