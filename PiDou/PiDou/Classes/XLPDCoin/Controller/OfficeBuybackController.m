//
//  OfficeBuybackController.m
//  PiDou
//
//  Created by 邓康大 on 2019/8/31.
//  Copyright © 2019 ice. All rights reserved.
//

#import "OfficeBuybackController.h"
#import "NSMutableAttributedString+TGExtension.h"
#import "OutflowController.h"

@interface OfficeBuybackController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) UILabel *buybackLab;
@property (nonatomic, strong) UITextField *pdcoinTF;
@property (nonatomic, strong) UILabel *lab2;
@property (nonatomic, strong) UIView *separatorLine1;
@property (nonatomic, strong) UILabel *lab3;
@property (nonatomic, strong) UILabel *lab4;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UILabel *lab5;

@end

@implementation OfficeBuybackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    self.navigationItem.title = @"官方回购";
    
    self.lab1 = [[UILabel alloc] init];
    [self.view addSubview:self.lab1];
    self.lab1.text = [NSString stringWithFormat:@"可转出剩余PDCoin：%@", self.pdcBalance];
    [self.lab1 xl_setTextColor:XL_COLOR_DARKBLACK fontSize:17.f];
    
    self.allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.allBtn];
    [self.allBtn xl_setTitle:@"全部转出" color:XL_COLOR_RED size:14.f target:self action:@selector(allOutflow)];
    
    self.buybackLab = [[UILabel alloc] init];
    [self.view addSubview:self.buybackLab];
    self.buybackLab.text = @"回购数量";
    [self.buybackLab xl_setTextColor:XL_COLOR_DARKBLACK fontSize:14.f];
    
    self.pdcoinTF = [[UITextField alloc] init];
    [self.view addSubview:self.pdcoinTF];
    self.pdcoinTF.textColor = XL_COLOR_DARKBLACK;
    self.pdcoinTF.font = [UIFont systemFontOfSize:30.f * kWidthRatio6s];
    self.pdcoinTF.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"最低回购数量10000PDCoin" color:XL_COLOR_DARKGRAY font:[UIFont xl_fontOfSize:12.f]];
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
    
    self.lab3 = [[UILabel alloc] init];
    [self.view addSubview:self.lab3];
    self.lab3.text = @"今日回购单价：0.01元/pdcoin";
    [self.lab3 xl_setTextColor:XL_COLOR_DARKGRAY fontSize:14.f];
    
    self.lab4 = [[UILabel alloc] init];
    [self.view addSubview:self.lab4];
    self.lab4.text = @"官方回购账号：10010001086";
    [self.lab4 xl_setTextColor:XL_COLOR_DARKGRAY fontSize:14.f];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn xl_setTitle:@"确认转出" color:RGB_COLOR_A(255, 255, 255, 0.35) size:17.f target:self action:@selector(confirmOutflow)];
    self.confirmBtn.backgroundColor = XL_COLOR_RED;
    XLViewRadius(self.confirmBtn, 22 * kWidthRatio6s);
    
    self.lab5 = [[UILabel alloc] init];
    [self.view addSubview:self.lab5];
    self.lab5.text = @"提示:官方回购审核将在1－3个工作日内完成!";
    [self.lab5 xl_setTextColor:XL_COLOR_DARKGRAY fontSize:12.f];
    
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
    
    [self.buybackLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab1);
        make.top.equalTo(self.lab1.mas_bottom).mas_offset(49 * kWidthRatio6s);
    }];
    
    [self.pdcoinTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buybackLab.mas_right).mas_offset(39 * kWidthRatio6s);
        make.width.mas_offset(180 * kWidthRatio6s);
        make.centerY.equalTo(self.buybackLab);
    }];
    
    [self.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buybackLab);
        make.right.equalTo(self.allBtn);
        make.width.mas_offset(48 * kWidthRatio6s);
    }];
    
    [self.separatorLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buybackLab.mas_bottom).mas_offset(18 * kWidthRatio6s);
        make.left.equalTo(self.view).mas_offset(15 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-15 * kWidthRatio6s);
        make.height.mas_offset(1 * kWidthRatio6s);
    }];
    
    [self.lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separatorLine1.mas_bottom).mas_offset(36 * kWidthRatio6s);
        make.left.equalTo(self.buybackLab);
    }];
    
    [self.lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab3);
        make.top.equalTo(self.lab3.mas_bottom).mas_offset(23 * kWidthRatio6s);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab4.mas_bottom).mas_offset(25 * kWidthRatio6s);
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.height.mas_offset(44 * kWidthRatio6s);
    }];
    
    [self.lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
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
        [HUDController hideHUDWithText:@"请输入回购数量"];
        return;
    }
    [[OutflowController sharedOutflowController] outflowTo];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.pdcoinTF endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!XLStringIsEmpty(_pdcoinTF.text)) {
        [self.confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else {
        [self.confirmBtn setTitleColor:RGB_COLOR_A(255, 255, 255, 0.35) forState:UIControlStateNormal];
    }
    return YES;
}


@end
