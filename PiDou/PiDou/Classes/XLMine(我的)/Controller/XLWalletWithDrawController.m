//
//  XLWalletWithDrawController.m
//  PiDou
//
//  Created by kevin on 12/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLWalletWithDrawController.h"
#import "CALayer+XLExtension.h"
#import "UIButton+XLAdd.h"
#import "XLMineHandle.h"
#import "XLWalletResultController.h"

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

@interface XLWalletWithDrawController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *addrTitleL;
// 微信
@property (nonatomic, strong) UIButton *wechatView;
@property (nonatomic, strong) UIImageView *wechatImgV;
@property (nonatomic, strong) UILabel *wechatLabel;
@property (nonatomic, strong) UIButton *wechatSelectButton;
// 支付宝
@property (nonatomic, strong) UIButton *alipayView;
@property (nonatomic, strong) UIImageView *alipayImgV;
@property (nonatomic, strong) UILabel *alipayLabel;
@property (nonatomic, strong) UIButton *alipaySelectButton;

// 提现金额
@property (nonatomic, strong) UILabel *priceTitleL;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UITextField *priceTF;
@property (nonatomic, strong) UIView *hLine;

@property (nonatomic, strong) UILabel *canDrawL;
@property (nonatomic, strong) UIButton *allDrawButton;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *remindButton;


@end

@implementation XLWalletWithDrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"提现";

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
    
    self.addrTitleL = [[UILabel alloc] init];
    [self.scrollView addSubview:self.addrTitleL];
    [self.addrTitleL xl_setTextColor:XL_COLOR_BLACK fontSize:14.f];
    self.addrTitleL.text = @"提现到";
    
    self.wechatView = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.wechatView];
    
    self.wechatImgV = [[UIImageView alloc] init];
    [self.wechatView addSubview:self.wechatImgV];
    self.wechatImgV.image = [UIImage imageNamed:@"wallet_wechat"];
    
    self.wechatLabel = [[UILabel alloc] init];
    [self.wechatView addSubview:self.wechatLabel];
    [self.wechatLabel xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    self.wechatLabel.text = @"微信";
    
    self.wechatSelectButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.wechatView addSubview:self.wechatSelectButton];
    [self.wechatSelectButton setImage:[UIImage imageNamed:@"wallet_unselect"] forState:(UIControlStateNormal)];
    [self.wechatSelectButton setImage:[UIImage imageNamed:@"wallet_select"] forState:(UIControlStateSelected)];
    [self.wechatSelectButton setImage:[UIImage imageNamed:@"wallet_disable"] forState:(UIControlStateDisabled)];
    [self.wechatSelectButton addTarget:self action:@selector(wechatSelectAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.wechatSelectButton setContentEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, XL_LEFT_DISTANCE))];
    [self.wechatSelectButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    self.wechatSelectButton.selected = YES;
    self.selectType = 1;
    
    
    
    self.alipayView = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.alipayView];
    
    self.alipayImgV = [[UIImageView alloc] init];
    [self.alipayView addSubview:self.alipayImgV];
    self.alipayImgV.image = [UIImage imageNamed:@"wallet_alipay"];
    
    self.alipayLabel = [[UILabel alloc] init];
    [self.alipayView addSubview:self.alipayLabel];
    [self.alipayLabel xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    self.alipayLabel.text = @"支付宝";
    
    self.alipaySelectButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.alipayView addSubview:self.alipaySelectButton];
    self.alipaySelectButton.enabled = NO;
    [self.alipaySelectButton setImage:[UIImage imageNamed:@"wallet_unselect"] forState:(UIControlStateNormal)];
    [self.alipaySelectButton setImage:[UIImage imageNamed:@"wallet_unselect"] forState:(UIControlStateSelected)];
    [self.alipaySelectButton setImage:[UIImage imageNamed:@"wallet_disable"] forState:(UIControlStateDisabled)];
    [self.alipaySelectButton setImage:[UIImage imageNamed:@"wallet_unselect"] forState:(UIControlStateNormal)];
    [self.alipaySelectButton setImage:[UIImage imageNamed:@"wallet_select"] forState:(UIControlStateSelected)];
    [self.alipaySelectButton setImage:[UIImage imageNamed:@"wallet_disable"] forState:(UIControlStateDisabled)];
    [self.alipaySelectButton setContentEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, XL_LEFT_DISTANCE))];
    [self.alipaySelectButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [self.alipaySelectButton addTarget:self action:@selector(alipaySelectAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 提现余额
    self.priceTitleL = [[UILabel alloc] init];
    [self.scrollView addSubview:self.priceTitleL];
    [self.priceTitleL xl_setTextColor:XL_COLOR_BLACK fontSize:14.f];
    self.priceTitleL.text = @"提现金额";
    
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
    self.canDrawL.text = [NSString stringWithFormat:@"可提现余额：%@元",self.balance];
    
    self.allDrawButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.allDrawButton];
    [self.allDrawButton xl_setTitle:@"全部提现" color:XL_COLOR_RED size:14.f target:self action:@selector(allDrawAction)];
    
    
    self.confirmButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.scrollView addSubview:self.confirmButton];
    [self.confirmButton xl_setTitle:@"确认提现" color:[UIColor whiteColor] size:18.f target:self action:@selector(withDrawAction:)];
    self.confirmButton.backgroundColor = XL_COLOR_RED;
    [self.confirmButton.layer setLayerShadow:XL_COLOR_RED offset:(CGSizeMake(0, 2)) radius:8 cornerRadius:LOGIN_BUTTON_HEIGHT * 0.5];
    
    self.remindButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.scrollView addSubview:self.remindButton];
    [self.remindButton xl_setTitle:@"提现将在3个工作日内完成，微信单笔提现最低1元，上限2万元" color:XL_COLOR_DARKGRAY size:11.f];
    [self.remindButton setImage:[UIImage imageNamed:@"mine_remind"] forState:(UIControlStateNormal)];
    [self.remindButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
    [self.remindButton layoutButtonWithEdgeInsetsStyle:(XLButtonEdgeInsetsStyleLeft) imageTitleSpace:2 * kWidthRatio6s];
    
    [self initLayout];
}

