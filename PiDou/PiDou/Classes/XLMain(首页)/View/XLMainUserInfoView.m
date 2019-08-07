//
//  XLMainUserInfoView.m
//  PiDou
//
//  Created by ice on 2019/4/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMainUserInfoView.h"
#import "XLUserIcon.h"
#import "XLFocusButton.h"
#import "XLFansFocusHandle.h"
#import "XLCommentHandle.h"
#import "XLMineHandle.h"
#import "XLLaunchManager.h"


@interface XLMainUserInfoView ()

@property (nonatomic, strong) XLUserIcon *userIcon;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *desL;
@property (nonatomic, strong) UIImageView *shenImgV;

@property (nonatomic, strong) UIButton *diamondButton;

@property (nonatomic, strong) XLFocusButton *focusButton;

/**是否关注*/
@property (nonatomic, assign) BOOL isFocus;

@end

@implementation XLMainUserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.userIcon = [[XLUserIcon alloc] init];
    [self addSubview:self.userIcon];
    
    self.nameL = [[UILabel alloc] init];
    [self addSubview:self.nameL];
    [self.nameL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:18.f];
    [self.nameL sizeToFit];
    
    
    self.shenImgV = [[UIImageView alloc] init];
    [self addSubview:self.shenImgV];
    self.shenImgV.image = [UIImage imageNamed:@"user_shen"];
    
    self.desL = [[UILabel alloc] init];
    [self addSubview:self.desL];
    [self.desL xl_setTextColor:XL_COLOR_DARKGRAY fontSize:12.f];
    
    
    self.diamondButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.diamondButton];
    [self.diamondButton xl_setTitle:@"0" color:XL_COLOR_RED size:14.f];
    [self.diamondButton setImage:[UIImage imageNamed:@"user_diamond"] forState:(UIControlStateNormal)];
    [self.diamondButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    CGSize titleLabelSize = self.diamondButton.titleLabel.bounds.size;
    CGFloat interval = 4 * kWidthRatio6s;
    self.diamondButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, titleLabelSize.width + interval);
    [self.diamondButton addTarget:self action:@selector(zanAction:) forControlEvents:(UIControlEventTouchUpInside)];

    
    
    self.focusButton = [XLFocusButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:self.focusButton];
    [self.focusButton addTarget:self action:@selector(onFocusAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.focusButton.isAdd = NO;
    self.focusButton.hidden = YES;
    
    [self reloadInfo];
    
    [self initLayout];
}

- (void)initLayout {
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(16 * kWidthRatio6s);
        make.top.equalTo(self).mas_offset(16 * kWidthRatio6s);
        make.width.height.mas_offset(44 * kWidthRatio6s);
        make.bottom.equalTo(self).mas_offset(0);
    }];
    
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).mas_offset(8 * kWidthRatio6s);
        make.top.equalTo(self.userIcon);
        make.height.mas_offset(20 * kWidthRatio6s);
    }];
    
    [self.shenImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameL.mas_right).mas_offset(8 * kWidthRatio6s);
        make.centerY.equalTo(self.nameL);
        make.width.height.mas_offset(16 * kWidthRatio6s);

    }];
    
    [self.desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameL);
        make.bottom.equalTo(self.userIcon);
        make.right.equalTo(self.diamondButton.mas_left).with.priorityLow();
        make.height.mas_offset(18 * kWidthRatio6s);
        make.right.equalTo(self).mas_offset(-66 * kWidthRatio6s);
    }];
    
    [self.diamondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-16 * kWidthRatio6s);
        make.centerY.equalTo(self).mas_offset(5 * kWidthRatio6s);
        make.height.mas_offset(20 * kWidthRatio6s);
        make.width.mas_offset(100 * kWidthRatio6s);
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIcon);
        make.right.equalTo(self).mas_offset(-16 * kWidthRatio6s);
        make.width.mas_offset(58);
        make.height.mas_offset(28);
    }];
}



