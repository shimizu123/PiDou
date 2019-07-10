//
//  XLRegisterController.m
//  PiDou
//
//  Created by ice on 2019/4/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLRegisterController.h"
#import "XLRegisterView.h"
#import "CALayer+XLExtension.h"
#import "XLUserLoginHandle.h"
#import "XLUserManager.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "XLWechatHandle.h"
#import "IPToolManager.h"
#import <DingxiangCaptchaSDKStatic/DXCaptchaView.h>
#import <DingxiangCaptchaSDKStatic/DXCaptchaDelegate.h>

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

@interface XLRegisterController () <XLRegisterViewDelegate, WXApiManagerDelegate, DXCaptchaDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XLRegisterView *registerView;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) XLAppUserModel *user;

@property (nonatomic, copy) NSString *phoneNum;

@end

@implementation XLRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    
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
    
    self.registerView = [[XLRegisterView alloc] init];
    [self.scrollView addSubview:self.registerView];
    self.registerView.delegate = self;
    
    
    self.loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.loginButton];
    [self.loginButton xl_setTitle:@"立即注册" color:[UIColor whiteColor] size:18.f target:self action:@selector(registerAction:)];
    self.loginButton.backgroundColor = COLOR(0xE86B6B);
    //self.loginButton.enabled = NO;
    [self.loginButton.layer setLayerShadow:XL_COLOR_RED offset:(CGSizeMake(0, 2)) radius:8 cornerRadius:LOGIN_BUTTON_HEIGHT * 0.5];
    
    [self initLayout];
}

- (void)initLayout {
    [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.loginButton);
        make.top.equalTo(self.view.mas_top).mas_offset(48 * kWidthRatio6s);
    }];
    

    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.top.equalTo(self.registerView.mas_bottom).mas_offset(40 * kWidthRatio6s);
        make.height.mas_offset(LOGIN_BUTTON_HEIGHT);
    }];
    
    
}

- (void)registerAction:(UIButton *)button {
    [self.view endEditing:YES];
    
    NSString *phonenum = self.registerView.username;
    NSString *code = self.registerView.code;
    NSString *invCode = self.registerView.inviteCode;
    NSString *password = self.registerView.password;
    if (XLStringIsEmpty(phonenum)) {
        [HUDController hideHUDWithText:@"请输入手机号码"];
        return;
    } else if (XLStringIsEmpty(self.registerView.code)) {
        [HUDController hideHUDWithText:@"请输入验证码"];
        return;
    } else if (XLStringIsEmpty(self.registerView.password)) {
        [HUDController hideHUDWithText:@"请输入密码"];
        return;
    }
    
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    if (XLStringIsEmpty(self.validate_token)) {
        [XLUserLoginHandle userRegisterWithPhoneNum:phonenum code:code password:password invitationCode:invCode success:^(XLAppUserModel *user) {
            WeakSelf.user = user;
            [XLUserManager loginWithUser:WeakSelf.user];
            [HUDController hideHUDWithText:@"注册成功"];
            
            // 去绑定微信
            [WeakSelf sendAuthRequest];
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    } else {
        [XLUserLoginHandle wechatBindWithPhone:phonenum validate_token:self.validate_token sms_code:code password:password invitation_code:invCode success:^(XLAppUserModel *user) {
            WeakSelf.user = user;
            [XLUserManager loginWithUser:WeakSelf.user];
            [HUDController hideHUDWithText:@"绑定成功"];
            [WeakSelf.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    }
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
    [[self.view viewWithTag:1234] removeFromSuperview];
}

#pragma mark - XLRegisterViewDelegate
#pragma mark - 获取验证码
- (void)getCodeWithRegisterView:(XLRegisterView *)registerView {
    [self.view endEditing:YES];
    _phoneNum = self.registerView.username;
    if (XLStringIsEmpty(_phoneNum)) {
        [HUDController hideHUDWithText:@"请输入手机号码"];
        return;
    }
//    kDefineWeakSelf;
//    [HUDController xl_showHUD];
//    [XLUserLoginHandle userCodeWithPhoneNum:phonenum success:^(NSString *msg) {
//        [HUDController hideHUDWithText:msg];
//        [WeakSelf.registerView getCodeSuccess];
//    } failure:^(id  _Nonnull result) {
//        [HUDController xl_hideHUDWithResult:result];
//    }];
    
    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    // 以下是私有化配置参数 6c3c4dad1338886f994497c8f7a05eaf
    [config setObject:@"6c3c4dad1338886f994497c8f7a05eaf" forKey:@"appId"];
    CGRect frame = CGRectMake(self.view.center.x - 150, self.view.center.y - 250, 300, 200);
    DXCaptchaView *captchaView = [[DXCaptchaView alloc] initWithConfig:config delegate:self frame:frame];
    captchaView.tag = 1234;
    [self.view addSubview:captchaView];
}

//无感验证代理方法
- (void) captchaView:(DXCaptchaView *)view didReceiveEvent:(DXCaptchaEventType)eventType arg:(NSDictionary *)dict {
    switch(eventType) {
        case DXCaptchaEventSuccess: {
            NSString *token = dict[@"token"];;
            kDefineWeakSelf;
            [XLUserLoginHandle userCodeWithPhoneNum:_phoneNum token:token success:^(NSString *msg) {
                [[self.view viewWithTag:1234] removeFromSuperview];
                [HUDController hideHUDWithText:msg];
                [WeakSelf.registerView getCodeSuccess];
            } failure:^(id  _Nonnull result) {
                [HUDController xl_hideHUDWithResult:result];
            }];
            break;
        }
        case DXCaptchaEventFail:
//            [[[UIAlertView alloc] initWithTitle:@"验证失败" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            break;
        default:
            break;
    }
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
        [XLUserManager logout];
        [HUDController hideHUDWithText:@"微信授权失败"];
        return;
    }
    [HUDController xl_showHUD];
    kDefineWeakSelf;
    [XLWechatHandle getAccessTokenWithCode:response.code success:^(NSDictionary *responseObject) {
        NSString *accesstoken = [responseObject valueForKey:@"access_token"];
        NSString *openid = [responseObject valueForKey:@"openid"];
        [XLWechatHandle getWechatInfoWithAccesstoken:accesstoken openid:openid success:^(id  _Nonnull responseObject) {
            // 绑定微信
            [WeakSelf bindWechatwithData:responseObject];
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)bindWechatwithData:(id)data {
    kDefineWeakSelf;
    [XLUserLoginHandle userBindWechatWithData:data success:^(NSString *msg) {
        [HUDController hideHUDWithText:msg];
        
        [WeakSelf.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:XLUserRegistNotification object:nil];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
        [XLUserManager logout];
    }];
}

@end
