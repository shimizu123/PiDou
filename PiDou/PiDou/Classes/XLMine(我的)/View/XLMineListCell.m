//
//  XLMineListCell.m
//  PiDou
//
//  Created by ice on 2019/4/10.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineListCell.h"

@interface XLMineListCell () 

@property (nonatomic, strong) UIImageView *iconImgV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *arrowImgV;
@property (nonatomic, strong) UILabel *descL;

@end

@implementation XLMineListCell

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
    
    self.iconImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImgV];
    
    
    self.titleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleL];
    [self.titleL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    
    self.descL = [[UILabel alloc] init];
    [self.contentView addSubview:self.descL];
    [self.descL xl_setTextColor:XL_COLOR_DARKGRAY fontSize:16.f];
    self.descL.textAlignment = NSTextAlignmentRight;
    self.descL.numberOfLines = 1;
    
    
    self.arrowImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.arrowImgV];
    self.arrowImgV.image = [UIImage imageNamed:@"mine_right_arrow"];
    
    [self initLayout];
    
}

- (void)initLayout {
    
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_offset(48 * kWidthRatio6s);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.left.equalTo(self.iconImgV.mas_right).mas_offset(16 * kWidthRatio6s);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.descL.mas_left);
        make.height.mas_offset(48 * kWidthRatio6s);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_offset(80 * kWidthRatio6s);
    }];
    
    [self.descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL);
        make.right.equalTo(self.arrowImgV.mas_left).mas_offset(-4 * kWidthRatio6s);
    }];
    
    [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleL);
        make.right.equalTo(self.contentView).mas_offset(-12 * kWidthRatio6s);
        make.width.height.mas_offset(16 * kWidthRatio6s);
    }];
}

- (void)setListType:(XLMineListType)listType {
    _listType = listType;
    switch (_listType) {
        case XLMineListType_arrow:
        {
            self.arrowImgV.hidden = NO;
            [self.descL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.titleL);
                make.right.equalTo(self.arrowImgV.mas_left).mas_offset(-4 * kWidthRatio6s);
            }];
        }
            break;
        case XLMineListType_none:
        {
            self.arrowImgV.hidden = YES;
            [self.descL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.titleL);
                make.right.equalTo(self.arrowImgV.mas_right);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    self.iconImgV.image = [UIImage imageNamed:_icon];
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    self.titleL.text = _titleName;
}

- (void)setDesName:(NSString *)desName {
    _desName = desName;
    self.descL.text = _desName;
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    _infoDic = infoDic;
    self.titleName = _infoDic[@"title"];
    self.desName = _infoDic[@"desc"];
    BOOL  type = [_infoDic[@"type"] boolValue];
    self.listType = type;
}

@end
