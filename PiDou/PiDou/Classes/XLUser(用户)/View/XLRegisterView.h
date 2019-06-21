//
//  XLRegisterView.h
//  PiDou
//
//  Created by ice on 2019/4/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XLRegisterView;
@protocol XLRegisterViewDelegate <NSObject>

- (void)getCodeWithRegisterView:(XLRegisterView *)registerView;

@end

@interface XLRegisterView : UIView



/**账号*/
@property (nonatomic, copy, readonly) NSString *username;
/**邀请码*/
@property (nonatomic, copy, readonly) NSString *inviteCode;
/**验证码*/
@property (nonatomic, copy, readonly) NSString *code;

/**验证码*/
@property (nonatomic, copy, readonly) NSString *password;



@property (nonatomic, weak) id <XLRegisterViewDelegate> delegate;

/**发送验证码成功*/
- (void)getCodeSuccess;

@end

NS_ASSUME_NONNULL_END
