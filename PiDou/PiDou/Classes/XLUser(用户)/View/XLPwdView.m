//
//  XLPwdView.m
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPwdView.h"
#import "NSMutableAttributedString+TGExtension.h"
#import "XLVerityBtn.h"

@interface XLPwdView () <UITextFieldDelegate>

/**账号*/
@property (nonatomic, strong) UITextField *accountTF;

@property (nonatomic, strong) UIView *accountLineV;

/**验证码*/
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong) XLVerityBtn *codeButton;
@property (nonatomic, strong) UIView *codeLineV;


@end

@implementation XLPwdView



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
    self.accountTF.tag = 1103;
    
    self.accountLineV = [[UIView alloc] init];
    self.accountLineV.backgroundColor = XL_COLOR_LINE;
    [self addSubview:self.accountLineV];
    
   
    
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
        make.left.height.equalTo(self.accountTF);
        make.top.equalTo(self.accountLineV.mas_bottom).mas_offset(17 * kWidthRatio6s);
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeTF.mas_right);
        make.right.equalTo(self);
        make.width.mas_offset(150 * kWidthRatio6s);
        make.top.bottom.equalTo(self.codeTF);
    }];
    
    
    [self.codeLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountLineV);
        make.top.equalTo(self.codeTF.mas_bottom);
        make.bottom.equalTo(self);
    }];

}

- (void)getCode:(XLVerityBtn *)btn {
    
    
    
    if (XLStringIsEmpty(self.username)) {
        [HUDController hideHUDWithText:@"请输入账号"];
        return;
    }
    //[btn getCode];
    if (_delegate && [_delegate respondsToSelector:@selector(getCodeWithPwdView:)]) {
        [_delegate getCodeWithPwdView:self];
    }
}

/**发送验证码成功*/
- (void)getCodeSuccess {
    [self.codeButton getCode];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 1103) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            return NO;
        }
        if (strLength < 11) {
            self.codeButton.enabled = NO;
        } else {
            self.codeButton.enabled = YES;
        }
        
        BOOL res = YES;
        NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        int i = 0;
        while (i < string.length) {
            NSString * str= [string substringWithRange:NSMakeRange(i, 1)];
            NSRange range = [str rangeOfCharacterFromSet:tmpSet];
            if (range.length == 0) {
                res = NO;
                break;
            }
            i++;
        }
        return res;
    }
    return YES;
}

#pragma mark - getter
- (NSString *)username {
    return self.accountTF.text;
}


- (NSString *)code {
    return self.codeTF.text;
}

- (void)setPwdViewType:(XLPwdViewType)pwdViewType {
    _pwdViewType = pwdViewType;
    if (_pwdViewType == XLPwdViewType_resetPhone) {
        self.accountTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入新的手机号码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
        self.codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    } else {
        self.accountTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入手机号码" color:XL_COLOR_GRAY font:[UIFont xl_fontOfSize:16.f]];
        self.codeTF.clearButtonMode = UITextFieldViewModeNever;
    }
}
@end