- (void)initLayout {
    [self.addrTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-16 * kWidthRatio6s);
        make.top.equalTo(self.view).mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.addrTitleL.mas_bottom).mas_offset(8 * kWidthRatio6s);
        make.height.mas_offset(48 * kWidthRatio6s);
    }];
    
    [self.alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.wechatView);
        make.top.equalTo(self.wechatView.mas_bottom);
    }];
    
    [self.wechatImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wechatView);
        make.left.equalTo(self.wechatView).mas_offset(16 * kWidthRatio6s);
        make.width.height.mas_offset(32 * kWidthRatio6s);
    }];
    
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wechatImgV);
        make.left.equalTo(self.wechatImgV.mas_right).mas_offset(8 * kWidthRatio6s);
    }];
    
    [self.wechatSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.wechatImgV);
//        make.right.equalTo(self.wechatView.mas_right).mas_offset(-16 * kWidthRatio6s);
//        make.width.height.mas_offset(20 * kWidthRatio6s);
        make.left.right.top.bottom.equalTo(self.wechatView);
    }];
    
    [self.alipayImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.alipayView);
        make.left.equalTo(self.alipayView).mas_offset(16 * kWidthRatio6s);
        make.width.height.mas_offset(32 * kWidthRatio6s);
    }];
    
    [self.alipayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.alipayImgV);
        make.left.equalTo(self.alipayImgV.mas_right).mas_offset(8 * kWidthRatio6s);
    }];
    
    [self.alipaySelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.alipayImgV);
//        make.right.equalTo(self.alipayView.mas_right).mas_offset(-16 * kWidthRatio6s);
//        make.width.height.mas_offset(20 * kWidthRatio6s);
        make.left.right.top.bottom.equalTo(self.alipayView);
    }];
    
    // 
    [self.priceTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.addrTitleL);
        make.top.equalTo(self.alipayView.mas_bottom).mas_offset(32 * kWidthRatio6s);
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
    

    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.top.equalTo(self.allDrawButton.mas_bottom).mas_offset(32 * kWidthRatio6s);
        make.height.mas_offset(LOGIN_BUTTON_HEIGHT);
    }];
    
    [self.remindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.addrTitleL);
        make.top.equalTo(self.confirmButton.mas_bottom).mas_offset(12 * kWidthRatio6s);
        make.height.mas_offset(16 * kWidthRatio6s);
    }];
}


#pragma mark - 全部提现
- (void)allDrawAction {
    self.priceTF.text = [NSString stringWithFormat:@"%@",self.balance];
}

#pragma mark - 确认提现
- (void)withDrawAction:(UIButton *)button {
    [self.view endEditing:YES];
    if (!self.selectType) {
        [HUDController hideHUDWithText:@"请选择提现方式"];
        return;
    }
    float price = [self.priceTF.text floatValue];
    
    if (price > [self.balance floatValue]) {
        [HUDController hideHUDWithText:@"可提现余额不足"];
        return;
    }
    
    if (price >= 1) {
        [HUDController xl_showHUD];
        [XLMineHandle walletTransferWithAmount:self.priceTF.text to:(int)self.selectType Success:^(id  _Nonnull responseObject) {
            [HUDController hideHUDWithText:responseObject];
            XLWalletResultController *resultVC = [[XLWalletResultController alloc] init];
            resultVC.resultType = XLWalletResultType_commit;
            [self.navigationController pushViewController:resultVC animated:YES];
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    } else {
        [HUDController hideHUDWithText:@"提现金额最低为1元"];
    }
}

- (void)hideKeyBoard {
    [self.view endEditing:YES];
}


#pragma mark - 点击微信
- (void)wechatSelectAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.selectType = 1;
    } else {
        self.selectType = 0;
    }
}

#pragma mark - 点击支付宝
- (void)alipaySelectAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.selectType = 2;
    } else {
        self.selectType = 0;
    }
}

@end
