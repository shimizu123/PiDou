//
//  XLLoginView.m
//  PiDou
//
//  Created by ice on 2019/4/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLLoginView.h"
#import "NSMutableAttributedString+TGExtension.h"

@interface XLLoginView () <UITextFieldDelegate>

/**账号*/
@property (nonatomic, strong) UITextField *accountTF;
/**密码*/
@property (nonatomic, strong) UITextField *pwdTF;

@property (nonatomic, strong) UIView *accountLineV;
@property (nonatomic, strong) UIView *pwdLineV;

@property (nonatomic, strong) UIButton *secureTextButton;

@end

@implementation XLLoginView

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
    self.pwdTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入密码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
    self.pwdTF.secureTextEntry = YES;
    [self addSubview:self.pwdTF];
    
    self.secureTextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.secureTextButton xl_setImageName:@"mine_security" selectImage:@"mine_unsecurity" target:self action:@selector(secureTextAction:)];
    [self addSubview:self.secureTextButton];
    
    self.accountLineV = [[UIView alloc] init];
    self.accountLineV.backgroundColor = XL_COLOR_LINE;
    [self addSubview:self.accountLineV];
    
    self.pwdLineV = [[UIView alloc] init];
    self.pwdLineV.backgroundColor = XL_COLOR_LINE;
    [self addSubview:self.pwdLineV];
    
    [self initLayout];
}

- (void)initLayout {
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(48 * kWidthRatio6s);
    }];
    
    [self.accountLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.accountTF);
        make.top.equalTo(self.accountTF.mas_bottom);
        make.height.mas_offset(1);
    }];
    
    [self.pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.accountTF);
        make.top.equalTo(self.accountLineV.mas_bottom).mas_offset(17 * kWidthRatio6s);
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
        make.bottom.equalTo(self.mas_bottom);
    }];
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

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(loginView:didBeginEditing:)]) {
        [_delegate loginView:self didBeginEditing:textField];
    }
}

#pragma mark - getter
- (NSString *)username {
    return self.accountTF.text;
}

- (NSString *)password {
    return self.pwdTF.text;
}




@end
