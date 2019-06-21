//
//  XLMsgCell.m
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMsgCell.h"
#import "XLFocusButton.h"
#import "XLTieziModel.h"
#import "XLFansFocusHandle.h"
#import "XLMineWalletController.h"

@interface XLMsgCell ()

@property (nonatomic, strong) UIImageView *iconImgV;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *timeL;

@property (nonatomic, strong) UILabel *conmentL;
@property (nonatomic, strong) UIImageView *zanImgV;

@property (nonatomic, strong) UIImageView *rightImgV;
//@property (nonatomic, strong) UIImageView *rightVideoImgV;
@property (nonatomic, strong) UILabel *rightTitleL;
@property (nonatomic, strong) XLFocusButton *focusButton;

@end

@implementation XLMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
//    self.contentView.backgroundColor = XLRandomColor;
    self.iconImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImgV];
    self.iconImgV.backgroundColor = XL_COLOR_BG;
    XLViewRadius(self.iconImgV, 22 * kWidthRatio6s);
    
    self.nameL = [[UILabel alloc] init];
    [self.contentView addSubview:self.nameL];
    [self.nameL xl_setTextColor:COLOR(0x333333) fontSize:14.f];
    
    
    self.timeL = [[UILabel alloc] init];
    [self.contentView addSubview:self.timeL];
    [self.timeL xl_setTextColor:COLOR(0x333333) fontSize:14.f];
    
    
    self.conmentL = [[UILabel alloc] init];
    [self.contentView addSubview:self.conmentL];
    [self.conmentL xl_setTextColor:COLOR(0x333333) fontSize:16.f];
    self.conmentL.numberOfLines = 0;
    self.conmentL.hidden = YES;
    
    self.zanImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.zanImgV];
    self.zanImgV.image = [UIImage imageNamed:@"main_zan"];
    self.zanImgV.hidden = YES;
    
    self.rightImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.rightImgV];
    self.rightImgV.backgroundColor = XL_COLOR_BG;
    XLViewRadius(self.rightImgV, 2 * kWidthRatio6s);
    
//    self.rightVideoImgV = [[UIImageView alloc] init];
//    [self.rightImgV addSubview:self.rightVideoImgV];
//    self.rightVideoImgV.image = [UIImage imageNamed:@"video_play"];
//    XLViewRadius(self.rightVideoImgV, 20 * kWidthRatio6s);
    
    
    self.rightTitleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.rightTitleL];
    [self.rightTitleL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:11.f];
    self.rightTitleL.backgroundColor = XL_COLOR_LINE;
    self.rightTitleL.textAlignment = NSTextAlignmentCenter;
    self.rightTitleL.numberOfLines = 0;
    XLViewRadius(self.rightTitleL, 2 * kWidthRatio6s);
    
    self.focusButton = [XLFocusButton buttonWithType:(UIButtonTypeSystem)];
    [self.contentView addSubview:self.focusButton];
    self.focusButton.isAdd = NO;
    [self.focusButton addTarget:self action:@selector(focusAction:) forControlEvents:(UIControlEventTouchUpInside)];

    self.rightImgV.hidden = YES;
//    self.rightVideoImgV.hidden = YES;
    self.rightTitleL.hidden = YES;
    self.focusButton.hidden = YES;
    
    [self initLayout];
}

- (void)initLayout {
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.top.equalTo(self.contentView).mas_offset(12 * kWidthRatio6s);
        make.width.height.mas_offset(44 * kWidthRatio6s);
    }];
    
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgV.mas_right).mas_offset(8 * kWidthRatio6s);
        make.top.equalTo(self.iconImgV);
        make.right.equalTo(self.contentView.mas_right).mas_offset(-92 * kWidthRatio6s);
    }];
    
    [self.conmentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameL);
        make.top.equalTo(self.nameL.mas_bottom).mas_offset(8 * kWidthRatio6s);
    }];
    
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameL);
        make.top.equalTo(self.nameL.mas_bottom).mas_offset(4 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView).mas_offset(-14 * kWidthRatio6s);
    }];
    
    [self.zanImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameL);
        make.top.equalTo(self.nameL.mas_bottom).mas_offset(8 * kWidthRatio6s);
        make.width.height.mas_offset(20 * kWidthRatio6s);
    }];
    
    
    [self.rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).mas_offset(-16 * kWidthRatio);\
        make.top.equalTo(self.contentView).mas_offset(12 * kWidthRatio);
        make.width.height.mas_offset(64 * kWidthRatio6s);
    }];
    
//    [self.rightVideoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.rightImgV);
//        make.width.height.mas_offset(40 * kWidthRatio6s);
//    }];
    
    [self.rightTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rightImgV);
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.rightImgV);
        make.width.mas_offset(58 * kWidthRatio6s);
        make.height.mas_offset(28 * kWidthRatio6s);
    }];
}

