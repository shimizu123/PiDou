//
//  XLModifyPwdController.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLModifyPwdController.h"
#import "XLModifyPwdView.h"
#import "CALayer+XLExtension.h"
#import "XLForgetController.h"
#import "XLUserLoginHandle.h"

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

@interface XLModifyPwdController () <XLModifyPwdViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) XLModifyPwdView *modifyPwdView;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *forgetPwdButton;

@end

@implementation XLModifyPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    
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
    
    self.modifyPwdView = [[XLModifyPwdView alloc] init];
    [self.scrollView addSubview:self.modifyPwdView];
    self.modifyPwdView.delegate = self;
    
    
    self.loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.loginButton];
    [self.loginButton xl_setTitle:@"确认修改" color:[UIColor whiteColor] size:18.f target:self action:@selector(modifyPwdAction:)];
    self.loginButton.backgroundColor = COLOR(0xE86B6B);
    //self.loginButton.enabled = NO;
    [self.loginButton.layer setLayerShadow:XL_COLOR_RED offset:(CGSizeMake(0, 2)) radius:8 cornerRadius:LOGIN_BUTTON_HEIGHT * 0.5];
    
    self.forgetPwdButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.forgetPwdButton];
    [self.forgetPwdButton xl_setTitle:@"忘记密码？" color:XL_COLOR_DARKGRAY size:14.f target:self action:@selector(forgetPwdAction:)];
    
    [self initLayout];
}

- (void)initLayout {
    [self.modifyPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.loginButton);
        make.top.equalTo(self.view.mas_top).mas_offset(48 * kWidthRatio6s);
    }];
    
    
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.top.equalTo(self.modifyPwdView.mas_bottom).mas_offset(40 * kWidthRatio6s);
        make.height.mas_offset(LOGIN_BUTTON_HEIGHT);
    }];
    
    [self.forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.loginButton);
        make.top.equalTo(self.loginButton.mas_bottom).mas_offset(10 * kWidthRatio6s);
        make.height.mas_offset(40 * kWidthRatio6s);
    }];
    
}

- (void)modifyPwdAction:(UIButton *)button {
    
    [self.view endEditing:YES];
    NSString *oldPwd = self.modifyPwdView.oldPassword;
    NSString *newPwd1 = self.modifyPwdView.nw1Password;
    NSString *newPwd2 = self.modifyPwdView.nw2Password;
    
    if (XLStringIsEmpty(oldPwd)) {
        [HUDController hideHUDWithText:@"请输入旧的密码"];
        return;
    }
    
    if (XLStringIsEmpty(newPwd1)) {
        [HUDController hideHUDWithText:@"请输入新的密码"];
        return;
    }
    
    if (XLStringIsEmpty(newPwd2)) {
        [HUDController hideHUDWithText:@"请输入确认密码"];
        return;
    }
    
    if (![newPwd1 isEqualToString:newPwd2]) {
        [HUDController hideHUDWithText:@"新的密码和确认密码不一致，请重新输入"];
        return;
    }
    
    [HUDController xl_showHUD];
    [XLUserLoginHandle userChangePasswordWithOldPassword:oldPwd newPassword:newPwd1 success:^(NSString *msg) {
        [HUDController hideHUDWithText:msg];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)forgetPwdAction:(UIButton *)button {
    XLForgetController *forgetVC = [[XLForgetController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark - XLModifyPwdViewDelegate

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}



@end
