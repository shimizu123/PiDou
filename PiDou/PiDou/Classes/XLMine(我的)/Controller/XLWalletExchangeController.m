//
//  XLWalletExchangeController.m
//  PiDou
//
//  Created by kevin on 12/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLWalletExchangeController.h"
#import "CALayer+XLExtension.h"
#import "UIButton+XLAdd.h"
#import "XLWalletResultController.h"
#import "XLMineHandle.h"


#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s
@interface XLWalletExchangeController ()

// 提现金额
@property (nonatomic, strong) UILabel *priceTitleL;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UITextField *priceTF;
@property (nonatomic, strong) UIView *hLine;

@property (nonatomic, strong) UILabel *canDrawL;
@property (nonatomic, strong) UIButton *allDrawButton;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *remindButton;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation XLWalletExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"兑换星票";
    
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
    
    // 提现余额
    self.priceTitleL = [[UILabel alloc] init];
    [self.scrollView addSubview:self.priceTitleL];
    [self.priceTitleL xl_setTextColor:XL_COLOR_BLACK fontSize:14.f];
    self.priceTitleL.text = @"兑换金额";
    
    self.priceLabel = [[UILabel alloc] init];
    [self.scrollView addSubview:self.priceLabel];
    [self.priceLabel xl_setTextColor:XL_COLOR_DARKBLACK fontSize:44.f];
    self.priceLabel.text = @"¥";
    
    self.priceTF = [[UITextField alloc] init];
    [self.scrollView addSubview:self.priceTF];
    self.priceTF.textColor = XL_COLOR_DARKBLACK;
    self.priceTF.font = [UIFont xl_fontOfSize:44.f];
    self.priceTF.tintColor = XL_COLOR_DARKBLACK;
    self.priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.hLine = [[UIView alloc] init];
    [self.scrollView addSubview:self.hLine];
    self.hLine.backgroundColor = XL_COLOR_LINE;
    
    self.canDrawL = [[UILabel alloc] init];
    [self.scrollView addSubview:self.canDrawL];
    [self.canDrawL xl_setTextColor:XL_COLOR_DARKGRAY fontSize:14.f];
    self.canDrawL.text = [NSString stringWithFormat:@"可兑换金额：%@元",self.balance];
    
    self.allDrawButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.allDrawButton];
    [self.allDrawButton xl_setTitle:@"全部兑换" color:XL_COLOR_RED size:14.f target:self action:@selector(allDrawAction)];
    
    
    self.confirmButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.confirmButton];
    [self.confirmButton xl_setTitle:@"确认兑换" color:[UIColor whiteColor] size:18.f target:self action:@selector(withDrawAction:)];
    self.confirmButton.backgroundColor = XL_COLOR_RED;
    [self.confirmButton.layer setLayerShadow:XL_COLOR_RED offset:(CGSizeMake(0, 2)) radius:8 cornerRadius:LOGIN_BUTTON_HEIGHT * 0.5];
    
    self.remindButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.scrollView addSubview:self.remindButton];
    [self.remindButton xl_setTitle:[NSString stringWithFormat:@"100元可兑换%.0f星票",100 * self.rmb2coin.floatValue] color:XL_COLOR_DARKGRAY size:11.f];
    [self.remindButton setImage:[UIImage imageNamed:@"mine_remind"] forState:(UIControlStateNormal)];
    [self.remindButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [self.remindButton layoutButtonWithEdgeInsetsStyle:(XLButtonEdgeInsetsStyleLeft) imageTitleSpace:2 * kWidthRatio6s];
    
    
    [self initLayout];
}

- (void)initLayout {
    //
    [self.priceTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-16 * kWidthRatio6s);
        make.top.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceTitleL);
        make.top.equalTo(self.priceTitleL.mas_bottom);
        make.height.mas_offset(76 * kWidthRatio6s);
        make.width.mas_offset(27 * kWidthRatio6s);
    }];
    
    [self.priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).mas_offset(5 * kWidthRatio6s);
        make.top.bottom.equalTo(self.priceLabel);
        make.right.equalTo(self.view).mas_offset(-XL_LEFT_DISTANCE);
    }];
    
    [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.right.equalTo(self.view);
        make.top.equalTo(self.priceLabel.mas_bottom);
        make.height.mas_offset(1);
    }];
    
    [self.canDrawL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceTitleL);
        make.top.equalTo(self.hLine.mas_bottom);
        make.height.mas_offset(44 * kWidthRatio6s);
    }];
    
    [self.allDrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.centerY.height.equalTo(self.canDrawL);
        make.width.mas_offset(88 * kWidthRatio6s);
    }];
    
    
    
    
    [self.remindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.priceTitleL);
        make.top.equalTo(self.allDrawButton.mas_bottom);
        make.height.mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.top.equalTo(self.remindButton.mas_bottom).mas_offset(32 * kWidthRatio6s);
        make.height.mas_offset(LOGIN_BUTTON_HEIGHT);
    }];
    
}

#pragma mark - 全部兑换
- (void)allDrawAction {
    self.priceTF.text = [NSString stringWithFormat:@"%@",_balance];
}

#pragma mark - 确认兑换
- (void)withDrawAction:(UIButton *)button {
    double price = [self.priceTF.text doubleValue];
    if (price > 0) {
        [HUDController xl_showHUD];
        [XLMineHandle exchangeXingCoinWithAmount:price success:^(id  _Nonnull responseObject) {
            [HUDController hideHUD];
            XLWalletResultController *resultVC = [[XLWalletResultController alloc] init];
            resultVC.resultType = XLWalletResultType_buy;
            [self.navigationController pushViewController:resultVC animated:YES];
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
        
    } else {
        [HUDController hideHUDWithText:@"输入不得为0"];
    }
    
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}



@end
