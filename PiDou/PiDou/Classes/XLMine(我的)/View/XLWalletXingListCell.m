//
//  XLWalletXingListCell.m
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLWalletXingListCell.h"

@interface XLWalletXingListCell ()

@property (nonatomic, strong) UILabel *xingNumL;
@property (nonatomic, strong) UIButton *priceButton;

@property (nonatomic, strong) UIView *hLine;

@end

@implementation XLWalletXingListCell

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
    self.xingNumL = [[UILabel alloc] init];
    [self.contentView addSubview:self.xingNumL];
    [self.xingNumL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    
    
    self.priceButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.contentView addSubview:self.priceButton];
    self.priceButton.backgroundColor = XL_COLOR_RED;
    [self.priceButton xl_setTitle:@"¥ 100" color:[UIColor whiteColor] size:14.f target:self action:@selector(buyAction:)];
    XLViewRadius(self.priceButton, 14 * kWidthRatio6s);
    self.priceButton.userInteractionEnabled = NO;
    
    self.hLine = [[UIView alloc] init];
    [self.contentView addSubview:self.hLine];
    self.hLine.backgroundColor = XL_COLOR_LINE;
    
    [self initLayout];
}

- (void)initLayout {
    [self.xingNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.height.mas_offset(48 * kWidthRatio6s);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.priceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xingNumL);
        make.right.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
        make.width.mas_offset(100 * kWidthRatio6s);
        make.height.mas_offset(28 * kWidthRatio6s);
    }];
    
    [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.xingNumL);
        make.bottom.right.equalTo(self.contentView);
        make.height.mas_offset(1);
    }];
}

- (void)buyAction:(UIButton *)button {
    
}

- (void)setXingCoinModel:(XLWalletInfoModel *)xingCoinModel {
    _xingCoinModel = xingCoinModel;
    self.xingNumL.text = [NSString stringWithFormat:@"%@星票",_xingCoinModel.coin];
    [self.priceButton setTitle:[NSString stringWithFormat:@"¥ %@",_xingCoinModel.balance] forState:(UIControlStateNormal)];
}



@end
