//
//  ChainWalletController.m
//  PiDou
//
//  Created by 邓康大 on 2019/8/30.
//  Copyright © 2019 ice. All rights reserved.
//

#import "ChainWalletController.h"
#import "NSMutableAttributedString+TGExtension.h"
#import "OutflowController.h"

@interface ChainWalletController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UILabel *withdrawLab;
@property (nonatomic, strong) UITextField *pdcoinTF;
@property (nonatomic, strong) UILabel *lab2;
@property (nonatomic, strong) UILabel *addressLab;
@property (nonatomic, strong) UITextField *chainAddressTF;
@property (nonatomic, strong) UIView *separatorLine1;
@property (nonatomic, strong) UIView *separatorLine2;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UILabel *lab3;

@end

@implementation ChainWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    self.navigationItem.title = @"区块钱包";
    
    self.lab1 = [[UILabel alloc] init];
    [self.view addSubview:self.lab1];
    self.lab1.text = [NSString stringWithFormat:@"可转出剩余PDCoin：%@", self.pdcBalance];
    [self.lab1 xl_setTextColor:XL_COLOR_DARKBLACK fontSize:17.f];
    
    self.allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.allBtn];
    [self.allBtn xl_setTitle:@"全部转出" color:XL_COLOR_RED size:14.f target:self action:@selector(allOutflow)];
    
    self.withdrawLab = [[UILabel alloc] init];
    [self.view addSubview:self.withdrawLab];
    self.withdrawLab.text = @"提现";
    [self.withdrawLab xl_setTextColor:XL_COLOR_DARKBLACK fontSize:14.f];
    
    self.pdcoinTF = [[UITextField alloc] init];
    [self.view addSubview:self.pdcoinTF];
    self.pdcoinTF.textColor = XL_COLOR_DARKBLACK;
    self.pdcoinTF.font = [UIFont systemFontOfSize:30.f * kWidthRatio6s];
    self.pdcoinTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"最低提现数量10000PDCoin" color:XL_COLOR_DARKGRAY font:[UIFont xl_fontOfSize:12.f]];
    self.pdcoinTF.delegate = self;
    self.pdcoinTF.clearButtonMode = UITextFieldViewModeAlways;
    self.pdcoinTF.keyboardType = UIKeyboardTypePhonePad;
    
    self.lab2 = [[UILabel alloc] init];
    [self.view addSubview:self.lab2];
    self.lab2.text = @"5%手续费";
    [self.lab2 xl_setTextColor:XL_COLOR_RED fontSize:10.f];
    
    self.separatorLine1 = [[UIView alloc] init];
    [self.view addSubview:self.separatorLine1];
    self.separatorLine1.backgroundColor = RGB_COLOR(242, 242, 245);
    
    self.addressLab = [[UILabel alloc] init];
    [self.view addSubview:self.addressLab];
    self.addressLab.text = @"地址";
    [self.addressLab xl_setTextColor:XL_COLOR_DARKBLACK fontSize:14.f];
    
    self.chainAddressTF = [[UITextField alloc] init];
    [self.view addSubview:self.chainAddressTF];
    self.chainAddressTF.textColor = XL_COLOR_DARKBLACK;
    self.chainAddressTF.font = [UIFont systemFontOfSize:30.f * kWidthRatio6s];
    self.chainAddressTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"长按粘贴以太坊钱包地址" color:XL_COLOR_DARKGRAY font:[UIFont xl_fontOfSize:12.f]];
    self.chainAddressTF.delegate = self;
    self.chainAddressTF.clearButtonMode = UITextFieldViewModeAlways;
    
    self.separatorLine2 = [[UIView alloc] init];
    [self.view addSubview:self.separatorLine2];
    self.separatorLine2.backgroundColor = RGB_COLOR(242, 242, 245);
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn xl_setTitle:@"确认转出" color:RGB_COLOR_A(255, 255, 255, 0.35) size:17.f target:self action:@selector(confirmOutflow)];
    self.confirmBtn.backgroundColor = XL_COLOR_RED;
    XLViewRadius(self.confirmBtn, 22 * kWidthRatio6s);
    
    self.lab3 = [[UILabel alloc] init];
    [self.view addSubview:self.lab3];
    self.lab3.text = @"提示:区块钱包审核将在1－3个工作日内完成!";
    [self.lab3 xl_setTextColor:XL_COLOR_DARKGRAY fontSize:12.f];
    
    [self initLayout];
}

- (void)initLayout {
    [self.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(20 * kWidthRatio6s);
        make.left.equalTo(self.view).mas_offset(17 * kWidthRatio6s);
    }];
    
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).mas_offset(-16 * kWidthRatio6s);
        make.centerY.equalTo(self.lab1);
    }];
    
    [self.withdrawLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab1);
        make.top.equalTo(self.lab1.mas_bottom).mas_offset(49 * kWidthRatio6s);
    }];
    
    [self.pdcoinTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.withdrawLab.mas_right).mas_offset(70 * kWidthRatio6s);
        make.width.mas_offset(180 * kWidthRatio6s);
        make.centerY.equalTo(self.withdrawLab);
    }];
    
    [self.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.withdrawLab);
        make.right.equalTo(self.allBtn);
        make.width.mas_offset(48 * kWidthRatio6s);
    }];
    
    [self.separatorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.withdrawLab.mas_bottom).mas_offset(18 * kWidthRatio6s);
        make.left.equalTo(self.view).mas_offset(15 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-15 * kWidthRatio6s);
        make.height.mas_offset(1 * kWidthRatio6s);
    }];
    
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separatorLine1.mas_bottom).mas_offset(18 * kWidthRatio6s);
        make.left.equalTo(self.withdrawLab);
    }];
    
    [self.chainAddressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pdcoinTF);
        make.centerY.equalTo(self.addressLab);
        make.width.mas_offset(190 * kWidthRatio6s);
    }];
    
    [self.separatorLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLab.mas_bottom).mas_offset(18 * kWidthRatio6s);
        make.left.equalTo(self.view).mas_offset(15 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-15 * kWidthRatio6s);
        make.height.mas_offset(1 * kWidthRatio6s);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separatorLine2.mas_bottom).mas_offset(50 * kWidthRatio6s);
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.height.mas_offset(44 * kWidthRatio6s);
    }];
    
    [self.lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.confirmBtn.mas_bottom).mas_offset(50 * kWidthRatio6s);
    }];
    
}

// 全部转出
- (void)allOutflow {
    self.pdcoinTF.text = self.pdcBalance;
}

// 确认转出
- (void)confirmOutflow {
    if (XLStringIsEmpty(_pdcoinTF.text)) {
        [HUDController hideHUDWithText:@"请输入提现数量"];
        return;
    }
    if (XLStringIsEmpty(_addressLab.text)) {
        [HUDController hideHUDWithText:@"请输入手机号"];
        return;
    }
    [[OutflowController sharedOutflowController] outflowTo];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.pdcoinTF endEditing:YES];
    [self.chainAddressTF endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!XLStringIsEmpty(_pdcoinTF.text) && !XLStringIsEmpty(_chainAddressTF.text)) {
        [self.confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else {
        [self.confirmBtn setTitleColor:RGB_COLOR_A(255, 255, 255, 0.35) forState:UIControlStateNormal];
    }
    return YES;
}

@end
