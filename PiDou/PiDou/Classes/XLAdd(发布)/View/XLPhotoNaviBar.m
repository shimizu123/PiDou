//
//  XLPhotoNaviBar.m
//  PiDou
//
//  Created by ice on 2019/4/21.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPhotoNaviBar.h"

@interface XLPhotoNaviBar ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation XLPhotoNaviBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.closeButton];
    [self.closeButton xl_setImageName:@"publish_close_white" target:self action:@selector(closeAction:)];
    
    self.nextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.nextButton];
    [self.nextButton xl_setTitle:@"下一步" color:[UIColor whiteColor] size:14.f target:self action:@selector(nextAction:)];
    self.nextButton.backgroundColor = XL_COLOR_RED;
    XLViewRadius(self.nextButton, 16 * kWidthRatio6s);
    
    
    [self initLayout];
}

- (void)initLayout {
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.height.mas_offset(44);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.closeButton);
        make.right.equalTo(self).mas_offset(-16 * kWidthRatio6s);
        make.width.mas_offset(74 * kWidthRatio6s);
        make.height.mas_offset(32 * kWidthRatio6s);
    }];
    
}

#pragma mark - 点击关闭
- (void)closeAction:(UIButton *)button {
    XLLog(@"点击关闭");
    if (_delegate && [_delegate respondsToSelector:@selector(didCloseWithPhotoNaviBar:)]) {
        [_delegate didCloseWithPhotoNaviBar:self];
    }
}

#pragma mark - 点击下一步
- (void)nextAction:(UIButton *)button {
    XLLog(@"点击下一步");
    if (_delegate && [_delegate respondsToSelector:@selector(didNextWithPhotoNaviBar:)]) {
        [_delegate didNextWithPhotoNaviBar:self];
    }
}

@end
