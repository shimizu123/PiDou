//
//  OutflowCell.m
//  PiDou
//
//  Created by 邓康大 on 2019/8/29.
//  Copyright © 2019 ice. All rights reserved.
//

#import "OutflowCell.h"

@interface OutflowCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation OutflowCell

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
    self.imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imgView];
    
    self.label = [[UILabel alloc] init];
    [self.contentView addSubview:self.label];
    [self.label xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.selectBtn];
    [self.selectBtn setImage:[UIImage imageNamed:@"ZC_button02"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"ZC_button01"] forState:UIControlStateSelected];
    self.selectBtn.userInteractionEnabled = NO;
    
    [self initLayout];
}

- (void)initLayout {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(12 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView).mas_offset(-12 * kWidthRatio6s);
        make.width.height.mas_offset(26 * kWidthRatio6s);
        make.left.equalTo(self.contentView).mas_offset(15 * kWidthRatio6s);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView.mas_right).mas_offset(16 * kWidthRatio6s);
        make.centerY.equalTo(self.imgView);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.label);
        make.width.height.mas_offset(21 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-15 * kWidthRatio6s);
    }];
}


- (void)setIcon:(NSString *)icon {
    _icon = icon;
    self.imgView.image = [UIImage imageNamed:_icon];
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    self.label.text = _titleName;
}



@end
