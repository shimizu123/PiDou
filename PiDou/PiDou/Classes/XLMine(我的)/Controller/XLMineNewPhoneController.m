//
//  XLMineNewPhoneController.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineNewPhoneController.h"
#import "XLPwdView.h"
#import "CALayer+XLExtension.h"
#import "XLUserLoginHandle.h"
#import <DingxiangCaptchaSDKStatic/DXCaptchaView.h>
#import <DingxiangCaptchaSDKStatic/DXCaptchaDelegate.h>

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

@interface XLMineNewPhoneController ()  <XLPwdViewDelegate, DXCaptchaDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XLPwdView *pwdView;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, copy) NSString *Phone;

@end

@implementation XLMineNewPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑定新的手机";
    
    [self initUI];
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
    
    self.pwdView = [[XLPwdView alloc] init];
    [self.scrollView addSubview:self.pwdView];
    self.pwdView.delegate = self;
    self.pwdView.pwdViewType = XLPwdViewType_resetPhone;
    
    
    self.loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.loginButton];
    [self.loginButton xl_setTitle:@"确认绑定" color:[UIColor whiteColor] size:18.f target:self action:@selector(pwdAction:)];
    self.loginButton.backgroundColor = COLOR(0xE86B6B);
    //    self.loginButton.enabled = NO;
    [self.loginButton.layer setLayerShadow:XL_COLOR_RED offset:(CGSizeMake(0, 2)) radius:8 cornerRadius:LOGIN_BUTTON_HEIGHT * 0.5];
    
    [self initLayout];
}

- (void)initLayout {
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.loginButton);
        make.top.equalTo(self.view.mas_top).mas_offset(48 * kWidthRatio6s);
    }];
    
    
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.top.equalTo(self.pwdView.mas_bottom).mas_offset(40 * kWidthRatio6s);
        make.height.mas_offset(LOGIN_BUTTON_HEIGHT);
    }];
    
    
}

- (void)pwdAction:(UIButton *)button {
    [self.view endEditing:YES];
    NSString *newPhone = self.pwdView.username;
    NSString *code = self.pwdView.code;
    if (XLStringIsEmpty(newPhone)) {
        [HUDController hideHUDWithText:@"请输入新的手机号码"];
        return;
    }
    
    if (XLStringIsEmpty(code)) {
        [HUDController hideHUDWithText:@"请输入z验证码"];
        return;
    }
    
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLUserLoginHandle userChangePhoneWithPhoneNum:newPhone validateToken:self.validate_token code:code success:^(id  _Nonnull responseObject) {
        [HUDController hideHUDWithText:responseObject];
        [WeakSelf.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
    [[self.view viewWithTag:1234] removeFromSuperview];
}

#pragma mark - XLPwdViewDelegate
- (void)getCodeWithPwdView:(XLPwdView *)pwdView {
    [self.view endEditing:YES];
    
    _Phone = self.pwdView.username;
    if (XLStringIsEmpty(_Phone)) {
        [HUDController hideHUDWithText:@"请输入新的手机号码"];
        return;
    }
    
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
            [XLUserLoginHandle userCodeWithPhoneNum:_Phone token:token success:^(NSString *msg) {
                [[self.view viewWithTag:1234] removeFromSuperview];
                [HUDController hideHUDWithText:msg];
                [WeakSelf.pwdView getCodeSuccess];
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


@end
