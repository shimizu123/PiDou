//
//  XLMineSettingTopCell.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineSettingTopCell.h"
#import "XLUserIcon.h"

@interface XLMineSettingTopCell ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *arrowImgV;

@property (nonatomic, strong) XLUserIcon *icon;

@end

@implementation XLMineSettingTopCell


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
    
    
    self.icon = [[XLUserIcon alloc] init];
    [self.contentView addSubview:self.icon];
    
    self.arrowImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.arrowImgV];
    self.arrowImgV.image = [UIImage imageNamed:@"mine_right_arrow"];
    
    [self initLayout];
    
}

- (void)initLayout {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.icon.mas_left);
        make.height.mas_offset(72 * kWidthRatio6s);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL);
        make.width.height.mas_offset(48 * kWidthRatio6s);
        make.right.equalTo(self.arrowImgV.mas_left).mas_offset(-8 * kWidthRatio6s);
    }];
    
    [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL);
        make.right.equalTo(self.contentView).mas_offset(-12 * kWidthRatio6s);
        make.width.height.mas_offset(16 * kWidthRatio6s);
    }];
}


- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    self.titleL.text = _titleName;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    self.icon.url = _url;
}

@end
