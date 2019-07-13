//
//  XLSearchUserCell.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLSearchUserCell.h"
#import "XLUserIcon.h"
#import "XLFocusButton.h"
#import "XLFansModel.h"
#import "XLFansFocusHandle.h"

@interface XLSearchUserCell ()

@property (nonatomic, strong) XLUserIcon *userIcon;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *desL;
@property (nonatomic, strong) UILabel *fansNumL;

@property (nonatomic, strong) XLFocusButton *focusButton;

@end

@implementation XLSearchUserCell

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
    self.userIcon = [[XLUserIcon alloc] init];
    [self.contentView addSubview:self.userIcon];
    
    self.nameL = [[UILabel alloc] init];
    [self.contentView addSubview:self.nameL];
    self.nameL.font = [UIFont xl_mediumFontOfSiz:14.f];
    self.nameL.textColor = XL_COLOR_DARKBLACK;
    
    
    self.desL = [[UILabel alloc] init];
    [self.contentView addSubview:self.desL];
    [self.desL xl_setTextColor:XL_COLOR_BLACK fontSize:12.f];
    
    
    self.fansNumL = [[UILabel alloc] init];
    [self.contentView addSubview:self.fansNumL];
    [self.fansNumL xl_setTextColor:XL_COLOR_DARKGRAY fontSize:10.f];
    //self.fansNumL.text = [NSString stringWithFormat:@"粉丝：%d",3333];
    
    
    self.focusButton = [XLFocusButton buttonWithType:(UIButtonTypeSystem)];
    [self.contentView addSubview:self.focusButton];
    [self.focusButton addTarget:self action:@selector(onFocusAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.focusButton.isAdd = NO;
    
    [self initLayout];
}


- (void)initLayout {
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.top.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.width.height.mas_offset(56 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView).mas_offset(0);
    }];
    
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).mas_offset(8 * kWidthRatio6s);
        make.top.equalTo(self.userIcon);
        //make.height.mas_offset(20 * kWidthRatio6s);
    }];

    
    [self.desL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameL);
        make.top.equalTo(self.nameL.mas_bottom).mas_offset(2 * kWidthRatio6s);
        make.right.equalTo(self.focusButton.mas_left).with.priorityLow();
        make.height.mas_offset(18 * kWidthRatio6s);
        make.right.equalTo(self).mas_offset(-70 * kWidthRatio6s);
    }];
    
    [self.fansNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameL);
        make.top.equalTo(self.desL.mas_bottom).mas_offset(2 * kWidthRatio6s);
//        make.height.mas_offset(18 * kWidthRatio6s);
        make.bottom.equalTo(self.userIcon);
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIcon);
        make.right.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
        make.width.mas_offset(58 * kWidthRatio6s);
        make.height.mas_offset(28 * kWidthRatio6s);
    }];
    
}

- (void)setFansModel:(XLFansModel *)fansModel {
    _fansModel = fansModel;
    self.nameL.text = _fansModel.nickname;
    self.focusButton.isAdd = [_fansModel.followed boolValue];
    self.desL.text = _fansModel.sign;
    self.userIcon.url = _fansModel.avatar;
    self.userIcon.user_id = _fansModel.user_id;
    if ([_fansModel.user_id isEqualToString:[XLUserHandle userid]]) {
        self.focusButton.hidden = YES;
    } else {
        self.focusButton.hidden = NO;
    }
}

- (void)setCellType:(XLSearchUserCellType)cellType {
    _cellType = cellType;
    switch (_cellType) {
        case XLSearchUserCellType_noFansNum:
        {
            self.fansNumL.hidden = YES;
            [self.fansNumL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameL);
                make.top.equalTo(self.desL.mas_bottom).mas_offset(2 * kWidthRatio6s);
                //        make.height.mas_offset(18 * kWidthRatio6s);
                make.bottom.equalTo(self.userIcon);
                make.height.mas_offset(2 * kWidthRatio6s);
            }];
        }
            break;
        case XLSearchUserCellType_FansNum:
        {
            self.fansNumL.hidden = NO;
            [self.fansNumL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameL);
                make.top.equalTo(self.desL.mas_bottom).mas_offset(2 * kWidthRatio6s);
                //        make.height.mas_offset(18 * kWidthRatio6s);
                make.bottom.equalTo(self.userIcon);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)onFocusAction:(XLFocusButton *)button {
    [HUDController xl_showHUD];
    if (!button.isAdd) {
        [XLFansFocusHandle followUserWithUid:self.fansModel.user_id success:^(id  _Nonnull responseObject) {
            //[HUDController hideHUDWithText:responseObject];
            [HUDController hideHUD];
            button.isAdd = !button.isAdd;
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    } else {
        [XLFansFocusHandle unfollowUserWithUid:self.fansModel.user_id success:^(id  _Nonnull responseObject) {
            //[HUDController hideHUDWithText:responseObject];
            [HUDController hideHUD];
            button.isAdd = !button.isAdd;
        } failure:^(id  _Nonnull result) {
            [HUDController xl_hideHUDWithResult:result];
        }];
    }

}


@end
