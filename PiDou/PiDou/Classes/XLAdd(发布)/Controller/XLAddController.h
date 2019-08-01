//
//  XLAddController.h
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLAddController : XLBaseViewController
singleton_h(XLAddController)

@property (nonatomic, assign) NSInteger preTabbarItemIndex;
@property (nonatomic, strong) UIImage *preViewImage;

- (void)dismiss;

- (void)goVideoVC;

@end

NS_ASSUME_NONNULL_END
