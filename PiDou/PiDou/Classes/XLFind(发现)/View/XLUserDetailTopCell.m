//
//  XLUserDetailTopCell.m
//  PiDou
//
//  Created by ice on 2019/4/9.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLUserDetailTopCell.h"
#import "XLMainUserInfoView.h"
#import "XLFansFocusController.h"

@interface XLUserDetailTopCell ()

@property (nonatomic, strong) XLMainUserInfoView *infoView;

//@property (nonatomic, strong) UILabel *duanziLabel;

@property (nonatomic, strong) UIButton *fansButton;
@property (nonatomic, strong) UIButton *focusButton;

@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *fansTitleLabel;

@property (nonatomic, strong) UILabel *focusLabel;
@property (nonatomic, strong) UILabel *focusTitleLabel;

@property (nonatomic, strong) UIView *vLine;

@property (nonatomic, strong) UIView *botKongView;

@end

@implementation XLUserDetailTopCell

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
    self.infoView.userInfoViewType = XLMainUserInfoViewType_focus;
    
//    self.duanziLabel = [[UILabel alloc] init];
//    [self.contentView addSubview:self.duanziLabel];
//    self.duanziLabel.numberOfLines = 0;
//    [self.duanziLabel xl_setTextColor:XL_COLOR_DARKBLACK fontSize:13.f];
    
    
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
    self.botKongView.backgroundColor = XL_COLOR_BG;
    
    [self initLayout];
}

- (void)initLayout {
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
    }];
    
//    [self.duanziLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
//        make.top.equalTo(self.infoView.mas_bottom).mas_offset(8 * kWidthRatio6s);
//        make.right.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
//    }];
    
    
    
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
    XLFansFocusController *fansVC = [[XLFansFocusController alloc] init];
    fansVC.vcType = XLFansFocusVCType_fans;
    fansVC.user_id = self.user.user_id;
    [self.navigationController pushViewController:fansVC animated:YES];
}

- (void)focusAction {
    XLLog(@"点击关注");
    XLFansFocusController *fansVC = [[XLFansFocusController alloc] init];
    fansVC.vcType = XLFansFocusVCType_focus;
    fansVC.user_id = self.user.user_id;
    [self.navigationController pushViewController:fansVC animated:YES];
}

- (void)setUser:(XLAppUserModel *)user {
    _user = user;
    
    self.infoView.userInfo = _user;
    self.fansLabel.text = [NSString stringWithFormat:@"%@",_user.fans];
    self.focusLabel.text = [NSString stringWithFormat:@"%@",_user.followers];
}

@end
