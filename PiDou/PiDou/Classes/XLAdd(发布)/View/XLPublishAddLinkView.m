//
//  XLPublishAddLinkView.m
//  PiDou
//
//  Created by ice on 2019/4/14.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPublishAddLinkView.h"
#import "NSMutableAttributedString+TGExtension.h"
#import "XLLimitTextField.h"

@interface XLPublishAddLinkView ()

@property (nonatomic, strong) UIView *linkView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) XLLimitTextField *linkTF;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, copy) XLCompletedBlock complete;

@end

@implementation XLPublishAddLinkView

- (instancetype)initPublishAddLinkViewWithComplete:(XLCompletedBlock)complete {
    self.complete = complete;
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = COLOR_A(0x000000, 0.4);
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self addGestureRecognizer:tap];
    
    self.linkView = [[UIView alloc] init];
    [self addSubview:self.linkView];
    self.linkView.backgroundColor = [UIColor whiteColor];
    XLViewRadius(self.linkView, 8 * kWidthRatio6s);
    
    self.titleL = [[UILabel alloc] init];
    [self.linkView addSubview:self.titleL];
    [self.titleL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.text = @"添加链接";
    
    self.linkTF = [[XLLimitTextField alloc] init];
    self.linkTF.textColor = COLOR(0x000000);
    self.linkTF.font = [UIFont xl_fontOfSize:14.f];
    self.linkTF.tintColor = XL_COLOR_BLACK;
    self.linkTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入链接" color:COLOR(0xb6b6b8) font:[UIFont xl_fontOfSize:14.f]];
    self.linkTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.linkView addSubview:self.linkTF];
    self.linkTF.leftSpacing = @(16 * kWidthRatio6s);
//    self.linkTF.delegate = self;
    XLViewBorderRadius(self.linkTF, 2 * kWidthRatio6s, 1, CGCOLOR(0xe6e6e6));
    
    self.confirmButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.linkView addSubview:self.confirmButton];
    [self.confirmButton xl_setTitle:@"确认" color:[UIColor whiteColor] size:14.f target:self action:@selector(confirmAction)];
    self.confirmButton.backgroundColor = XL_COLOR_RED;
    XLViewRadius(self.confirmButton, 3 * kWidthRatio6s);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initLayout];
}

- (void)initLayout {
    [self.linkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).mas_offset(8 * kWidthRatio6s);
        make.height.mas_offset(144 * kWidthRatio6s + XL_HOME_INDICATOR_H);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linkView).mas_offset(12 * kWidthRatio6s);
        make.height.mas_offset(24 * kWidthRatio6s);
        make.left.right.equalTo(self.linkView);
    }];
    
    [self.linkTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.linkView).mas_offset(16 * kWidthRatio6s);
        make.top.equalTo(self.titleL.mas_bottom).mas_offset(32 * kWidthRatio6s);
        make.height.mas_offset(36 * kWidthRatio6s);
        make.right.equalTo(self.confirmButton.mas_left).mas_offset(-16 * kWidthRatio6s);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.linkTF);
        make.right.equalTo(self.linkView).mas_offset(-16 * kWidthRatio6s);
        make.height.mas_offset(36 * kWidthRatio6s);
        make.width.mas_offset(80 * kWidthRatio6s);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleL.text = _title;
    self.linkTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入验证码" color:COLOR(0xb6b6b8) font:[UIFont xl_fontOfSize:14.f]];
    [self.confirmButton setTitle:@"验证" forState:(UIControlStateNormal)];
}

- (void)confirmAction {
    if (self.complete) {
        self.complete(self.linkTF.text);
    }
}

#pragma mark - 监控键盘
- (void)keyboardChange:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (notification.name == UIKeyboardWillShowNotification) {
        CGFloat kbH = keyboardEndFrame.size.height;

        self.linkView.xl_y = self.xl_h - kbH - self.linkView.xl_h + 8 * kWidthRatio6s;
        
    } else if (notification.name == UIKeyboardWillHideNotification){
        self.linkView.xl_y = self.xl_h - self.linkView.xl_h + 8 * kWidthRatio6s;
    }
    
    [UIView commitAnimations];
    
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    [self.linkTF resignFirstResponder];
    if (self.complete) {
        self.complete(self.linkTF.text);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
