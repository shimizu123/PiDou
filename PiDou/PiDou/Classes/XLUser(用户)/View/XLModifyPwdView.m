//
//  XLModifyPwdView.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLModifyPwdView.h"
#import "NSMutableAttributedString+TGExtension.h"

@interface XLModifyPwdView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UIView *accountLineV;

@property (nonatomic, strong) UITextField *inviteCodeTF;
@property (nonatomic, strong) UIView *invLineV;

@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) UIView *codeLineV;

@end

@implementation XLModifyPwdView


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
    self.accountTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入旧的密码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
    self.accountTF.clearButtonMode = UITextFieldViewModeAlways;
    [self addSubview:self.accountTF];
    self.accountTF.delegate = self;
    
    self.inviteCodeTF = [[UITextField alloc] init];
    self.inviteCodeTF.textColor = COLOR(0x000000);
    self.inviteCodeTF.font = [UIFont xl_fontOfSize:16.f];
    self.inviteCodeTF.tintColor = XL_COLOR_BLACK;
    self.inviteCodeTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"确认密码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
    self.inviteCodeTF.secureTextEntry = YES;
    [self addSubview:self.inviteCodeTF];
    
    self.accountLineV = [[UIView alloc] init];
    self.accountLineV.backgroundColor = XL_COLOR_LINE;
    [self addSubview:self.accountLineV];
    
    self.invLineV = [[UIView alloc] init];
    self.invLineV.backgroundColor = XL_COLOR_LINE;
    [self addSubview:self.invLineV];
    
    self.codeTF = [[UITextField alloc] init];
    self.codeTF.textColor = COLOR(0x000000);
    self.codeTF.font = [UIFont xl_fontOfSize:16.f];
    self.codeTF.tintColor = XL_COLOR_BLACK;
    self.codeTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入新的密码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
    [self addSubview:self.codeTF];
    self.codeTF.secureTextEntry = YES;
    
    self.codeLineV = [[UIView alloc] init];
    self.codeLineV.backgroundColor = XL_COLOR_LINE;
    [self addSubview:self.codeLineV];
    
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
        make.left.right.height.equalTo(self.inviteCodeTF);
        make.top.equalTo(self.accountLineV.mas_bottom).mas_offset(17 * kWidthRatio6s);
    }];
    
    
    [self.codeLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.invLineV);
        make.top.equalTo(self.codeTF.mas_bottom);
    }];
    
    [self.inviteCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountTF);
        make.top.equalTo(self.codeLineV.mas_bottom).mas_offset(17 * kWidthRatio6s);
    }];
    
    
    [self.invLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountLineV);
        make.top.equalTo(self.inviteCodeTF.mas_bottom);
        make.bottom.equalTo(self);
    }];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (NSString *)oldPassword {
    return self.accountTF.text;
}

- (NSString *)nw1Password {
    return self.codeTF.text;
}

- (NSString *)nw2Password {
    return self.inviteCodeTF.text;
}


@end
