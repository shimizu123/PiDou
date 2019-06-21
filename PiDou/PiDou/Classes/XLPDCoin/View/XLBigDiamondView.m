//
//  XLBigDiamondView.m
//  PiDou
//
//  Created by ice on 2019/4/27.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBigDiamondView.h"

@interface XLBigDiamondView ()

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIImageView *diamondImgV;
@property (nonatomic, strong) UILabel *titleL;

@end

@implementation XLBigDiamondView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.bgButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.bgButton];
    [self.bgButton setImage:[UIImage imageNamed:@"coin_paopao_big"] forState:(UIControlStateNormal)];
    [self.bgButton addTarget:self action:@selector(onGetPDCoinAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.diamondImgV = [[UIImageView alloc] init];
    [self addSubview:self.diamondImgV];
    self.diamondImgV.image = [UIImage imageNamed:@"coin_diamond"];
    
    self.titleL = [[UILabel alloc] init];
    [self addSubview:self.titleL];
    [self.titleL xl_setTextColor:[UIColor whiteColor] fontSize:14.f];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.text = @"点击领取";
    
    [self initLayout];
}

- (void)initLayout {
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.diamondImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).mas_offset(10 * kWidthRatio6s);
        make.width.mas_offset(45 * kWidthRatio6s);
        make.height.mas_offset(41 * kWidthRatio6s);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.diamondImgV.mas_bottom).mas_offset(2 * kWidthRatio6s);
        make.height.mas_offset(20 * kWidthRatio6s);
        make.bottom.equalTo(self).mas_offset(-16 * kWidthRatio6s);
    }];
}

- (void)onGetPDCoinAction {
    if (self.didSelect) {
        self.didSelect();
    }
}

@end
