//
//  XLResetPwdView.m
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLResetPwdView.h"
#import "NSMutableAttributedString+TGExtension.h"

@interface XLResetPwdView () <UITextFieldDelegate>

/**密码*/
@property (nonatomic, strong) UITextField *accountTF;
/**确认密码*/
@property (nonatomic, strong) UITextField *pwdTF;

@property (nonatomic, strong) UIView *accountLineV;
@property (nonatomic, strong) UIView *pwdLineV;

@end

@implementation XLResetPwdView


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
    self.accountTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入新的密码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
    self.accountTF.secureTextEntry = YES;
    [self addSubview:self.accountTF];
    self.accountTF.delegate = self;
    
    self.pwdTF = [[UITextField alloc] init];
    self.pwdTF.textColor = COLOR(0x000000);
    self.pwdTF.font = [UIFont xl_fontOfSize:16.f];
    self.pwdTF.tintColor = XL_COLOR_BLACK;
    self.pwdTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"确认密码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
    self.pwdTF.secureTextEntry = YES;
    [self addSubview:self.pwdTF];
    
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
        make.left.right.height.equalTo(self.accountTF);
        make.top.equalTo(self.accountLineV.mas_bottom).mas_offset(17 * kWidthRatio6s);
    }];
    
    
    [self.pwdLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountLineV);
        make.top.equalTo(self.pwdTF.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

#pragma mark - getter
- (NSString *)password {
    return self.accountTF.text;
}

- (NSString *)confirmPwd {
    return self.pwdTF.text;
}



@end
