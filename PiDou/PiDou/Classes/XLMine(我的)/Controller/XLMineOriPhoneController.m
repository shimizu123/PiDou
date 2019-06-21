//
//  XLMineOriPhoneController.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineOriPhoneController.h"
#import "CALayer+XLExtension.h"
#import "XLVerityBtn.h"
#import "NSMutableAttributedString+TGExtension.h"
#import "XLMineNewPhoneController.h"
#import "XLUserLoginHandle.h"

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

@interface XLMineOriPhoneController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *phoneNumL;

/**验证码*/
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) XLVerityBtn *codeButton;
@property (nonatomic, strong) UIView *codeLineV;

@property (nonatomic, strong) UIButton *loginButton;


@end

@implementation XLMineOriPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"更换手机";
    
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
    
    self.phoneNumL = [[UILabel alloc] init];
    [self.scrollView addSubview:self.phoneNumL];
    [self.phoneNumL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    self.phoneNumL.textAlignment = NSTextAlignmentCenter;
    self.phoneNumL.text = [NSString stringWithFormat:@"当前绑定手机：%@",self.phoneNum];
    
    
    self.codeTF = [[UITextField alloc] init];
    self.codeTF.textColor = COLOR(0x000000);
    self.codeTF.font = [UIFont xl_fontOfSize:16.f];
    self.codeTF.tintColor = XL_COLOR_BLACK;
    self.codeTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入验证码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
    [self.scrollView addSubview:self.codeTF];
    
    self.codeButton = [XLVerityBtn buttonWithType:(UIButtonTypeCustom)];
    [self.scrollView addSubview:self.codeButton];
    [self.codeButton addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.codeLineV = [[UIView alloc] init];
    self.codeLineV.backgroundColor = XL_COLOR_LINE;
    [self.scrollView addSubview:self.codeLineV];
    self.codeLineV.hidden = YES;
    
    
    self.loginButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.loginButton];
    [self.loginButton xl_setTitle:@"下一步" color:[UIColor whiteColor] size:18.f target:self action:@selector(nextAction:)];
    self.loginButton.backgroundColor = XL_COLOR_RED;
//    self.loginButton.enabled = NO;
    [self.loginButton.layer setLayerShadow:XL_COLOR_RED offset:(CGSizeMake(0, 2)) radius:8 cornerRadius:LOGIN_BUTTON_HEIGHT * 0.5];
    
    [self initLayout];
}

- (void)initLayout {
    [self.phoneNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.loginButton);
        make.top.equalTo(self.view.mas_top).mas_offset(XL_NAVIBAR_H + 28 * kWidthRatio6s);
    }];
    
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginButton);
        make.top.equalTo(self.phoneNumL.mas_bottom).mas_offset(29 * kWidthRatio6s);
        make.height.mas_offset(48 * kWidthRatio6s);
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeTF.mas_right);
        make.right.equalTo(self.loginButton);
        make.width.mas_offset(150 * kWidthRatio6s);
        make.top.bottom.equalTo(self.codeTF);
    }];
    
    
    [self.codeLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.loginButton);
        make.height.mas_offset(1);
        make.top.equalTo(self.codeTF.mas_bottom);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.top.equalTo(self.codeLineV.mas_bottom).mas_offset(48 * kWidthRatio6s);
        make.height.mas_offset(LOGIN_BUTTON_HEIGHT);
    }];
    
}

- (void)getCode:(XLVerityBtn *)btn {
    [HUDController xl_showHUD];
    [XLUserLoginHandle userCodeWithPhoneNum:self.phoneNum success:^(NSString *msg) {
        [HUDController hideHUDWithText:msg];
        [btn getCode];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];

    
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}

- (void)nextAction:(UIButton *)button {
    [self.view endEditing:YES];
    NSString *code = self.codeTF.text;
    if (XLStringIsEmpty(code)) {
        [HUDController hideHUDWithText:@"请输入验证码"];
        return;
    }
    [HUDController xl_showHUD];
    [XLUserLoginHandle userCheckCodeWithPhoneNum:self.phoneNum action:@"change_phone" code:code success:^(NSString *responseObject) {
        
        [HUDController hideHUD];
        
        XLMineNewPhoneController *newPhoneVC = [[XLMineNewPhoneController alloc] init];
        newPhoneVC.validate_token = responseObject;
        [self.navigationController pushViewController:newPhoneVC animated:YES];
        
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

@end
