//
//  XLCommentBotView.m
//  PiDou
//
//  Created by ice on 2019/4/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCommentBotView.h"
#import "XLCornerMarkButton.h"
#import "XLTieziModel.h"
#import "XLLaunchManager.h"


@interface XLCommentBotView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *kongView;
@property (nonatomic, strong) XLCornerMarkButton *zanNumButton;
@property (nonatomic, strong) XLCornerMarkButton *commentNumButton;
@property (nonatomic, strong) XLCornerMarkButton *collectNumButton;
@property (nonatomic, strong) XLCornerMarkButton *diamondNumButton;

@property (nonatomic, strong) UIButton *commentButton;



@end

@implementation XLCommentBotView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.backgroundColor = [UIColor whiteColor];
    self.kongView = [[UIView alloc] init];
    [self addSubview:self.kongView];
    
    self.commentButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.commentButton];
    [self.commentButton xl_setTitle:@"说点什么…" color:COLOR(0xB6B6B8) size:14.f target:self action:@selector(comment:)];
    self.commentButton.backgroundColor = XL_COLOR_LINE;
    [self.commentButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [self.commentButton setContentEdgeInsets:(UIEdgeInsetsMake(0, XL_LEFT_DISTANCE, 0, 0))];
    XLViewRadius(self.commentButton, 16);
    
    self.zanNumButton = [XLCornerMarkButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.zanNumButton];
    [self.zanNumButton xl_setImageName:@"main_zan" selectImage:@"main_zan_select" target:self action:@selector(zanNumAction:)];
    [self.zanNumButton setTitle:@"0" forState:(UIControlStateNormal)];
    
    self.commentNumButton = [XLCornerMarkButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.commentNumButton];
    [self.commentNumButton xl_setImageName:@"main_comment" target:self action:@selector(commentNumAction:)];
    [self.commentNumButton setTitle:@"0" forState:(UIControlStateNormal)];
    
    self.collectNumButton = [XLCornerMarkButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.collectNumButton];
    [self.collectNumButton xl_setImageName:@"main_collect" selectImage:@"main_collect_select" target:self action:@selector(collectNumAction:)];
    [self.collectNumButton setTitle:@"0" forState:(UIControlStateNormal)];
    
    self.diamondNumButton = [XLCornerMarkButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.diamondNumButton];
    [self.diamondNumButton xl_setImageName:@"user_diamond" target:self action:@selector(diamondNumAction:)];
    [self.diamondNumButton setTitle:@"0" forState:(UIControlStateNormal)];
    [self.diamondNumButton setTitleColor:XL_COLOR_RED forState:(UIControlStateNormal)];
    
    
    
    [self initLayout];
}

- (void)initLayout {
    
    [self.kongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self).mas_offset(-XL_HOME_INDICATOR_H);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.kongView);
        make.left.equalTo(self.kongView).mas_offset(16 * kWidthRatio6s);
        //make.width.mas_offset(103 * kWidthRatio6s);
        make.height.mas_offset(32);
    }];
    
    [self.zanNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentButton.mas_right).mas_offset(16 * kWidthRatio6s);
        make.top.bottom.equalTo(self.kongView);
        make.width.mas_offset(60 * kWidthRatio6s);
    }];
    
    [self.commentNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.zanNumButton);
        make.left.equalTo(self.zanNumButton.mas_right);
    }];
    
    [self.collectNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.zanNumButton);
        make.left.equalTo(self.commentNumButton.mas_right);
    }];
    
    [self.diamondNumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.collectNumButton);
        make.left.equalTo(self.collectNumButton.mas_right);
        make.right.equalTo(self.kongView);
    }];
    
    
}




- (void)comment:(UIButton *)button {
    XLLog(@"点击评论");
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(commentBotView:didSelectedWithIndex:)]) {
        [_delegate commentBotView:self didSelectedWithIndex:0];
    }
}

- (void)zanNumAction:(UIButton *)button {
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(commentBotView:didSelectedWithIndex:)]) {
        [_delegate commentBotView:self didSelectedWithIndex:1];
    }
}

- (void)commentNumAction:(UIButton *)button {
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(commentBotView:didSelectedWithIndex:)]) {
        [_delegate commentBotView:self didSelectedWithIndex:2];
    }
}

- (void)collectNumAction:(UIButton *)button {
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(commentBotView:didSelectedWithIndex:)]) {
        [_delegate commentBotView:self didSelectedWithIndex:3];
    }
}

- (void)diamondNumAction:(UIButton *)button {
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(commentBotView:didSelectedWithIndex:)]) {
        [_delegate commentBotView:self didSelectedWithIndex:4];
    }
}

#pragma mark - public
- (void)setCommentBotViewType:(XLCommentBotViewType)commentBotViewType {
    _commentBotViewType = commentBotViewType;
    switch (_commentBotViewType) {
        case XLCommentBotViewType_white:
        {
            self.backgroundColor = [UIColor whiteColor];
            [self.zanNumButton setTitleColor:XL_COLOR_BLACK forState:(UIControlStateNormal)];
            [self.commentNumButton setTitleColor:XL_COLOR_BLACK forState:(UIControlStateNormal)];
            [self.collectNumButton setTitleColor:XL_COLOR_BLACK forState:(UIControlStateNormal)];
            [self.diamondNumButton setTitleColor:XL_COLOR_BLACK forState:(UIControlStateNormal)];
            self.commentButton.backgroundColor = [UIColor whiteColor];
        }
            break;
        case XLCommentBotViewType_black:
        {
            self.backgroundColor = [UIColor blackColor];
            [self.zanNumButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [self.commentNumButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [self.collectNumButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [self.diamondNumButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            self.commentButton.backgroundColor = COLOR_A(0x666666, 0.1);
        }
            break;
            
        default:
            break;
    }
}

- (void)setTieziModel:(XLTieziModel *)tieziModel {
    _tieziModel = tieziModel;
    [self.zanNumButton setTitle:_tieziModel.do_like_count forState:(UIControlStateNormal)];
    [self.commentNumButton setTitle:_tieziModel.comment_count forState:(UIControlStateNormal)];
    [self.collectNumButton setTitle:_tieziModel.collect_count forState:(UIControlStateNormal)];
    [self.diamondNumButton setTitle:_tieziModel.pdcoin_count forState:(UIControlStateNormal)];
    
    self.zanNumButton.selected = [_tieziModel.do_liked boolValue];
    self.collectNumButton.selected = [_tieziModel.collected boolValue];
}

- (void)setIsCommentDetail:(BOOL)isCommentDetail {
    _isCommentDetail = isCommentDetail;
    if (!_isCommentDetail) {
        [self.collectNumButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(self.zanNumButton);
            make.left.equalTo(self.commentNumButton.mas_right);
        }];
    
    } else {
        [self.collectNumButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.zanNumButton);
            make.left.equalTo(self.commentNumButton.mas_right);
            make.width.mas_offset(CGFLOAT_MIN);
        }];

    }
}

@end
