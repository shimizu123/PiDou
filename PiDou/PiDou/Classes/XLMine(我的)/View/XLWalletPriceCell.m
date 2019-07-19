//
//  XLWalletPriceCell.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLWalletPriceCell.h"
#import "XLWalletWithDrawController.h"
#import "XLWalletExchangeController.h"
#import "XLRechargeController.h"
#import "XLWalletInfoModel.h"
#import "XLGainPDCoinController.h"
#import "XLPDCoinHandle.h"

@interface XLWalletPriceCell () 

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *priceTitleL;
@property (nonatomic, strong) UILabel *priceL;

@property (nonatomic, strong) UIView *kongMidLine;
// 兑换
@property (nonatomic, strong) UIButton *exchangeButton;
// 提现
@property (nonatomic, strong) UIButton *withdrawButton;

@property (nonatomic, strong) UIView *coinView;
@property (nonatomic, strong) UILabel *coinTitleL;
@property (nonatomic, strong) UIButton *wenhao;
@property (nonatomic, strong) UILabel *coinNumL;
@property (nonatomic, strong) UIButton *communityButton;


@property (nonatomic, strong) UIView *xingView;
@property (nonatomic, strong) UILabel *xingTitleL;
@property (nonatomic, strong) UILabel *xingNumL;
@property (nonatomic, strong) UIButton *rechargeButton;

@property (nonatomic, strong) UIView *botKongView;

@end

