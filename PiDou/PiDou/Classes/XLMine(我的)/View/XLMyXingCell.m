//
//  XLMyXingCell.m
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMyXingCell.h"

@interface XLMyXingCell () 

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *xingNumL;

@property (nonatomic, strong) UIView *botKongView;

@end

@implementation XLMyXingCell

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
    [self.titleL xl_setTextColor:XL_COLOR_BLACK fontSize:16.f];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.text = @"我的星票";
    
    self.xingNumL = [[UILabel alloc] init];
    [self.contentView addSubview:self.xingNumL];
    [self.xingNumL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:28.f];
    self.xingNumL.textAlignment = NSTextAlignmentCenter;
    
    
    
    self.botKongView = [[UIView alloc] init];
    self.botKongView.backgroundColor = XL_COLOR_BG;
    [self.contentView addSubview:self.botKongView];
    
    [self initLayout];
}

- (void)initLayout {
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.centerX.equalTo(self.contentView);
        make.height.mas_offset(18 * kWidthRatio6s);
    }];
    
    [self.xingNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.titleL.mas_bottom).mas_offset(8 * kWidthRatio6s);
        make.height.mas_offset(28 * kWidthRatio6s);
    }];
    
    [self.botKongView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_offset(12 * kWidthRatio6s);
        make.top.equalTo(self.xingNumL.mas_bottom).mas_offset((16 * kWidthRatio6s));
    }];
}

- (void)setCoin:(NSNumber *)coin {
    _coin = coin;
    self.xingNumL.text = [NSString stringWithFormat:@"%@",_coin];
}

@end