#pragma mark - 点击关注
- (void)onFocusAction {
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController];
        return;
    }
    kDefineWeakSelf;
    if (!self.focusButton.isAdd) {
        [HUDController xl_showHUD];
        [XLFansFocusHandle followUserWithUid:self.userInfo.user_id success:^(id  _Nonnull responseObject) {
            //[HUDController hideHUDWithText:responseObject];
            [HUDController hideHUD];
            WeakSelf.focusButton.isAdd = !WeakSelf.focusButton.isAdd;
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    } else {
        [HUDController xl_showHUD];
        [XLFansFocusHandle unfollowUserWithUid:self.userInfo.user_id success:^(id  _Nonnull responseObject) {
            //[HUDController hideHUDWithText:responseObject];
            [HUDController hideHUD];
            WeakSelf.focusButton.isAdd = !WeakSelf.focusButton.isAdd;
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    }
}

#pragma mark - 点赞
- (void)zanAction:(UIButton *)button {
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController];
        return;
    }
    if (_userInfoViewType == XLMainUserInfoViewType_delete) {
        XLLog(@"删除我的作品");
        if (!XLStringIsEmpty(self.userInfo.cid)) {
            // 删除评论
            [HUDController xl_showHUD];
            [XLMineHandle commentDeletewithCid:self.userInfo.cid success:^(id  _Nonnull responseObject) {
                [HUDController hideHUDWithText:responseObject];
                [[NSNotificationCenter defaultCenter] postNotificationName:XLDelMyPublishNotification object:nil];
            } failure:^(id  _Nonnull result) {
                [HUDController xl_hideHUDWithResult:result];
            }];
        } else {
            // 删除帖子
            [HUDController xl_showHUD];
            [XLMineHandle entityDeleteWithEntity_id:self.userInfo.entity_id success:^(id  _Nonnull responseObject) {
                [HUDController hideHUDWithText:responseObject];
                [[NSNotificationCenter defaultCenter] postNotificationName:XLDelMyPublishNotification object:nil];
            } failure:^(id  _Nonnull result) {
                [HUDController xl_hideHUDWithResult:result];
            }];
        }
        
    } else {
        
        if (_userInfoViewType == XLMainUserInfoViewType_comment) {
            [HUDController xl_showHUD];
            kDefineWeakSelf;
            [XLCommentHandle doLikeCommentWithCid:self.userInfo.cid success:^(id  _Nonnull responseObject) {
                button.selected = YES;
                WeakSelf.userInfo.do_liked = @(button.selected);
                WeakSelf.userInfo.do_like_count = [NSString stringWithFormat:@"%ld",[WeakSelf.userInfo.do_like_count integerValue]+1];
                [button setTitle:[NSString stringWithFormat:@"%@",WeakSelf.userInfo.do_like_count] forState:(UIControlStateNormal)];
               // [HUDController hideHUDWithText:responseObject];
                [HUDController hideHUD];
                if (WeakSelf.delegate && [WeakSelf.delegate respondsToSelector:@selector(userInfoView:didSelectedWithIndex:select:count:)]) {
                    [WeakSelf.delegate userInfoView:WeakSelf didSelectedWithIndex:0 select:YES count:WeakSelf.userInfo.do_like_count];
                }
            } failure:^(id  _Nonnull result) {
                [HUDController xl_hideHUDWithResult:result];
            }];
        }
    }
}

- (void)setUserInfoViewType:(XLMainUserInfoViewType)userInfoViewType {
    _userInfoViewType = userInfoViewType;
    if (_userInfoViewType == XLMainUserInfoViewType_main) {
        self.shenImgV.hidden = NO;
        self.focusButton.hidden = YES;
        self.diamondButton.hidden = NO;
        [self.diamondButton setImage:[UIImage imageNamed:@"user_diamond"] forState:(UIControlStateNormal)];
    } else if (_userInfoViewType == XLMainUserInfoViewType_comment) {
        self.shenImgV.hidden = YES;
        self.focusButton.hidden = YES;
        self.diamondButton.hidden = NO;
        [self.diamondButton setImage:[UIImage imageNamed:@"main_zan_small"] forState:(UIControlStateNormal)];
        [self.diamondButton setImage:[UIImage imageNamed:@"main_zan_select_small"] forState:(UIControlStateSelected)];
    } else if (_userInfoViewType == XLMainUserInfoViewType_focus) {
        self.focusButton.hidden = NO;
        self.diamondButton.hidden = YES;
    } else if (_userInfoViewType == XLMainUserInfoViewType_none) {
        self.shenImgV.hidden = YES;
        self.focusButton.hidden = YES;
        self.diamondButton.hidden = YES;
    }  else if (_userInfoViewType == XLMainUserInfoViewType_delete) {
        [self.diamondButton setImage:[UIImage imageNamed:@"mine_publish_delete"] forState:(UIControlStateNormal)];
        [self.diamondButton setTitle:@"" forState:(UIControlStateNormal)];
        self.diamondButton.hidden = NO;
        self.focusButton.hidden = YES;
    }
}


- (void)reloadInfo {
    if (!XLStringIsEmpty([XLUserHandle userid])) {
        self.nameL.text = [XLUserHandle nickname];
        self.nameL.font = [UIFont xl_mediumFontOfSiz:14.f];
        //self.desL.text = @"优质视频内容提供者";
        
    } else {
        self.nameL.text = @"登录/注册";
        self.nameL.font = [UIFont xl_mediumFontOfSiz:18.f];
        self.desL.text = @"欢迎来到皮逗";
        self.userIcon.url = @"";
    }
}

- (void)setUserInfo:(XLAppUserModel *)userInfo {
    _userInfo = userInfo;
    if (_userInfo) {
        self.nameL.font = [UIFont xl_mediumFontOfSiz:14.f];
    }
    
    NSString *des = @"";
    NSArray *biaoqian = _userInfo.biaoqian;
    if (biaoqian.count > 1) {
        des = [NSString stringWithFormat:@"%@  %@", [self desType:biaoqian[0]], [self desType:biaoqian[1]]];
    } else if (biaoqian.count == 1) {
        des = [self desType:biaoqian[0]];
    }
    
    
    self.nameL.text = _userInfo.nickname;
    self.desL.text = des;
    self.shenImgV.hidden = ![_userInfo.appraiser boolValue];
    
    
    self.userIcon.vip = [_userInfo.vip boolValue];
    self.userIcon.url = _userInfo.avatar;
    self.userIcon.user_id = _userInfo.user_id;
    self.userInfo.user_id = _userInfo.user_id;
    
    [self.diamondButton setTitle:_userInfo.pdcoin_count forState:(UIControlStateNormal)];
    
    
    if (_userInfoViewType == XLMainUserInfoViewType_focus) {
        self.isFocus = [_userInfo.followed boolValue];
        if ([self.userInfo.user_id isEqualToString:[XLUserHandle userid]]) {
          //  self.focusButton.hidden = YES;
            [self.focusButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_offset(0);
            }];
        }
    } else if (_userInfoViewType == XLMainUserInfoViewType_comment) {
        [self.diamondButton setTitle:[NSString stringWithFormat:@"%@",_userInfo.do_like_count] forState:(UIControlStateNormal)];
        self.diamondButton.selected = [_userInfo.do_liked boolValue];
        if ([_userInfo.do_liked boolValue]) {
            [self.diamondButton setTitleColor:XL_COLOR_RED forState:(UIControlStateNormal)];
        } else {
            [self.diamondButton setTitleColor:XL_COLOR_DARKGRAY forState:(UIControlStateNormal)];
        }
    } else if(_userInfoViewType == XLMainUserInfoViewType_main) {
        if (!_userInfo.pdcoin_count) {
            self.isFocus = [_userInfo.followed boolValue] || [_userInfo.user_id isEqualToString:[XLUserHandle userid]];
            self.focusButton.hidden = NO;
            self.diamondButton.hidden = YES;
        }
        if ([_userInfo.user_id isEqualToString:[XLUserHandle userid]]) {
            [self.focusButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_offset(0);
            }];
        }
    }
}

