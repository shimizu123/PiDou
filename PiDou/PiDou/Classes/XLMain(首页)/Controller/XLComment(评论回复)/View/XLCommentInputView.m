//
//  XLCommentInputView.m
//  PiDou
//
//  Created by ice on 2019/5/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCommentInputView.h"
#import "NSMutableAttributedString+TGExtension.h"
#import "XLLimitTextField.h"

@interface XLCommentInputView () <UITextFieldDelegate>

@property (nonatomic, strong) XLLimitTextField *textField;

@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UIView *botView;

@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *photoButton;

@property (nonatomic, strong) UIButton *publishButton;

@end

@implementation XLCommentInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.textField = [[XLLimitTextField alloc] init];
    self.textField.textColor = COLOR(0x000000);
    self.textField.font = [UIFont xl_fontOfSize:14.f];
    self.textField.tintColor = XL_COLOR_BLACK;
    self.textField.backgroundColor = COLOR(0xf2f2f5);
    self.textField.attributedPlaceholder = [NSMutableAttributedString getPlaceholderWithString:@"说点什么…" color:COLOR(0xb6b6b8) font:[UIFont xl_fontOfSize:14.f]];
    self.textField.leftSpacing = @(12 * kWidthRatio6s);
    [self addSubview:self.textField];
    self.textField.delegate = self;
    
    self.lineV = [[UIView alloc] init];
    [self addSubview:self.lineV];
    self.lineV.backgroundColor = XL_COLOR_BG;
    
    self.botView = [[UIView alloc] init];
    [self addSubview:self.botView];
    
    self.videoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.botView addSubview:self.videoButton];
    [self.videoButton xl_setImageName:@"publish_video" target:self action:@selector(onVideoAction)];
    
    self.photoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.botView addSubview:self.photoButton];
    [self.photoButton xl_setImageName:@"publish_photo" target:self action:@selector(onPhotoAction)];
    
    self.publishButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.botView addSubview:self.publishButton];
    [self.publishButton xl_setTitle:@"发布" color:XL_COLOR_RED size:16.f target:self action:@selector(onPublish:)];
    
    [self initLayout];
}

- (void)initLayout {
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(16 * kWidthRatio6s);
        make.right.equalTo(self).mas_offset(-16 * kWidthRatio6s);
        make.top.equalTo(self).mas_offset(6 * kWidthRatio6s);
        make.height.mas_offset(32 * kWidthRatio6s);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.textField.mas_bottom).mas_offset(6 * kWidthRatio6s);
        make.height.mas_offset(1);
    }];
    
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.lineV.mas_bottom);
    }];
    
    [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.botView);
        make.width.mas_offset(46 * kWidthRatio6s);
    }];
    
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoButton.mas_right);
        make.top.bottom.width.equalTo(self.videoButton);
    }];
    
    [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.botView);
        make.width.mas_offset(64 * kWidthRatio6s);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    XLViewRadius(self.textField, self.textField.xl_h * 0.5);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

#pragma mark - 点击视频
- (void)onVideoAction {
    if (_delegate && [_delegate respondsToSelector:@selector(commentInputView:didSelectedWithIndex:)]) {
        [_delegate commentInputView:self didSelectedWithIndex:0];
    }
}

#pragma mark - 点击图片
- (void)onPhotoAction {
    if (_delegate && [_delegate respondsToSelector:@selector(commentInputView:didSelectedWithIndex:)]) {
        [_delegate commentInputView:self didSelectedWithIndex:1];
    }
}

- (void)onPublish:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(commentInputView:didSelectedWithIndex:)]) {
        [_delegate commentInputView:self didSelectedWithIndex:2];
    }
}


#pragma makk - public
- (void)becomeActive {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textField becomeFirstResponder];
    });
}

- (void)reset {
    self.textField.text = @"";
}

- (NSString *)text {
    return self.textField.text;
}

- (void)setViewSkin:(XLCommentInputViewSkin)viewSkin {
    _viewSkin = viewSkin;
    switch (_viewSkin) {
        case XLCommentInputViewSkin_white:
        {
            self.backgroundColor = [UIColor whiteColor];
        }
            break;
        case XLCommentInputViewSkin_black:
        {
            self.backgroundColor = [UIColor blackColor];
        }
            break;
            
        default:
            break;
    }
}

@end
