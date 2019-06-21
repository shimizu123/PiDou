//
//  XLBaseViewController.h
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLBaseViewController : UIViewController

/**隐藏回退按钮*/
- (void)xl_hiddenleftBarButtonItem;
- (BOOL)isShowingOnKeyWindow:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
