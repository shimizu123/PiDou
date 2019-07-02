//
//  XLInviteFriendCell.m
//  PiDou
//
//  Created by kevin on 10/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLInviteFriendCell.h"
#import <MBProgressHUD.h>

@interface XLInviteFriendCell () 

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *adviteButton;
@property (nonatomic, strong) UIButton *fuzhiButton;

@end

@implementation XLInviteFriendCell

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
    self.titleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleL];
    [self.titleL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    
    self.fuzhiButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.fuzhiButton];
    [self.fuzhiButton xl_setTitle:@"复制邀请码" color:XL_COLOR_RED size:14.f];
    XLViewBorderRadius(self.fuzhiButton, 2 * kWidthRatio6s, 1, XL_COLOR_RED.CGColor);
    [self.fuzhiButton addTarget:self action:@selector(fuzhi) forControlEvents:UIControlEventTouchUpInside];
    
    self.adviteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.adviteButton];
    [self.adviteButton xl_setTitle:@"邀请好友" color:XL_COLOR_RED size:14.f];
    XLViewBorderRadius(self.adviteButton, 2 * kWidthRatio6s, 1, XL_COLOR_RED.CGColor);
   // self.adviteButton.enabled = NO;
    [self.adviteButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(XL_LEFT_DISTANCE);
        make.top.equalTo(self.contentView);
        make.height.mas_offset(48 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
    }];
    
    [self.fuzhiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.adviteButton);
        make.right.equalTo(self.adviteButton.mas_left).mas_offset(-10 * kWidthRatio6s);
        make.height.mas_offset(32 * kWidthRatio6s);
        make.width.mas_offset(72 * kWidthRatio6s);
    }];
    
    [self.adviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL);
        make.right.equalTo(self.contentView).mas_offset(-XL_LEFT_DISTANCE);
        make.height.mas_offset(32 * kWidthRatio6s);
        make.width.mas_offset(72 * kWidthRatio6s);
    }];
}

- (void)setInvCode:(NSString *)invCode {
    _invCode = invCode;
    self.titleL.text = [NSString stringWithFormat:@"皮逗邀请码：%@",_invCode];
}

- (void)shareAction {
    if (_didSelectInvite) {
        _didSelectInvite();
    }
}

- (void)fuzhi {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.invCode;
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"复制成功";
    [hud hideAnimated:true afterDelay:1];
}

@end
