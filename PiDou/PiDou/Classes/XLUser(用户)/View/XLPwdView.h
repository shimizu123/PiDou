//
//  XLPwdView.h
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XLPwdViewType) {
    XLPwdViewType_forgetPwd = 0,
    XLPwdViewType_resetPhone,
};

@class XLPwdView;
@protocol XLPwdViewDelegate <NSObject>

- (void)getCodeWithPwdView:(XLPwdView *)pwdView;

@end

@interface XLPwdView : UIView


/**账号*/
@property (nonatomic, copy, readonly) NSString *username;
/**验证码*/
@property (nonatomic, copy, readonly) NSString *code;



@property (nonatomic, weak) id <XLPwdViewDelegate> delegate;

@property (nonatomic, assign) XLPwdViewType pwdViewType;

/**发送验证码成功*/
- (void)getCodeSuccess;

@end

NS_ASSUME_NONNULL_END
