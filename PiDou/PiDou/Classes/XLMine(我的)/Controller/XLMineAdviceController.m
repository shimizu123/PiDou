//
//  XLMineAdviceController.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineAdviceController.h"
#import "NSMutableAttributedString+TGExtension.h"
#import "CALayer+XLExtension.h"
#import "XLTextView.h"
#import "XLMineHandle.h"

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

@interface XLMineAdviceController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *titleTF;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) XLTextView *adviceView;

@end

@implementation XLMineAdviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    
    [self initUI];
}

- (void)initUI {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H))];
    self.scrollView.bounces = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = YES;
    [self.scrollView setContentSize:(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H + 5))];
    self.scrollView.delegate = self;

    [self.view addSubview:self.scrollView];
    UITapGestureRecognizer *tapGeature = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    //tapGeature.cancelsTouchesInView = NO;//设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    [self.scrollView addGestureRecognizer:tapGeature];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.titleTF = [[UITextField alloc] init];
    self.titleTF.textColor = COLOR(0x000000);
    self.titleTF.font = [UIFont xl_fontOfSize:16.f];
    self.titleTF.tintColor = XL_COLOR_BLACK;
    self.titleTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入标题" color:COLOR(0xCCCCCC) font:[UIFont xl_fontOfSize:16.f]];
    [self.scrollView addSubview:self.titleTF];
    
    self.nameTF = [[UITextField alloc] init];
    self.nameTF.textColor = COLOR(0x000000);
    self.nameTF.font = [UIFont xl_fontOfSize:16.f];
    self.nameTF.tintColor = XL_COLOR_BLACK;
    self.nameTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入昵称" color:COLOR(0xCCCCCC) font:[UIFont xl_fontOfSize:16.f]];
    [self.scrollView addSubview:self.nameTF];
    
    self.phoneTF = [[UITextField alloc] init];
    self.phoneTF.textColor = COLOR(0x000000);
    self.phoneTF.font = [UIFont xl_fontOfSize:16.f];
    self.phoneTF.tintColor = XL_COLOR_BLACK;
    self.phoneTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"请输入手机号码" color:COLOR(0xCCCCCC) font:[UIFont xl_fontOfSize:16.f]];
    [self.scrollView addSubview:self.phoneTF];
    self.phoneTF.keyboardType = UIKeyboardTypePhonePad;
    
    self.adviceView = [[XLTextView alloc] init];
    [self.scrollView addSubview:self.adviceView];
    self.adviceView.backgroundColor = [UIColor whiteColor];
    self.adviceView.font = [UIFont xl_fontOfSize:16.f];
    self.adviceView.textColor = COLOR(0x000000);
    self.adviceView.tintColor = XL_COLOR_BLACK;
    self.adviceView.placeholderColor = COLOR(0xCCCCCC);
    self.adviceView.placeholder = @"请输入意见反馈内容";
    
    
    self.commitButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.commitButton];
    [self.commitButton xl_setTitle:@"提交" color:[UIColor whiteColor] size:18.f target:self action:@selector(commitAction:)];
    self.commitButton.backgroundColor = XL_COLOR_RED;
    [self.commitButton.layer setLayerShadow:XL_COLOR_RED offset:(CGSizeMake(0, 2)) radius:8 cornerRadius:LOGIN_BUTTON_HEIGHT * 0.5];
    
    
    
    [self initLayout];
}

- (void)initLayout {
    [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-16 * kWidthRatio6s);
        make.top.equalTo(self.scrollView);
        make.height.mas_offset(48 * kWidthRatio6s);
    }];
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.titleTF);
        make.top.equalTo(self.titleTF.mas_bottom).mas_offset(0);
    }];

    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.titleTF);
        make.top.equalTo(self.nameTF.mas_bottom).mas_offset(0);
    }];
    
    [self.adviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(16 * kWidthRatio6s - 5);
        make.right.equalTo(self.titleTF);
        make.top.equalTo(self.phoneTF.mas_bottom);
        make.height.mas_offset(120 * kWidthRatio6s);
    }];

    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-16 * kWidthRatio6s - XL_HOME_INDICATOR_H);
        make.height.mas_offset(LOGIN_BUTTON_HEIGHT);
    }];
}

- (void)commitAction:(UIButton *)button {
    NSString *title = self.titleTF.text;
    NSString *nickname = self.nameTF.text;
    NSString *phonenum = self.phoneTF.text;
    NSString *content = self.adviceView.text;
    if (XLStringIsEmpty(title)) {
        [HUDController hideHUDWithText:@"请输入标题"];
        return;
    }
    
    if (XLStringIsEmpty(nickname)) {
        [HUDController hideHUDWithText:@"请输入昵称"];
        return;
    }
    
    if (XLStringIsEmpty(phonenum)) {
        [HUDController hideHUDWithText:@"请输入手机号码"];
        return;
    }
    
    if (XLStringIsEmpty(content)) {
        [HUDController hideHUDWithText:@"请输入反馈内容"];
        return;
    }
    
    [HUDController xl_showHUD];
    kDefineWeakSelf;
    [XLMineHandle userAdviserWithTitle:title nickname:nickname phone_number:phonenum content:content success:^(id  _Nonnull responseObject) {
        [HUDController hideHUDWithText:responseObject];
        [WeakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideKeyBoard];
}

@end