- (void)setActionType:(XLMsgActionType)actionType {
    _actionType = actionType;
    switch (_actionType) {
        case XLMsgActionType_comment:
        {
            self.zanImgV.hidden = YES;
            self.conmentL.hidden = NO;
            [self.timeL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.nameL);
                make.top.equalTo(self.conmentL.mas_bottom).mas_offset(4 * kWidthRatio6s);
                make.bottom.equalTo(self.contentView).mas_offset(-14 * kWidthRatio6s);
            }];
        }
            break;
        case XLMsgActionType_zan:
        {
            self.zanImgV.hidden = NO;
            self.conmentL.hidden = YES;
            [self.timeL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.nameL);
                make.top.equalTo(self.zanImgV.mas_bottom).mas_offset(4 * kWidthRatio6s);
                make.bottom.equalTo(self.contentView).mas_offset(-14 * kWidthRatio6s);
            }];
        }
            break;

        case XLMsgActionType_user:
        {
            self.zanImgV.hidden = YES;
            self.conmentL.hidden = YES;
            [self.timeL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.nameL);
                make.top.equalTo(self.nameL.mas_bottom).mas_offset(4 * kWidthRatio6s);
                make.bottom.equalTo(self.contentView).mas_offset(-14 * kWidthRatio6s);
            }];
        }
            break;


            
        default:
            break;
    }
}

- (void)setInfoType:(XLMsgInfoType)infoType {
    _infoType = infoType;
    switch (_infoType) {
        case XLMsgInfoType_image:
        {
            self.rightImgV.hidden = NO;
//            self.rightVideoImgV.hidden = YES;
            self.rightTitleL.hidden = YES;
            self.focusButton.hidden = YES;
        }
            break;
        case XLMsgInfoType_video:
        {
            self.rightImgV.hidden = NO;
//            self.rightVideoImgV.hidden = NO;
            self.rightTitleL.hidden = YES;
            self.focusButton.hidden = YES;
        }
            break;
        case XLMsgInfoType_text:
        {
            self.rightImgV.hidden = YES;
//            self.rightVideoImgV.hidden = YES;
            self.rightTitleL.hidden = NO;
            self.focusButton.hidden = YES;
        }
            break;
        case XLMsgInfoType_focus:
        {
            self.rightImgV.hidden = YES;
//            self.rightVideoImgV.hidden = YES;
            self.rightTitleL.hidden = YES;
            self.focusButton.hidden = NO;
        }
            break;
        case XLMsgInfoType_xingCoin:
        case XLMsgInfoType_pdcoin:
        {
            self.rightImgV.hidden = YES;
//            self.rightVideoImgV.hidden = YES;
            self.rightTitleL.hidden = YES;
            self.focusButton.hidden = NO;
            self.focusButton.isLook = YES;
        }
            break;

        default:
            break;
    }
}

#pragma mark - 点击关注
- (void)focusAction:(XLFocusButton *)button {
    if (self.infoType == XLMsgInfoType_focus) {
        kDefineWeakSelf;
        if (!self.focusButton.isAdd) {
            [HUDController xl_showHUD];
            [XLFansFocusHandle followUserWithUid:self.msgModel.user_info.user_id success:^(id  _Nonnull responseObject) {
                //[HUDController hideHUDWithText:responseObject];
                [HUDController hideHUD];
                WeakSelf.focusButton.isAdd = !WeakSelf.focusButton.isAdd;
            } failure:^(id  _Nonnull result) {
                [HUDController xl_hideHUDWithResult:result];
            }];
        } else {
            [HUDController xl_showHUD];
            [XLFansFocusHandle unfollowUserWithUid:self.msgModel.user_info.user_id success:^(id  _Nonnull responseObject) {
                //[HUDController hideHUDWithText:responseObject];
                [HUDController hideHUD];
                WeakSelf.focusButton.isAdd = !WeakSelf.focusButton.isAdd;
            } failure:^(id  _Nonnull result) {
                [HUDController xl_hideHUDWithResult:result];
            }];
        }
    } else if (self.infoType == XLMsgInfoType_pdcoin) {
        XLMineWalletController *walletVC = [[XLMineWalletController alloc] init];
        [self.navigationController pushViewController:walletVC animated:YES];
    } else if (self.infoType == XLMsgInfoType_xingCoin) {
        XLMineWalletController *walletVC = [[XLMineWalletController alloc] init];
        [self.navigationController pushViewController:walletVC animated:YES];
    }
}

