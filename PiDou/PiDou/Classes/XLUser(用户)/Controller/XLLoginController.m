//
//  XLLoginController.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLLoginController.h"
#import "XLRegisterController.h"
#import "XLForgetController.h"
#import "XLResetPwdController.h"

#import "XLLoginView.h"
#import "CALayer+XLExtension.h"
#import "WXApiRequestHandler.h"
#import "XLUserLoginHandle.h"
#import "XLUserManager.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "XLWechatHandle.h"

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

@interface XLLoginController () <XLLoginViewdelegate, WXApiManagerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XLLoginView *loginView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgetPwdButton;
@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) UILabel *wechatLabel;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UIButton *wechatButton;

@end

@implementation XLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    self.fd_interactivePopDisabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:XLUserRegistNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:XLUpdatePwdNotification object:nil];
    [self initUI];
    
    [WXApiManager sharedManager].delegate = self;
}

- (void)initUI {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H))];
    self.scrollView.bounces = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    UITapGestureRecognizer *tapGeature = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    //tapGeature.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    [self.scrollView addGestureRecognizer:tapGeature];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.loginView = [[XLLoginView alloc] init];
    [self.scrollView addSubview:self.loginView];
    self.loginView.delegate = self;
    
    self.forgetPwdButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.forgetPwdButton];
    [self.forgetPwdButton xl_setTitle:@"忘记密码" color:XL_COLOR_BLACK size:14.f target:self action:@selector(forgetPwdAction)];
    [self.forgetPwdButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    
    self.registerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.scrollView addSubview:self.registerButton];
    [self.registerButton xl_setTitle:@"新用户注册" color:XL_COLOR_BLACK size:14.f target:self action:@selector(registerAction)];
    [self.registerButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    
    
    self.loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.loginButton];
    [self.loginButton xl_setTitle:@"登录" color:[UIColor whiteColor] size:18.f target:self action:@selector(loginAction:)];
    self.loginButton.backgroundColor = XL_COLOR_RED;
    [self.loginButton.layer setLayerShadow:XL_COLOR_RED offset:(CGSizeMake(0, 2)) radius:8 cornerRadius:LOGIN_BUTTON_HEIGHT * 0.5];
    
    self.wechatLabel = [[UILabel alloc] init];
    [self.scrollView addSubview:self.wechatLabel];
    [self.wechatLabel xl_setTextColor:COLOR(0x666666) fontSize:14.f];
    self.wechatLabel.textAlignment = NSTextAlignmentCenter;
    self.wechatLabel.text = @"快捷登录";
    
    self.leftLine = [[UIView alloc] init];
    [self.scrollView addSubview:self.leftLine];
    self.leftLine.backgroundColor = COLOR(0xe6e6e6);
    
    self.rightLine = [[UIView alloc] init];
    [self.scrollView addSubview:self.rightLine];
    self.rightLine.backgroundColor = COLOR(0xe6e6e6);
    
    self.wechatButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.scrollView addSubview:self.wechatButton];
    [self.wechatButton xl_setImageName:@"mine_weixin" target:self action:@selector(onWechat:)];
    
    [self initLayout];
}

- (void)initLayout {
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.loginButton);
        make.top.equalTo(self.view.mas_top).mas_offset(48 * kWidthRatio6s);
    }];
    
    
    [self.forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginView);
        make.width.mas_offset(100 * kWidthRatio6s);
        make.height.mas_offset(40 * kWidthRatio6s);
        make.top.equalTo(self.loginView.mas_bottom).mas_offset(7 * kWidthRatio6s);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginView);
        make.centerY.equalTo(self.forgetPwdButton);
        make.height.width.mas_equalTo(self.forgetPwdButton);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.top.equalTo(self.forgetPwdButton.mas_bottom).mas_offset(40 * kWidthRatio6s);
        make.height.mas_offset(LOGIN_BUTTON_HEIGHT);
    }];
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-102 * kWidthRatio6s - XL_HOME_INDICATOR_H);
        make.width.height.mas_offset(48 * kWidthRatio6s);
    }];
    
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.wechatButton);
        make.bottom.equalTo(self.wechatButton.mas_top).mas_offset(-16 * kWidthRatio6s);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wechatLabel);
        make.right.equalTo(self.wechatLabel.mas_left).mas_offset(-8 * kWidthRatio6s);
        make.height.mas_offset(1 * kWidthRatio6s);
        make.width.mas_offset(33 * kWidthRatio6s);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.leftLine);
        make.left.equalTo(self.wechatLabel.mas_right).mas_offset(8 * kWidthRatio6s);
    }];
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}


#pragma mark - XLLoginViewdelegate
- (void)loginView:(XLLoginView *)loginView didBeginEditing:(UITextField *)textField {
    
}

#pragma mark - 点击登录按钮
- (void)loginAction:(UIButton *)button {
    [self hideKeyBoard];
    
    
    //    [CBNRootManager rootToMainController];
    NSString *username = self.loginView.username;
    NSString *password = self.loginView.password;
    
    if (XLStringIsEmpty(username)) {
        [HUDController hideHUDWithText:@"请输入手机号"];
        return;
    }
    if (XLStringIsEmpty(password)) {
        [HUDController hideHUDWithText:@"请输入密码"];
        return;
    }

    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLUserLoginHandle userLoginWithPhoneNum:username password:password success:^(XLAppUserModel *user) {
        [XLUserManager loginWithUser:user];
        [HUDController hideHUDWithText:@"登录成功"];
        [WeakSelf dismiss];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}


#pragma mark - 点击忘记密码
- (void)forgetPwdAction {
    XLLog(@"点击忘记密码");
    XLForgetController *forgetVC = [[XLForgetController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}


#pragma mark - 点击注册
- (void)registerAction {
    XLLog(@"点击注册");
    XLRegisterController *registerVC = [[XLRegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)onWechat:(UIButton *)button {
    [self sendAuthRequest];
}

#pragma mark - 微信登录
- (void)sendAuthRequest {
    [WXApiRequestHandler sendAuthRequestScope:Wechat_AuthScope
                                        State:Wechat_AuthState
                                       OpenID:Wechat_APP_ID
                             InViewController:self];
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    //    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
    //    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    
    if (XLStringIsEmpty(response.code)) {
        [HUDController hideHUDWithText:@"微信授权失败"];
        return;
    }
    [HUDController xl_showHUD];
    kDefineWeakSelf;
    [XLWechatHandle getAccessTokenWithCode:response.code success:^(NSDictionary *responseObject) {
        NSString *accesstoken = [responseObject valueForKey:@"access_token"];
        NSString *openid = [responseObject valueForKey:@"openid"];
        [XLWechatHandle getWechatInfoWithAccesstoken:accesstoken openid:openid success:^(id  _Nonnull responseObject) {
            // 微信登录
            [WeakSelf loginWechatwithData:responseObject];
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)loginWechatwithData:(id)data {
    
    kDefineWeakSelf;
    [XLUserLoginHandle wechatLoginWithData:data success:^(XLAppUserModel *responseObject) {
        
        if (!XLStringIsEmpty(responseObject.user_id)) {
            // 已经注册过
            [XLUserManager loginWithUser:responseObject];
            [HUDController hideHUDWithText:@"登录成功"];
            [WeakSelf dismiss];
        } else {
            [HUDController hideHUDWithText:@"绑定手机账号"];
            XLRegisterController *registerVC = [[XLRegisterController alloc] init];
            registerVC.validate_token = responseObject.validate_token;
            [self.navigationController pushViewController:registerVC animated:YES];
        }
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
