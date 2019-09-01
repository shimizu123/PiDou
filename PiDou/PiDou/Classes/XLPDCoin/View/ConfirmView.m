//
//  ConfirmView.m
//  PiDou
//
//  Created by 邓康大 on 2019/8/30.
//  Copyright © 2019 ice. All rights reserved.
//

#import "ConfirmView.h"
#import "OutflowController.h"

@interface ConfirmView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation ConfirmView
singleton_m(ConfirmView)

+ (instancetype)confirmView {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = COLOR_A(0x000000, 0.4);
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300 * kWidthRatio6s) / 2, (SCREEN_HEIGHT - 111 * kWidthRatio6s) / 2, 300 * kWidthRatio6s, 111 * kWidthRatio6s)];
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = UIColor.whiteColor;
    XLViewRadius(self.contentView, 5 * kWidthRatio6s);
    
    self.label = [[UILabel alloc] init];
    [self.contentView addSubview:self.label];
    [self.label xl_setTextColor:XL_COLOR_DARKBLACK fontSize:12.f];
    self.label.textAlignment = NSTextAlignmentLeft;
    
    self.confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.confirmBtn];
    [self.confirmBtn xl_setTitle:@"确认" color:UIColor.whiteColor size:15.f];
    self.confirmBtn.backgroundColor = XL_COLOR_RED;
    [self.confirmBtn addTarget:self action:@selector(confirmOut) forControlEvents:UIControlEventTouchUpInside];
    XLViewRadius(self.confirmBtn, 18 * kWidthRatio6s);
    
    [self initLayout];
}

- (void)initLayout {
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(20 * kWidthRatio6s);
        make.left.equalTo(self.contentView).mas_offset(15 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-10 * kWidthRatio6s);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(27 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-27 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView).mas_offset(-20 * kWidthRatio6s);
        make.height.mas_offset(35 * kWidthRatio6s);
    }];
    
}

- (void)confirmOut {
    [self dismiss];
    [[OutflowController sharedOutflowController] outflowTo];
}


- (void)setTypeArray:(NSArray *)typeArray {
    _typeArray = typeArray;
    self.label.text = [NSString stringWithFormat:@"您将转入的%@账户手机号码为：%@", _typeArray[0], _typeArray[1]];
}

- (void)show {
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

@end