- (void)setMsgModel:(XLMsgModel *)msgModel {
    _msgModel = msgModel;
    NSInteger type = [_msgModel.type integerValue];

    /**
     类型 详细见下文
     1 评论内容
     2 回复
     3 赞
     4 关注
     5 PDcoin被冻结
     6  打赏
     */
    switch (type) {
        case 1:
        {
            self.actionType = XLMsgActionType_comment;
            
            NSString *category = _msgModel.entity.category;
            if (XLTypeVideo(category)) {
                self.infoType = XLMsgInfoType_video;
                [self.rightImgV sd_setImageWithURL:[NSURL URLWithString:_msgModel.entity.cover.url] placeholderImage:nil];
            } else if (XLTypePicture(category)) {
                self.infoType = XLMsgInfoType_image;
                [self.rightImgV sd_setImageWithURL:[NSURL URLWithString:_msgModel.entity.cover.url] placeholderImage:nil];
            } else {
                self.infoType = XLMsgInfoType_text;
                self.rightTitleL.text = _msgModel.entity.content;
            }
            self.nameL.text = _msgModel.user_info.nickname;
            
            self.timeL.text = [NSString stringWithFormat:@"%@",[NSDate messageTimeWithMilliSecondsSince1970:[_msgModel.created doubleValue]]];
            self.conmentL.text = _msgModel.comment.content;
            [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:_msgModel.user_info.avatar] placeholderImage:[UIImage imageNamed:@"user_icon_placeholder"]];
            
            
        }
            break;
        case 2:
        {
            self.actionType = XLMsgActionType_comment;
            
            NSString *category = _msgModel.entity.category;
            if (XLTypeVideo(category)) {
                self.infoType = XLMsgInfoType_video;
                [self.rightImgV sd_setImageWithURL:[NSURL URLWithString:_msgModel.entity.cover.url] placeholderImage:nil];
            } else if (XLTypePicture(category)) {
                self.infoType = XLMsgInfoType_image;
                [self.rightImgV sd_setImageWithURL:[NSURL URLWithString:_msgModel.entity.cover.url] placeholderImage:nil];
            } else {
                self.infoType = XLMsgInfoType_text;
                self.rightTitleL.text = _msgModel.entity.content;
            }
            self.nameL.text = _msgModel.user_info.nickname;
            self.timeL.text = [NSString stringWithFormat:@"%@",[NSDate messageTimeWithMilliSecondsSince1970:[_msgModel.created doubleValue]]];
            self.conmentL.text = _msgModel.comment.content;
            [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:_msgModel.user_info.avatar] placeholderImage:[UIImage imageNamed:@"user_icon_placeholder"]];
        }
            break;
        case 3:
        {
            self.actionType = XLMsgActionType_zan;
            
            NSString *category = _msgModel.entity.category;
            if (XLTypeVideo(category)) {
                self.infoType = XLMsgInfoType_video;
                [self.rightImgV sd_setImageWithURL:[NSURL URLWithString:_msgModel.entity.cover.url] placeholderImage:nil];
            } else if (XLTypePicture(category)) {
                self.infoType = XLMsgInfoType_image;
                [self.rightImgV sd_setImageWithURL:[NSURL URLWithString:_msgModel.entity.cover.url] placeholderImage:nil];
            } else {
                self.infoType = XLMsgInfoType_text;
                self.rightTitleL.text = _msgModel.entity.content;
            }
            self.nameL.text = _msgModel.user_info.nickname;
            self.timeL.text = [NSString stringWithFormat:@"%@",[NSDate messageTimeWithMilliSecondsSince1970:[_msgModel.created doubleValue]]];
            self.conmentL.text = _msgModel.comment.content;
            [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:_msgModel.user_info.avatar] placeholderImage:[UIImage imageNamed:@"user_icon_placeholder"]];
        }
            break;
        case 4:
        {
            self.infoType = XLMsgInfoType_focus;
            self.actionType = XLMsgActionType_user;
            
            self.nameL.text = _msgModel.user_info.nickname;
            self.timeL.text = [NSString stringWithFormat:@"%@",[NSDate messageTimeWithMilliSecondsSince1970:[_msgModel.created doubleValue]]];
            [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:_msgModel.user_info.avatar] placeholderImage:[UIImage imageNamed:@"user_icon_placeholder"]];
            self.focusButton.isAdd = [_msgModel.user_info.followed boolValue];
        }
            break;
        case 5:
        {
            self.actionType = XLMsgActionType_comment;
            self.infoType = XLMsgInfoType_pdcoin;
            self.nameL.text = @"通知";
            self.conmentL.text = [NSString stringWithFormat:@"您有%@PDCoin被冻结",_msgModel.amount];
            self.iconImgV.image = [UIImage imageNamed:@"msg_fzPDCoin"];
            self.timeL.text = [NSString stringWithFormat:@"%@",[NSDate messageTimeWithMilliSecondsSince1970:[_msgModel.created doubleValue]]];
            
        }
            break;
        case 6:
        {
            self.actionType = XLMsgActionType_comment;
            self.infoType = XLMsgInfoType_xingCoin;
            self.nameL.text = @"通知";
            if (XLStringIsEmpty(_msgModel.user_info.nickname)) {
                self.conmentL.text = [NSString stringWithFormat:@"打赏了你%@星票",_msgModel.amount];
            } else {
                self.conmentL.text = [NSString stringWithFormat:@"%@打赏了你%@星票",_msgModel.user_info.nickname,_msgModel.amount];
            }
            
            self.iconImgV.image = [UIImage imageNamed:@"msg_rewardXing"];
            self.timeL.text = [NSString stringWithFormat:@"%@",[NSDate messageTimeWithMilliSecondsSince1970:[_msgModel.created doubleValue]]];
        }
            break;
            
            
        default:
            break;
    }
}

@end
