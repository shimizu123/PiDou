//
//  XLRegisterView.m
//  PiDou
//
//  Created by ice on 2019/4/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLRegisterView.h"
#import "NSMutableAttributedString+TGExtension.h"
#import "XLVerityBtn.h"

@interface XLRegisterView () <UITextFieldDelegate>

/**账号*/
@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *pwdTF;
/**密码*/
@property (nonatomic, strong) UITextField *inviteCodeTF;

@property (nonatomic, strong) UIView *accountLineV;
@property (nonatomic, strong) UIView *pwdLineV;
@property (nonatomic, strong) UIView *invLineV;

/**验证码*/
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) XLVerityBtn *codeButton;
@property (nonatomic, strong) UIView *codeLineV;

@property (nonatomic, strong) UIButton *secureTextButton;

@end

@implementation XLRegisterView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.accountTF = [[UITextField alloc] init];
    self.accountTF.textColor = COLOR(0x000000);
    self.accountTF.font = [UIFont xl_fontOfSize:16.f];
    self.accountTF.tintColor = XL_COLOR_BLACK;
    self.accountTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入手机号码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
    self.accountTF.clearButtonMode = UITextFieldViewModeAlways;
    self.accountTF.keyboardType = UIKeyboardTypePhonePad;
    [self addSubview:self.accountTF];
    self.accountTF.delegate = self;
    
    self.pwdTF = [[UITextField alloc] init];
    self.pwdTF.textColor = COLOR(0x000000);
    self.pwdTF.font = [UIFont xl_fontOfSize:16.f];
    self.pwdTF.tintColor = XL_COLOR_BLACK;
    self.pwdTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请设置密码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
    self.pwdTF.secureTextEntry = YES;
    [self addSubview:self.pwdTF];
    
    self.secureTextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.secureTextButton xl_setImageName:@"mine_security" selectImage:@"mine_unsecurity" target:self action:@selector(secureTextAction:)];
    [self addSubview:self.secureTextButton];
    
    self.inviteCodeTF = [[UITextField alloc] init];
    self.inviteCodeTF.textColor = COLOR(0x000000);
    self.inviteCodeTF.font = [UIFont xl_fontOfSize:16.f];
    self.inviteCodeTF.tintColor = XL_COLOR_BLACK;
    self.inviteCodeTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入邀请码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
    //self.inviteCodeTF.secureTextEntry = YES;
    [self addSubview:self.inviteCodeTF];
    
    self.accountLineV = [[UIView alloc] init];
    self.accountLineV.backgroundColor = XL_COLOR_LINE;
    [self addSubview:self.accountLineV];
    
    self.pwdLineV = [[UIView alloc] init];
    self.pwdLineV.backgroundColor = XL_COLOR_LINE;
    [self addSubview:self.pwdLineV];
    
    self.invLineV = [[UIView alloc] init];
    self.invLineV.backgroundColor = XL_COLOR_LINE;
    [self addSubview:self.invLineV];
    
    self.codeTF = [[UITextField alloc] init];
    self.codeTF.textColor = COLOR(0x000000);
    self.codeTF.font = [UIFont xl_fontOfSize:16.f];
    self.codeTF.tintColor = XL_COLOR_BLACK;
    self.codeTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入验证码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
    [self addSubview:self.codeTF];
    
    self.codeButton = [XLVerityBtn buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.codeButton];
    [self.codeButton addTarget:self action:@selector(getCode:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.codeLineV = [[UIView alloc] init];
    self.codeLineV.backgroundColor = XL_COLOR_LINE;
    [self addSubview:self.codeLineV];
    //self.codeLineV.hidden = YES;
    
    [self initLayout];
}

- (void)initLayout {
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).mas_offset(0);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(48 * kWidthRatio6s);
    }];
    
    [self.accountLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.accountTF);
        make.top.equalTo(self.accountTF.mas_bottom);
        make.height.mas_offset(1);
    }];
    
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.inviteCodeTF);
        make.top.equalTo(self.accountLineV.mas_bottom).mas_offset(17 * kWidthRatio6s);
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeTF.mas_right);
        make.right.equalTo(self);
        make.width.mas_offset(150 * kWidthRatio6s);
        make.top.bottom.equalTo(self.codeTF);
    }];
    
    
    [self.codeLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.invLineV);
        make.top.equalTo(self.codeTF.mas_bottom);
    }];
    
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.accountTF);
        make.top.equalTo(self.codeLineV.mas_bottom).mas_offset(17 * kWidthRatio6s);
        make.right.equalTo(self.secureTextButton.mas_left).mas_offset(-5 * kWidthRatio6s);
    }];
    
    
    [self.secureTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.accountTF);
        make.centerY.equalTo(self.pwdTF);
        make.height.width.mas_offset(24 * kWidthRatio6s);
    }];
    
    [self.pwdLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountLineV);
        make.top.equalTo(self.pwdTF.mas_bottom);
    }];
    
   
    
    [self.inviteCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountTF);
        make.top.equalTo(self.pwdLineV.mas_bottom).mas_offset(17 * kWidthRatio6s);
    }];
    
    
    [self.invLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountLineV);
        make.top.equalTo(self.inviteCodeTF.mas_bottom);
        make.bottom.equalTo(self);
    }];
}

- (void)getCode:(XLVerityBtn *)btn {
    
    
    
    if (XLStringIsEmpty(self.username)) {
        [HUDController hideHUDWithText:@"请输入手机号码"];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(getCodeWithRegisterView:)]) {
        [_delegate getCodeWithRegisterView:self];
    }
    
    //[btn getCode];
   
}

/**发送验证码成功*/
- (void)getCodeSuccess {
    [self.codeButton getCode];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  
}

#pragma mark - getter
- (NSString *)username {
    return self.accountTF.text;
}

- (NSString *)inviteCode {
    return self.inviteCodeTF.text;
}

- (NSString *)code {
    return self.codeTF.text;
}

- (NSString *)password {
    return self.pwdTF.text;
}

- (void)secureTextAction:(UIButton *)button {
    button.selected = !button.selected;
    NSString *text = self.pwdTF.text;
    if (button.selected) {
        self.pwdTF.secureTextEntry = NO;
        self.pwdTF.text = text;
    } else {
        self.pwdTF.secureTextEntry = YES;
        self.pwdTF.text = text;
    }
}


@end
