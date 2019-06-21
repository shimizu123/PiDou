//
//  XLPDCoinNaviBar.m
//  PiDou
//
//  Created by ice on 2019/4/22.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPDCoinNaviBar.h"

@interface XLPDCoinNaviBar ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation XLPDCoinNaviBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.backButton];
    [self.backButton xl_setImageName:@"navi_arrow_white" target:self action:@selector(onBack)];
    
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont xl_mediumFontOfSiz:18.f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"PDCoin";
    
    self.rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.rightButton];
    [self.rightButton xl_setTitle:@"明细" color:[UIColor whiteColor] size:16.f target:self action:@selector(rightAction:)];
    
    [self initLayout];
}

- (void)initLayout {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.width.height.mas_offset(44);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.backButton);
        make.centerX.equalTo(self);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.height.mas_offset(44);
        make.width.mas_offset(64 * kWidthRatio6s);
    }];
}

- (void)onBack {
    if (_delegate && [_delegate respondsToSelector:@selector(onClose:)]) {
        [_delegate onClose:self];
    }
}

- (void)rightAction:(UIButton *)buttom {
    if (_delegate && [_delegate respondsToSelector:@selector(onDetail:)]) {
        [_delegate onDetail:self];
    }
}

@end