- (void)setCreatTime:(NSString *)creatTime {
    _creatTime = creatTime;
    NSString *time = [NSDate messageTimeWithMilliSecondsSince1970:[_creatTime doubleValue]];
    if (XLStringIsEmpty(_userInfo.sign) || self.userInfoViewType == XLMainUserInfoViewType_comment) {
        self.desL.text = time;
    } else {
        self.desL.text = [NSString stringWithFormat:@"%@ · %@",time,_userInfo.sign];
    }
}


- (void)setIsFocus:(BOOL)isFocus {
    _isFocus = isFocus;
    self.focusButton.hidden = _isFocus;
    self.focusButton.isAdd = _isFocus;
    self.diamondButton.hidden = !_isFocus;
    
}


- (void)setTieziGodComment:(BOOL)tieziGodComment {
    _tieziGodComment = tieziGodComment;
    if (_tieziGodComment) {
        [self.userIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(12 * kWidthRatio6s);
            make.top.equalTo(self).mas_offset(12 * kWidthRatio6s);
            make.width.height.mas_offset(24 * kWidthRatio6s);
            make.bottom.equalTo(self).mas_offset(0);
        }];
        [self.nameL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userIcon.mas_right).mas_offset(8 * kWidthRatio6s);
            make.centerY.equalTo(self.userIcon);
            make.height.mas_offset(20 * kWidthRatio6s);
        }];
        [self.diamondButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-12 * kWidthRatio6s);
        }];
        
        [self.nameL xl_setTextColor:XL_COLOR_BLACK fontSize:12.f];
    } else {
        [self.userIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(16 * kWidthRatio6s);
            make.top.equalTo(self).mas_offset(16 * kWidthRatio6s);
            make.width.height.mas_offset(44 * kWidthRatio6s);
            make.bottom.equalTo(self).mas_offset(0);
        }];
        
        [self.nameL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userIcon.mas_right).mas_offset(8 * kWidthRatio6s);
            make.top.equalTo(self.userIcon);
            make.height.mas_offset(20 * kWidthRatio6s);
        }];
        
        [self.diamondButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-16 * kWidthRatio6s);
        }];
        
        [self.nameL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:18.f];
        
    }
}


- (NSString *)desType:(NSString *)str {
    NSString *type;
    switch ([str integerValue]) {
        case 1:
            type = @"优质内容贡献者";
            break;
        case 2:
            type = @"神评鉴定师";
            break;
        case 3:
            type = @"皮逗音乐达人";
            break;
        case 4:
            type = @"皮逗搞笑达人";
            break;
        case 5:
            type = @"皮逗正能量传播者";
            break;
        case 6:
            type = @"皮逗军事达人";
            break;
            
        default:
            break;
    }
    
    return type;
}

@end

