//
//  XLInviteFriendCell.m
//  PiDou
//
//  Created by kevin on 10/5/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLInviteFriendCell.h"

@interface XLInviteFriendCell () 

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *adviteButton;

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
    
    self.adviteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.adviteButton];
    [self.adviteButton xl_setTitle:@"邀请好友" color:XL_COLOR_RED size:14.f];
    XLViewBorderRadius(self.adviteButton, 2 * kWidthRatio6s, 1, XL_COLOR_RED.CGColor);
    self.adviteButton.enabled = NO;
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(XL_LEFT_DISTANCE);
        make.top.equalTo(self.contentView);
        make.height.mas_offset(48 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
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

@end
