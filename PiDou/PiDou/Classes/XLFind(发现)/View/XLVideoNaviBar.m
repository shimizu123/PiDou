//
//  XLVideoNaviBar.m
//  PiDou
//
//  Created by kevin on 14/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLVideoNaviBar.h"
#import "XLUserIcon.h"
#import "XLShareView.h"
#import "XLTieziModel.h"
#import "XLFansFocusHandle.h"

@interface XLVideoNaviBar ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) XLUserIcon *userIcon;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *desL;
@property (nonatomic, strong) UIImageView *shenImgV;

@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation XLVideoNaviBar

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
    [self.backButton xl_setImageName:@"navi_arrow_white" selectImage:@"navi_arrow_black" target:self action:@selector(onBack)];
    
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont xl_mediumFontOfSiz:18.f];
    self.titleLabel.textColor = [UIColor whiteColor];
    
    
    self.userIcon = [[XLUserIcon alloc] init];
    [self addSubview:self.userIcon];
    
    self.nameL = [[UILabel alloc] init];
    [self addSubview:self.nameL];
    [self.nameL xl_setTextColor:[UIColor whiteColor] fontSize:12.f];
    
    
    self.shenImgV = [[UIImageView alloc] init];
    [self addSubview:self.shenImgV];
    self.shenImgV.image = [UIImage imageNamed:@"user_shen"];
    
    self.desL = [[UILabel alloc] init];
    [self addSubview:self.desL];
    [self.desL xl_setTextColor:[UIColor whiteColor] fontSize:10.f];

    self.focusButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.focusButton];
    [self.focusButton xl_setTitle:@"关注" color:[UIColor whiteColor] size:14.f target:self action:@selector(focusAction:)];
    [self.focusButton setTitle:@"已关注" forState:(UIControlStateSelected)];
    XLViewBorderRadius(self.focusButton, 14 * kWidthRatio6s, 1, [UIColor whiteColor].CGColor);
    
    
    self.shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.shareButton];
    [self.shareButton xl_setImageName:@"main_share_white" target:self action:@selector(shareAction:)];
    
    
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
    
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right).mas_offset(4 * kWidthRatio6s);
        make.centerY.equalTo(self.backButton);
        make.width.height.mas_offset(32);
        //make.bottom.equalTo(self).mas_offset(0);
    }];
    
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).mas_offset(8 * kWidthRatio6s);
        make.top.equalTo(self.userIcon).mas_offset(-1);
        make.height.mas_offset(18);
    }];
    
    [self.shenImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameL.mas_right).mas_offset(8 * kWidthRatio6s);
        make.centerY.equalTo(self.nameL);
        make.width.height.mas_offset(12);
    }];
    
    [self.desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameL);
        make.bottom.equalTo(self.userIcon).mas_offset(1);
        make.right.equalTo(self.focusButton.mas_left).with.priorityLow();
        make.height.mas_offset(14);
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareButton);
        make.right.equalTo(self.shareButton.mas_left);
        make.width.mas_offset(58 * kWidthRatio6s);
        make.height.mas_offset(28 * kWidthRatio6s);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.bottom.equalTo(self.backButton);
        make.width.mas_offset(56 * kWidthRatio6s);
    }];
    
    
}


- (void)onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUser:(XLAppUserModel *)user {
    _user = user;
    self.nameL.text = _user.nickname;
    self.desL.text = _user.sign;
    self.userIcon.url = _user.avatar;
    self.userIcon.user_id = _user.user_id;
    
    self.shenImgV.hidden = ![_user.appraiser boolValue];
    self.focusButton.selected = [_user.followed boolValue] || [_user.user_id isEqualToString:[XLUserHandle userid]];

    if (XLStringIsEmpty(_user.sign)) {
        [self.nameL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userIcon.mas_right).mas_offset(8 * kWidthRatio6s);
            make.centerY.equalTo(self.userIcon);
            make.height.mas_offset(18);
        }];
        
    } else {
        [self.nameL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userIcon.mas_right).mas_offset(8 * kWidthRatio6s);
            make.top.equalTo(self.userIcon).mas_offset(-1);
            make.height.mas_offset(18);
        }];
        
    }
}

- (void)setTieziModel:(XLTieziModel *)tieziModel {
    _tieziModel = tieziModel;
    self.user = _tieziModel.user_info;
}

- (void)shareAction:(UIButton *)button {
    
    XLShareModel *message = [[XLShareModel alloc] init];
    message.title = self.tieziModel.content;
    message.entity_id = self.tieziModel.entity_id;
    
    XLShareView *shareView = [XLShareView shareView];
    shareView.showQRCode = NO;
    shareView.message = message;
    shareView.noDeletebtn = YES;
    [shareView show];
}

- (void)focusAction:(UIButton *)button {
    //kDefineWeakSelf;
    if (!button.selected) {
        [HUDController xl_showHUD];
        [XLFansFocusHandle followUserWithUid:self.user.user_id success:^(id  _Nonnull responseObject) {
            //[HUDController hideHUDWithText:responseObject];
            [HUDController hideHUD];
            button.selected = !button.selected;
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    } else {
        [HUDController xl_showHUD];
        [XLFansFocusHandle unfollowUserWithUid:self.user.user_id success:^(id  _Nonnull responseObject) {
            //[HUDController hideHUDWithText:responseObject];
            [HUDController hideHUD];
            button.selected = !button.selected;
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    }
}

@end
