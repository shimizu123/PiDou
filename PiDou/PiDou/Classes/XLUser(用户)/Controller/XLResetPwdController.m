//
//  XLResetPwdController.m
//  PiDou
//
//  Created by ice on 2019/4/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLResetPwdController.h"
#import "XLResetPwdView.h"
#import "CALayer+XLExtension.h"
#import "XLUserLoginHandle.h"

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

@interface XLResetPwdController () <XLResetPwdViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XLResetPwdView *resetPwdView;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation XLResetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"重置密码";
    
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
    
    self.resetPwdView = [[XLResetPwdView alloc] init];
    [self.scrollView addSubview:self.resetPwdView];
    self.resetPwdView.delegate = self;

    self.loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.loginButton];
    [self.loginButton xl_setTitle:@"确认重置" color:[UIColor whiteColor] size:18.f target:self action:@selector(loginAction:)];
    self.loginButton.backgroundColor = XL_COLOR_RED;
    //self.loginButton.enabled = NO;
    [self.loginButton.layer setLayerShadow:XL_COLOR_RED offset:(CGSizeMake(0, 2)) radius:8 cornerRadius:LOGIN_BUTTON_HEIGHT * 0.5];
    
    
    [self initLayout];
}

- (void)initLayout {
    [self.resetPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.loginButton);
        make.top.equalTo(self.view.mas_top).mas_offset(48 * kWidthRatio6s);
    }];
    

    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.top.equalTo(self.resetPwdView.mas_bottom).mas_offset(40 * kWidthRatio6s);
        make.height.mas_offset(LOGIN_BUTTON_HEIGHT);
    }];
    
    
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}


#pragma mark - XLResetPwdViewDelegate


#pragma mark - 重置密码
- (void)loginAction:(UIButton *)button {
    [self hideKeyBoard];
    
    
    //    [CBNRootManager rootToMainController];
    NSString *username = self.resetPwdView.password;
    NSString *password = self.resetPwdView.confirmPwd;
    
    if (XLStringIsEmpty(username)) {
        [HUDController hideHUDWithText:@"请输入密码"];
        return;
    }
    if (XLStringIsEmpty(password)) {
        [HUDController hideHUDWithText:@"请再次输入密码"];
        return;
    }
    if (![username isEqualToString:password]) {
        [HUDController hideHUDWithText:@"两次密码不一致，请重新输入"];
        return;
    }
    
    
    [HUDController xl_showHUD];
    [XLUserLoginHandle userForgetPasswordWithPhoneNum:self.phone_number validateToken:self.validate_token newPassword:username success:^(NSString *msg) {
        [HUDController hideHUDWithText:msg];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:XLUpdatePwdNotification object:nil];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

@end
