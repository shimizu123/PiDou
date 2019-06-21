//
//  XLPublishInputView.m
//  PiDou
//
//  Created by ice on 2019/4/14.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPublishInputView.h"


@interface XLPublishInputView ()

@property (nonatomic, strong) UIView *hLine;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *linkButton;

@end

@implementation XLPublishInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.hLine = [[UIView alloc] init];
    [self addSubview:self.hLine];
    self.hLine.backgroundColor = XL_COLOR_LINE;
    
    self.videoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.videoButton];
    [self.videoButton xl_setImageName:@"publish_video" target:self action:@selector(onVideoAction)];
    
    self.photoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.photoButton];
    [self.photoButton xl_setImageName:@"publish_photo" target:self action:@selector(onPhotoAction)];
    
    self.linkButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.linkButton];
    [self.linkButton xl_setImageName:@"publish_link" target:self action:@selector(onLinkAction)];
    self.linkButton.hidden = YES;
    
    [self initLayout];
}

- (void)initLayout {
    
    [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_offset(1);
    }];
    
    [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_offset(64 * kWidthRatio6s);
    }];
    
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoButton.mas_right);
        make.top.bottom.width.equalTo(self.videoButton);
    }];
    
    [self.linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoButton.mas_right);
        make.width.top.bottom.equalTo(self.videoButton);
    }];
}

#pragma mark - 点击视频
- (void)onVideoAction {
    if (_delegate && [_delegate respondsToSelector:@selector(publishInputView:didSelectedWithIndex:)]) {
        [_delegate publishInputView:self didSelectedWithIndex:0];
    }
}

#pragma mark - 点击图片
- (void)onPhotoAction {
    if (_delegate && [_delegate respondsToSelector:@selector(publishInputView:didSelectedWithIndex:)]) {
        [_delegate publishInputView:self didSelectedWithIndex:1];
    }
}

#pragma mark - 点击链接
- (void)onLinkAction {
    if (_delegate && [_delegate respondsToSelector:@selector(publishInputView:didSelectedWithIndex:)]) {
        [_delegate publishInputView:self didSelectedWithIndex:2];
    }
}

@end