@implementation XLWalletPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.topView = [[UIView alloc] init];
    [self.contentView addSubview:self.topView];
    self.topView.backgroundColor = XL_COLOR_RED;
    
    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.backButton];
    [self.backButton xl_setImageName:@"navi_arrow_white" target:self action:@selector(onBack)];
    
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont xl_mediumFontOfSiz:18.f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"我的钱包";
    
    self.priceTitleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.priceTitleL];
    [self.priceTitleL xl_setTextColor:COLOR_A(0xffffff, 0.6) fontSize:12.f];
    self.priceTitleL.text = @"我的余额(元)";
    self.priceTitleL.textAlignment = NSTextAlignmentCenter;
    
    self.priceL = [[UILabel alloc] init];
    [self.contentView addSubview:self.priceL];
    self.priceL.textColor = [UIColor whiteColor];
    self.priceL.font = [UIFont xl_mediumFontOfSiz:28.f];
    self.priceL.text = @"0";
    self.priceL.textAlignment = NSTextAlignmentCenter;
    
    
    
    self.exchangeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.contentView addSubview:self.exchangeButton];
    [self.exchangeButton xl_setTitle:@"兑换星票" color:[UIColor whiteColor] size:14.f];
    XLViewBorderRadius(self.exchangeButton, 14 * kWidthRatio6s, 1, [UIColor whiteColor].CGColor);
    [self.exchangeButton addTarget:self action:@selector(exchangeAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.withdrawButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
  //  self.withdrawButton.hidden = YES;
    [self.contentView addSubview:self.withdrawButton];
    [self.withdrawButton xl_setTitle:@"提现" color:[UIColor whiteColor] size:14.f];
    XLViewBorderRadius(self.withdrawButton, 14 * kWidthRatio6s, 1, [UIColor whiteColor].CGColor);
    [self.withdrawButton addTarget:self action:@selector(withdrawAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.kongMidLine = [[UIView alloc] init];
    [self.contentView addSubview:self.kongMidLine];
    self.kongMidLine.backgroundColor = XL_COLOR_LINE;
    
    
    self.coinView = [[UIView alloc] init];
    [self.contentView addSubview:self.coinView];
    
    self.coinTitleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.coinTitleL];
    [self.coinTitleL xl_setTextColor:XL_COLOR_BLACK fontSize:11.f];
    self.coinTitleL.textAlignment = NSTextAlignmentCenter;
    self.coinTitleL.text = @"参与社区回馈PDCoin";
    
    self.wenhao = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.wenhao];
    [self.wenhao xl_setImageName:@"wenhao" target:self action:@selector(notice)];
   // XLViewRadius(self.wenhao, 11 * kWidthRatio6s);
    
    self.coinNumL = [[UILabel alloc] init];
    [self.contentView addSubview:self.coinNumL];
    [self.coinNumL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:24.f];
    self.coinNumL.textAlignment = NSTextAlignmentCenter;
    self.coinNumL.text = @"0";
    
    self.communityButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.communityButton];
    [self.communityButton xl_setTitle:@"参与社区回馈" color:XL_COLOR_RED size:12.f];
    XLViewBorderRadius(self.communityButton, 14 * kWidthRatio6s, 1, XL_COLOR_RED.CGColor);
    [self.communityButton addTarget:self action:@selector(note) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.xingView = [[UIView alloc] init];
    [self.contentView addSubview:self.xingView];
    
    self.xingTitleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.xingTitleL];
    [self.xingTitleL xl_setTextColor:XL_COLOR_BLACK fontSize:11.f];
    self.xingTitleL.textAlignment = NSTextAlignmentCenter;
    self.xingTitleL.text = @"星票";
    
    self.xingNumL = [[UILabel alloc] init];
    [self.contentView addSubview:self.xingNumL];
    [self.xingNumL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:24.f];
    self.xingNumL.textAlignment = NSTextAlignmentCenter;
    self.xingNumL.text = @"0";
    
    self.rechargeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
   // self.rechargeButton.hidden = YES;
    [self.contentView addSubview:self.rechargeButton];
    [self.rechargeButton xl_setTitle:@"充值" color:XL_COLOR_RED size:12.f];
    XLViewBorderRadius(self.rechargeButton, 14 * kWidthRatio6s, 1, XL_COLOR_RED.CGColor);
    [self.rechargeButton addTarget:self action:@selector(rechargeAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.botKongView = [[UIView alloc] init];
    self.botKongView.backgroundColor = XL_COLOR_BG;
    [self.contentView addSubview:self.botKongView];
    
    [self initLayout];
}

- (void)initLayout {
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView);
        make.top.equalTo(self.topView).mas_offset(XL_STATUS_H);
        make.width.height.mas_offset(44);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.backButton);
        make.centerX.equalTo(self.topView);
    }];
    
    [self.priceTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topView);
        make.top.equalTo(self.backButton.mas_bottom).mas_offset(16 * kWidthRatio6s);
        make.height.mas_offset(18 * kWidthRatio6s);
    }];
    
    [self.priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.priceTitleL);
        make.top.equalTo(self.priceTitleL.mas_bottom).mas_offset(8 * kWidthRatio6s);
        make.height.mas_offset(28 * kWidthRatio6s);
    }];
    
    [self.coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView);
        make.top.equalTo(self.topView.mas_bottom);
        make.right.equalTo(self.kongMidLine.mas_left);
    }];
    
    [self.xingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView);
        make.top.bottom.width.equalTo(self.coinView);
        make.left.equalTo(self.kongMidLine.mas_right);
    }];
    
    [self.kongMidLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coinView);
        make.width.mas_offset(1);
        make.top.equalTo(self.coinView).mas_offset(15 * kWidthRatio6s);
        make.bottom.equalTo(self.coinView).mas_offset(-26 * kWidthRatio6s);
    }];
    
    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceL.mas_bottom).mas_offset(24 * kWidthRatio6s);
        make.right.equalTo(self.kongMidLine.mas_left).mas_offset(-16 * kWidthRatio6s);
      //  make.centerX.equalTo(self.contentView);
        make.height.mas_offset(28 * kWidthRatio6s);
        make.width.mas_offset(84 * kWidthRatio6s);
        make.bottom.equalTo(self.topView.mas_bottom).mas_offset(-32 * kWidthRatio6s);
    }];
    
    [self.withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.exchangeButton);
        make.left.equalTo(self.kongMidLine.mas_right).mas_offset(16 * kWidthRatio6s);
    }];
    
    // coinView里面
    [self.coinTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.coinView);
        make.top.equalTo(self.coinView).mas_offset(16 * kWidthRatio6s);
        make.height.mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.wenhao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinTitleL.mas_right).mas_offset(-50 * kWidthRatio6s);
        make.centerY.equalTo(self.coinTitleL);
        make.width.height.mas_offset(40);
    }];
    
    [self.coinNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.coinTitleL);
        make.top.equalTo(self.coinTitleL.mas_bottom).mas_offset(8 * kWidthRatio6s);
        make.height.mas_offset(24 * kWidthRatio6s);
    }];
    
    [self.communityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coinNumL.mas_bottom).mas_offset(12 * kWidthRatio6s);
        make.centerX.equalTo(self.coinView);
        make.bottom.equalTo(self.coinView).mas_offset(-16 * kWidthRatio6s);
        make.width.mas_offset(100 * kWidthRatio6s);
        make.height.mas_offset(28 * kWidthRatio6s);
    }];
    
    // xingView里面
    [self.xingTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.xingView);
        make.centerY.height.equalTo(self.coinTitleL);
    }];
    
    [self.xingNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.xingTitleL);
        make.centerY.height.equalTo(self.coinNumL);
    }];
    
    [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xingView);
        make.centerY.width.height.equalTo(self.communityButton);
    }];
    
    [self.botKongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_offset(12 * kWidthRatio6s);
        make.top.equalTo(self.coinView.mas_bottom);
    }];
}

