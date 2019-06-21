//
//  XLUserNaviBar.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLUserNaviBar.h"
#import "XLUserIcon.h"
#import "XLFocusButton.h"
#import "XLFansFocusHandle.h"

@interface XLUserNaviBar ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) XLUserIcon *userIcon;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *desL;
@property (nonatomic, strong) UIImageView *shenImgV;

@property (nonatomic, strong) XLFocusButton *focusButton;

@end

@implementation XLUserNaviBar

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
    self.titleLabel.textColor = XL_COLOR_DARKBLACK;
    
    
    self.userIcon = [[XLUserIcon alloc] init];
    [self addSubview:self.userIcon];
    
    self.nameL = [[UILabel alloc] init];
    [self addSubview:self.nameL];
    [self.nameL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:12.f];
    
    
    self.shenImgV = [[UIImageView alloc] init];
    [self addSubview:self.shenImgV];
    self.shenImgV.image = [UIImage imageNamed:@"user_shen"];
    
    self.desL = [[UILabel alloc] init];
    [self addSubview:self.desL];
    [self.desL xl_setTextColor:XL_COLOR_DARKGRAY fontSize:10.f];
    
    
    self.focusButton = [XLFocusButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:self.focusButton];
    [self.focusButton addTarget:self action:@selector(onFocusAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.focusButton.isAdd = NO;
    
    self.userIcon.hidden = YES;
    self.nameL.hidden = YES;
    self.shenImgV.hidden = YES;
    self.desL.hidden = YES;
    self.focusButton.hidden = YES;
    
    
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
        make.right.equalTo(self).mas_offset(-66 * kWidthRatio6s);
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIcon);
        make.right.equalTo(self).mas_offset(-16 * kWidthRatio6s);
        make.width.mas_offset(58);
        make.height.mas_offset(28);
    }];
}


- (void)onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setIsUser:(BOOL)isUser {
    _isUser = isUser;
    
    self.userIcon.hidden = !_isUser;
    self.nameL.hidden = !_isUser;
    self.shenImgV.hidden = !_isUser;
    self.desL.hidden = !_isUser;
    self.focusButton.hidden = !_isUser;
    self.titleLabel.hidden = _isUser;
    
    self.backgroundColor = COLOR_A(0xffffff, _isUser);
    self.backButton.selected = _isUser;
    if (![_user.appraiser boolValue]) {
        self.shenImgV.hidden = YES;
    }
    if (!_isUser) {
        self.shenImgV.hidden = YES;
    }
    
    if ([_user.user_id isEqualToString:[XLUserHandle userid]]) {
        self.focusButton.hidden = YES;
    }
}

- (void)setUser:(XLAppUserModel *)user {
    _user = user;
    self.nameL.text = _user.nickname;
    self.desL.text = _user.sign;
    self.userIcon.url = _user.avatar;
    if (!_user.isTopic) {
        self.userIcon.user_id = _user.user_id;
    }
    
    self.focusButton.isAdd = [_user.followed boolValue];
    self.shenImgV.hidden = ![_user.appraiser boolValue];
    if (!_isUser) {
        self.shenImgV.hidden = YES;
    }
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
    
    if ([_user.user_id isEqualToString:[XLUserHandle userid]]) {
        self.focusButton.hidden = YES;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)onFocusAction:(XLFocusButton *)button {
    kDefineWeakSelf;
    if (self.user.isTopic) {
        // 对话题的关注
        [HUDController xl_showHUD];
        [XLFansFocusHandle followTopicWithTopicID:self.user.user_id success:^(id  _Nonnull responseObject) {
            //[HUDController hideHUDWithText:responseObject];
            [HUDController hideHUD];
            button.isAdd = !button.isAdd;
            [[NSNotificationCenter defaultCenter] postNotificationName:XLTopicFocusNotification object:nil];
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    } else {
        // 对用户的关注
        if (!self.focusButton.isAdd) {
            [HUDController xl_showHUD];
            [XLFansFocusHandle followUserWithUid:self.user.user_id success:^(id  _Nonnull responseObject) {
                //[HUDController hideHUDWithText:responseObject];
                [HUDController hideHUD];
                WeakSelf.focusButton.isAdd = !WeakSelf.focusButton.isAdd;
                if (WeakSelf.updateFinish) {
                    WeakSelf.updateFinish();
                }
            } failure:^(id  _Nonnull result) {
                [HUDController xl_hideHUDWithResult:result];
            }];
        } else {
            [HUDController xl_showHUD];
            [XLFansFocusHandle unfollowUserWithUid:self.user.user_id success:^(id  _Nonnull responseObject) {
                //[HUDController hideHUDWithText:responseObject];
                [HUDController hideHUD];
                WeakSelf.focusButton.isAdd = !WeakSelf.focusButton.isAdd;
                if (WeakSelf.updateFinish) {
                    WeakSelf.updateFinish();
                }
            } failure:^(id  _Nonnull result) {
                [HUDController xl_hideHUDWithResult:result];
            }];
        }
    }
    
}

- (void)setBackBlack:(BOOL)backBlack {
    _backBlack = backBlack;
    if (_backBlack) {
        [self.backButton setImage:[UIImage imageNamed:@"navi_arrow_black"] forState:(UIControlStateNormal)];
        self.titleLabel.text = @"个人名片";
    } else {
        [self.backButton setImage:[UIImage imageNamed:@"navi_arrow_white"] forState:(UIControlStateNormal)];
       
    }
}

- (void)setNaviSkin:(XLUserNaviBarSkin)naviSkin {
    _naviSkin = naviSkin;
    switch (_naviSkin) {
        case XLUserNaviBarSkin_white:
        {
            self.backgroundColor = [UIColor whiteColor];
        }
            break;
        case XLUserNaviBarSkin_black:
        {
            self.backgroundColor = [UIColor clearColor];
        }
            break;
            
        default:
            break;
    }
}

@end
