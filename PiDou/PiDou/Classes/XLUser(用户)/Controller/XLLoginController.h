//
//  XLLoginController.h
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLLoginController : XLBaseViewController

//微信登录，用于绑定手机号的参数
@property (nonatomic, copy) NSString *validate_token;

@end

NS_ASSUME_NONNULL_END
