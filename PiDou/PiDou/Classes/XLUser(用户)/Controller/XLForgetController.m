//
//  XLForgetController.m
//  PiDou
//
//  Created by ice on 2019/4/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLForgetController.h"
#import "XLResetPwdController.h"

#import "XLPwdView.h"
#import "CALayer+XLExtension.h"
#import "XLUserLoginHandle.h"

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

@interface XLForgetController () <XLPwdViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XLPwdView *pwdView;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation XLForgetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"忘记密码";
    [self initUI];
    
}

- (void)initUI {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
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
    
    
    self.loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.loginButton];
    [self.loginButton xl_setTitle:@"下一步" color:[UIColor whiteColor] size:18.f target:self action:@selector(pwdAction:)];
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
    NSString *phonenum = self.pwdView.username;
    NSString *code = self.pwdView.code;
    if (XLStringIsEmpty(phonenum)) {
        [HUDController hideHUDWithText:@"请输入手机号码"];
        return;
    }
    if (XLStringIsEmpty(code)) {
        [HUDController hideHUDWithText:@"请输入验证码"];
        return;
    }
    
    [HUDController xl_showHUD];
    [XLUserLoginHandle userCheckCodeWithPhoneNum:phonenum action:@"forget_password" code:code success:^(NSString *responseObject) {
        [HUDController hideHUD];
        XLResetPwdController *resetPwdVC = [[XLResetPwdController alloc] init];
        resetPwdVC.phone_number = phonenum;
        resetPwdVC.validate_token = responseObject;
        [self.navigationController pushViewController:resetPwdVC animated:YES];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
    
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}

#pragma mark - XLPwdViewDelegate

- (void)getCodeWithPwdView:(XLPwdView *)pwdView {
    NSString *phonenum = self.pwdView.username;
    if (XLStringIsEmpty(phonenum)) {
        [HUDController hideHUDWithText:@"请输入手机号码"];
        return;
    }
    kDefineWeakSelf;
    [HUDController xl_showHUD];
    [XLUserLoginHandle userCodeWithPhoneNum:phonenum success:^(id  _Nonnull responseObject) {
        [HUDController hideHUDWithText:responseObject];
        [WeakSelf.pwdView getCodeSuccess];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
    
}


@end
