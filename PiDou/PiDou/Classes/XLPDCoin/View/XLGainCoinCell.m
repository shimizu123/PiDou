//
//  XLGainCoinCell.m
//  PiDou
//
//  Created by kevin on 23/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLGainCoinCell.h"

@interface XLGainCoinCell ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *botButton;

@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UIView *botLine;

@end

@implementation XLGainCoinCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.titleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleL];
    [self.titleL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    
    self.botButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.contentView addSubview:self.botButton];
    [self.botButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.botButton.titleLabel.font = [UIFont xl_fontOfSize:12.f];
    XLViewRadius(self.botButton, 14 * kWidthRatio6s);
    self.botButton.backgroundColor = XL_COLOR_RED;
    [self.botButton setContentEdgeInsets:(UIEdgeInsetsMake(0, 14 * kWidthRatio6s, 0, 14 * kWidthRatio6s))];
    
    self.titleL.text = @"邀请好友";
    [self.botButton setTitle:@"获取更多PDCoin" forState:(UIControlStateNormal)];
    self.botButton.enabled = NO;
    
    self.leftLine = [[UIView alloc] init];
    [self.contentView addSubview:self.leftLine];
    self.leftLine.backgroundColor = XL_COLOR_LINE;
    
    self.rightLine = [[UIView alloc] init];
    [self.contentView addSubview:self.rightLine];
    self.rightLine.backgroundColor = XL_COLOR_LINE;
    
    self.botLine = [[UIView alloc] init];
    [self.contentView addSubview:self.botLine];
    self.botLine.backgroundColor = XL_COLOR_LINE;
    
    [self initLayout];
}

- (void)initLayout {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.height.mas_offset(24 * kWidthRatio6s);
    }];
    
    [self.botButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
        make.height.mas_offset(28 * kWidthRatio6s);
        make.top.equalTo(self.titleL.mas_bottom).mas_offset(8 * kWidthRatio6s);
        make.centerX.equalTo(self.titleL);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_offset(0.5);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.contentView);
        make.width.mas_offset(0.5);
    }];
    
    [self.botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_offset(1);
    }];
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    self.titleL.text = _titleName;
}

- (void)setDesName:(NSString *)desName {
    _desName = desName;
    [self.botButton setTitle:_desName forState:(UIControlStateNormal)];
}

@end
