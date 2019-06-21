//
//  XLMineTopCell.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineTopCell.h"
#import "XLMainUserInfoView.h"
#import "XLFansFocusController.h"
#import "XLMineFocusController.h"
#import "XLLaunchManager.h"

@interface XLMineTopCell ()

@property (nonatomic, strong) XLMainUserInfoView *infoView;

@property (nonatomic, strong) UIButton *fansButton;
@property (nonatomic, strong) UIButton *focusButton;

@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *fansTitleLabel;

@property (nonatomic, strong) UILabel *focusLabel;
@property (nonatomic, strong) UILabel *focusTitleLabel;

@property (nonatomic, strong) UIView *vLine;

@property (nonatomic, strong) UIView *botKongView;

@property (nonatomic, strong) UIImageView *arrowImgV;

@end

@implementation XLMineTopCell


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
    self.infoView = [[XLMainUserInfoView alloc] init];
    [self.contentView addSubview:self.infoView];
    self.infoView.userInfoViewType = XLMainUserInfoViewType_none;

    self.arrowImgV = [[UIImageView alloc] init];
    [self.infoView addSubview:self.arrowImgV];
    self.arrowImgV.image = [UIImage imageNamed:@"mine_right_arrow"];
    
    self.fansButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.fansButton];
    [self.fansButton addTarget:self action:@selector(fansAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.focusButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.focusButton];
    [self.focusButton addTarget:self action:@selector(focusAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.fansLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.fansLabel];
    [self.fansLabel xl_setTextColor:XL_COLOR_DARKBLACK fontSize:18.f];
    self.fansLabel.text = @"0";
    self.fansLabel.textAlignment = NSTextAlignmentCenter;
    
    self.fansTitleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.fansTitleLabel];
    [self.fansTitleLabel xl_setTextColor:XL_COLOR_DARKGRAY fontSize:11.f];
    self.fansTitleLabel.text = @"粉丝";
    self.fansTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.focusLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.focusLabel];
    [self.focusLabel xl_setTextColor:XL_COLOR_DARKBLACK fontSize:18.f];
    self.focusLabel.text = @"0";
    self.focusLabel.textAlignment = NSTextAlignmentCenter;
    
    self.focusTitleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.focusTitleLabel];
    [self.focusTitleLabel xl_setTextColor:XL_COLOR_DARKGRAY fontSize:11.f];
    self.focusTitleLabel.text = @"关注";
    self.focusTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.vLine = [[UIView alloc] init];
    [self.contentView addSubview:self.vLine];
    self.vLine.backgroundColor = COLOR(0xe6e6e6);
    
    
    self.botKongView = [[UIView alloc] init];
    [self.contentView addSubview:self.botKongView];
    self.botKongView.backgroundColor = [UIColor whiteColor];
    
    [self initLayout];
}

- (void)initLayout {
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s + XL_LIUHAI_H);
    }];
    
    [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.infoView).mas_offset(8 * kWidthRatio6s);
        make.right.equalTo(self.infoView).mas_offset(-16 * kWidthRatio6s);
        make.height.width.mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.fansButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.infoView.mas_bottom).mas_offset(7 * kWidthRatio6s);
        make.right.equalTo(self.vLine.mas_left);
        make.height.mas_offset(70 * kWidthRatio6s);
    }];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.fansButton);
        make.right.equalTo(self.contentView);
        make.left.equalTo(self.vLine.mas_right);
    }];
    
    [self.vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fansButton);
        make.width.mas_offset(1);
        make.height.mas_offset(32 * kWidthRatio6s);
    }];
    
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fansButton).mas_offset(12 * kWidthRatio6s);
        make.left.right.equalTo(self.fansButton);
        make.height.mas_offset(26 * kWidthRatio6s);
    }];
    
    [self.fansTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fansLabel);
        make.bottom.equalTo(self.fansButton).mas_offset(-12 * kWidthRatio6s);
        make.height.mas_offset(16 * kWidthRatio6s);
    }];
    
    [self.focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.focusButton);
        make.centerY.equalTo(self.fansLabel);
    }];
    
    [self.focusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.focusLabel);
        make.centerY.equalTo(self.fansTitleLabel);
    }];
    
    [self.botKongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_offset(12 * kWidthRatio6s);
        make.top.equalTo(self.fansButton.mas_bottom);
    }];
}

- (void)fansAction {
    XLLog(@"点击粉丝");
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController];
        return;
    }
    XLFansFocusController *fansVC = [[XLFansFocusController alloc] init];
    fansVC.vcType = XLFansFocusVCType_fans;
    fansVC.user_id = self.userInfo.user_id;
    [self.navigationController pushViewController:fansVC animated:YES];
}

- (void)focusAction {
    XLLog(@"点击关注");
    if (XLStringIsEmpty([XLUserHandle userid])) {
        [XLLaunchManager goLoginWithTarget:self.parentController];
        return;
    }
    XLMineFocusController *fansVC = [[XLMineFocusController alloc] init];
    [self.navigationController pushViewController:fansVC animated:YES];
}

- (void)setUserInfo:(XLAppUserModel *)userInfo {
    _userInfo = userInfo;
    
    self.fansLabel.text = _userInfo.fans;
    self.focusLabel.text = _userInfo.followers;
    if (_userInfo) {
        self.infoView.userInfo = _userInfo;
    } else {
        [self.infoView reloadInfo];
        self.focusLabel.text = @"0";
        self.fansLabel.text = @"0";
    }
}

@end
