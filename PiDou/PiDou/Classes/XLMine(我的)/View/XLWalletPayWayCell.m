//
//  XLWalletPayWayCell.m
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLWalletPayWayCell.h"

@interface XLWalletPayWayCell () 

// 微信
@property (nonatomic, strong) UIButton *wechatView;
@property (nonatomic, strong) UIImageView *wechatImgV;
@property (nonatomic, strong) UILabel *wechatLabel;
@property (nonatomic, strong) UIButton *wechatSelectButton;

@property (nonatomic, strong) UIView *hLine;

// 支付宝
@property (nonatomic, strong) UIButton *alipayView;
@property (nonatomic, strong) UIImageView *alipayImgV;
@property (nonatomic, strong) UILabel *alipayLabel;
@property (nonatomic, strong) UIButton *alipaySelectButton;

@end

@implementation XLWalletPayWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        self.selectType = 0;
    }
    return self;
}

- (void)setup {
    self.wechatView = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.contentView addSubview:self.wechatView];
    
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
    [self.contentView addSubview:self.alipayView];
    
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
    [self.alipaySelectButton setImage:[UIImage imageNamed:@"wallet_select"] forState:(UIControlStateSelected)];
    [self.alipaySelectButton setImage:[UIImage imageNamed:@"wallet_disable"] forState:(UIControlStateDisabled)];
    [self.alipaySelectButton setContentEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, XL_LEFT_DISTANCE))];
    [self.alipaySelectButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [self.alipaySelectButton addTarget:self action:@selector(alipaySelectAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.hLine = [[UIView alloc] init];
    [self.contentView addSubview:self.hLine];
    self.hLine.backgroundColor = XL_COLOR_LINE;
    
    
    [self initLayout];
    
    
}

- (void)initLayout {
    [self.wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).mas_offset(0);
        make.height.mas_offset(48 * kWidthRatio6s);
    }];
    
    [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.wechatView.mas_bottom);
        make.height.mas_offset(1);
    }];
    
    [self.alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.wechatView);
        make.top.equalTo(self.hLine.mas_bottom);
        make.bottom.equalTo(self.contentView);
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
        //make.right.equalTo(self.wechatView.mas_right).mas_offset(-16 * kWidthRatio6s);
        //make.width.height.mas_offset(20 * kWidthRatio6s);
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
