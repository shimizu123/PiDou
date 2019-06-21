//
//  XLResetPwdView.h
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLResetPwdViewDelegate <NSObject>



@end

@interface XLResetPwdView : UIView

/**密码*/
@property (nonatomic, copy, readonly) NSString *password;
/**确认密码*/
@property (nonatomic, copy, readonly) NSString *confirmPwd;



@property (nonatomic, weak) id <XLResetPwdViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
