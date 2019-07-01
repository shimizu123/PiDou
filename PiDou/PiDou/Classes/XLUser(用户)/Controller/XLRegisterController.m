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
#import <TCWebCodesSDK/TCWebCodesBridge.h>
#import "IPToolManager.h"

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

@interface XLRegisterController () <XLRegisterViewDelegate, WXApiManagerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XLRegisterView *registerView;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) XLAppUserModel *user;

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
}

#pragma mark - XLRegisterViewDelegate
#pragma mark - 获取验证码
- (void)getCodeWithRegisterView:(XLRegisterView *)registerView {
    [self.view endEditing:YES];
    NSString *phonenum = self.registerView.username;
    if (XLStringIsEmpty(phonenum)) {
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
    
    [[TCWebCodesBridge sharedBridge] setCapOptions:@{@"sdkClose": @YES}];
    
    // 加载腾讯验证码
    [[TCWebCodesBridge sharedBridge] loadTencentCaptcha:self.view appid:@"2060654039" callback:^(NSDictionary *resultJSON) { // appid在验证码接入平台注册申请，此处的1234为测试用appid
        [self showResultJson:resultJSON phone:phonenum];
    }];
    
}

- (void)showResultJson:(NSDictionary*)resultJSON phone:(NSString *)phone {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (0 == [resultJSON[@"ret"] intValue]) {
            
            //  NSString *appid =  resultJSON[@"appid"];//为回传的业务appid
            NSString *ticket = resultJSON[@"ticket"];//为验证码票据
            NSString *randstr =  resultJSON[@"randstr"];//为随机串
            
            //此方法获取具体的ip地址
            IPToolManager *ipManager = [IPToolManager sharedManager];
            NSString *ip = [ipManager currentIPAdressDetailInfo];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"ip"] = ip;
            params[@"ticket"] = ticket;
            params[@"randstr"] = randstr;
            
            
            NSString *url = @"http://pdtv.vip/api/v1.0/tiket";
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
            [manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"成功进入后台接口 %@", responseObject);
                kDefineWeakSelf;
              //  [HUDController xl_showHUD];
                [XLUserLoginHandle userCodeWithPhoneNum:phone success:^(NSString *msg) {
                   // [HUDController hideHUDWithText:msg];
                    [WeakSelf.registerView getCodeSuccess];
                } failure:^(id  _Nonnull result) {
                    [HUDController xl_hideHUDWithResult:result];
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"请求后台接口失败 %@", error);
            }];
            
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"验证失败" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
        }
    });
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