- (void)notice {
    NSString *str = @"1.每日24点按当前所有用户参与回馈\nPDCoin结算当日回馈；\n2.次日依次下发前一日回馈奖励；\n3.当日获得的PDCoin，不参与前一日回馈奖励；";
    NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] initWithString:str];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:action];
    
    [msg addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, msg.length)];
    [msg addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, msg.length)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    [msg addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, msg.length)];
    [alertController setValue:msg forKey:@"attributedMessage"];
    
    
    UIView *subview = alertController.view.subviews.firstObject;
    UIView *alertContentView = subview.subviews.firstObject.subviews.lastObject.subviews.lastObject.subviews.lastObject;
    alertContentView.backgroundColor = [UIColor colorWithRed:232/255.0 green:107/255.0 blue:107/255.0 alpha:1.0];
    alertContentView.layer.cornerRadius = 12;
    alertController.view.tintColor = UIColor.whiteColor;
    [self.parentController presentViewController:alertController animated:YES completion:nil];
}

- (void)onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)note {
    [HUDController showTextOnly:@"此功能暂未开放"];
}

#pragma mark - 兑换
- (void)exchangeAction {
    XLWalletExchangeController *exchangeVC = [[XLWalletExchangeController alloc] init];
    exchangeVC.balance = self.walletInfo.balance;
    exchangeVC.rmb2coin = self.walletInfo.rmb2coin;
    [self.navigationController pushViewController:exchangeVC animated:YES];
}

#pragma mark - 提现
- (void)withdrawAction {
    XLWalletWithDrawController *withDrawVC = [[XLWalletWithDrawController alloc] init];
    withDrawVC.balance = self.walletInfo.balance;
    [self.navigationController pushViewController:withDrawVC animated:YES];
}

#pragma mark - 参与社区活动
- (void)communityAction {
//    XLGainPDCoinController *pdcoinVC = [[XLGainPDCoinController alloc] init];
//    [self.navigationController pushViewController:pdcoinVC animated:YES];
    
    [HUDController xl_showHUD];
    [XLPDCoinHandle joinProfitWithSuccess:^(id  _Nonnull responseObject) {
        [HUDController hideHUD];
        if (!self.communityButton.selected) {
            [self.communityButton setTitleColor:COLOR(0xcccccc) forState:(UIControlStateNormal)];
            XLViewBorderRadius(self.communityButton, 14 * kWidthRatio6s, 1, COLOR(0xcccccc).CGColor);
            self.communityButton.enabled = NO;
        } else {
            [self.communityButton setTitleColor:XL_COLOR_RED forState:(UIControlStateNormal)];
            XLViewBorderRadius(self.communityButton, 14 * kWidthRatio6s, 1, XL_COLOR_RED.CGColor);
            self.communityButton.enabled = YES;
        }
        self.communityButton.selected = !self.communityButton.selected;
        if (self.communityActionBlock) {
            self.communityActionBlock(@(self.communityButton.selected));
        }
    } failure:^(id  _Nonnull result) {
        [HUDController xl_hideHUDWithResult:result];
    }];
    
    
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    if ([_walletInfo.join_profit boolValue]) {
        return;
    }
    if (_index) {
        [self.communityButton setTitleColor:COLOR(0xcccccc) forState:(UIControlStateNormal)];
        XLViewBorderRadius(self.communityButton, 14 * kWidthRatio6s, 1, COLOR(0xcccccc).CGColor);
        self.communityButton.enabled = NO;
        self.communityButton.selected = YES;
    } else {
        [self.communityButton setTitleColor:XL_COLOR_RED forState:(UIControlStateNormal)];
        XLViewBorderRadius(self.communityButton, 14 * kWidthRatio6s, 1, XL_COLOR_RED.CGColor);
        self.communityButton.enabled = YES;
        self.communityButton.selected = NO;
    }
    //self.communityButton.selected = !self.communityButton.selected;
}

#pragma mark - 充值
- (void)rechargeAction {
    XLRechargeController *rechargeVC = [[XLRechargeController alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)setWalletInfo:(XLWalletInfoModel *)walletInfo {
    _walletInfo = walletInfo;
    self.priceL.text = [NSString stringWithFormat:@"%@",_walletInfo.balance];
    self.coinNumL.text = [NSString stringWithFormat:@"%.2f",[_walletInfo.pdcoin floatValue]];
    self.xingNumL.text = [NSString stringWithFormat:@"%@",_walletInfo.coin];
    if ([_walletInfo.join_profit boolValue]) {
        [self.communityButton setTitleColor:COLOR(0xcccccc) forState:(UIControlStateNormal)];
        XLViewBorderRadius(self.communityButton, 14 * kWidthRatio6s, 1, COLOR(0xcccccc).CGColor);
        self.communityButton.enabled = NO;
        self.communityButton.selected = YES;
    } else {
        [self.communityButton setTitleColor:XL_COLOR_RED forState:(UIControlStateNormal)];
        XLViewBorderRadius(self.communityButton, 14 * kWidthRatio6s, 1, XL_COLOR_RED.CGColor);
        self.communityButton.enabled = YES;
        self.communityButton.selected = NO;
    }
}

@end
