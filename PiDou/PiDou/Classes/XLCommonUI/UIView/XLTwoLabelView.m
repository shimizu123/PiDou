//
//  XLTwoLabelView.m
//  TG
//
//  Created by kevin on 27/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import "XLTwoLabelView.h"

@interface XLTwoLabelView ()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIView *kongV;


@end

@implementation XLTwoLabelView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.topLabel = [[UILabel alloc] init];
    [self.topLabel xl_setTextColor:XL_COLOR_BLACK fontSize:14];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.topLabel];
    
    self.bottomLabel = [[UILabel alloc] init];
    [self.bottomLabel xl_setTextColor:XL_COLOR_BLACK fontSize:14];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.bottomLabel];
    
    self.kongV = [[UIView alloc] init];
    self.kongV.backgroundColor = [UIColor clearColor];
    [self addSubview:self.kongV];
    
    [self initLayout];
}

- (void)initLayout {
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.kongV.mas_top);
        make.right.equalTo(self.mas_right);
    }];
    
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.kongV.mas_bottom);
    }];
    
    [self.kongV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_offset(1);
        make.height.mas_offset(1);
    }];
}

- (void)setTitleTop:(NSString *)titleTop {
    _titleTop = titleTop;
    self.topLabel.text = self.titleTop;
}

- (void)setTitleBot:(NSString *)titleBot {
    _titleBot = titleBot;
    self.bottomLabel.text = self.titleBot;
}

- (void)setTopFont:(UIFont *)topFont {
    _topFont = topFont;
    self.topLabel.font = _topFont;
}

- (void)setBotFont:(UIFont *)botFont {
    _botFont = botFont;
    self.bottomLabel.font = _botFont;
}



- (void)setTopColor:(UIColor *)topColor {
    _topColor = topColor;
    self.topLabel.textColor = _topColor;
}

- (void)setBotColor:(UIColor *)botColor {
    _botColor = botColor;
    self.bottomLabel.textColor = _botColor;
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    _interitemSpacing = interitemSpacing;
    
    [self.kongV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(_interitemSpacing);
    }];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.topLabel.font = _titleFont;
    self.bottomLabel.font = _titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.topLabel.textColor = _titleColor;
    self.bottomLabel.textColor = _titleColor;
}

- (void)setTwoLabelAlignment:(NSTextAlignment)twoLabelAlignment {
    _twoLabelAlignment = twoLabelAlignment;
    self.topLabel.textAlignment = _twoLabelAlignment;
    self.bottomLabel.textAlignment = _twoLabelAlignment;
}

@end
