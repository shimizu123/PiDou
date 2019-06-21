//
//  XLPublishLinkView.m
//  PiDou
//
//  Created by ice on 2019/4/14.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPublishLinkView.h"

@interface XLPublishLinkView () 

@property (nonatomic, strong) UIView *oriView;
@property (nonatomic, strong) UILabel *oriDescL;
@property (nonatomic, strong) UIImageView *oriImgV;
@property (nonatomic, strong) UIImageView *playImgV;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation XLPublishLinkView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.oriView = [[UIView alloc] init];
    [self addSubview:self.oriView];
    self.oriView.backgroundColor = COLOR(0xf8f8fa);
    XLViewRadius(self.oriView, 4 * kWidthRatio6s);
    
    self.oriDescL = [[UILabel alloc] init];
    [self.oriView addSubview:self.oriDescL];
    [self.oriDescL xl_setTextColor:XL_COLOR_BLACK fontSize:14.f];
    self.oriDescL.numberOfLines = 0;
    
    self.oriImgV = [[UIImageView alloc] init];
    [self.oriView addSubview:self.oriImgV];
    self.oriImgV.backgroundColor = XLRandomColor;
    
    self.playImgV = [[UIImageView alloc] init];
    [self.oriImgV addSubview:self.playImgV];
    self.playImgV.image = [UIImage imageNamed:@"video_play_2"];
    
    self.closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.closeButton];
    [self.closeButton xl_setImageName:@"publish_close_small" target:self action:@selector(closeAction)];
    
    [self initLayout];
}

- (void)initLayout {
    
    [self.oriView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self).mas_offset(-16 * kWidthRatio6s);
        make.top.equalTo(self).mas_offset(16 * kWidthRatio6s);
        make.height.mas_equalTo(64 * kWidthRatio6s);
    }];
    
    
    [self.oriDescL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.oriView);
        make.left.equalTo(self.oriView).mas_equalTo(12 * kWidthRatio6s);
    }];
    
    [self.oriImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.oriView);
        make.left.equalTo(self.oriDescL.mas_right);
        make.width.equalTo(self.oriImgV.mas_height);
    }];
    
    [self.playImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.oriImgV);
        make.width.height.mas_equalTo(24 * kWidthRatio6s);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.oriView);
        make.width.height.mas_offset(24 * kWidthRatio6s);
    }];
}

- (void)closeAction {
    
}

@end
