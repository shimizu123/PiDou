//
//  XLFansFocusController.h
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLFansFocusVCType) {
    XLFansFocusVCType_fans = 0,
    XLFansFocusVCType_focus,
    XLFansFocusVCType_myfocus
};

@interface XLFansFocusController : XLBaseViewController

@property (nonatomic, assign) XLFansFocusVCType vcType;
@property (nonatomic, copy) NSString *user_id;

@end

NS_ASSUME_NONNULL_END
