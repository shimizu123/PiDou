//
//  PdcOutflowRecordCell.m
//  PiDou
//
//  Created by 邓康大 on 2019/9/1.
//  Copyright © 2019 ice. All rights reserved.
//

#import "PdcOutflowRecordCell.h"
#import "PdcOutflowRecordModel.h"

@interface PdcOutflowRecordCell ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *timeL;

@property (nonatomic, strong) UIView *hLine;
@property (nonatomic, strong) UILabel *statusL;

@end

@implementation PdcOutflowRecordCell

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
    [self.titleL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:14.f];
    
    self.numL = [[UILabel alloc] init];
    [self.contentView addSubview:self.numL];
    [self.numL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:14.f];
    
    self.statusL = [[UILabel alloc] init];
    [self.contentView addSubview:self.statusL];
    [self.statusL xl_setTextColor:XL_COLOR_RED fontSize:12.f];
    
    self.timeL = [[UILabel alloc] init];
    [self.contentView addSubview:self.timeL];
    [self.timeL xl_setTextColor:XL_COLOR_DARKGRAY fontSize:12.f];
    self.timeL.textAlignment = NSTextAlignmentRight;
    
    self.hLine = [[UIView alloc] init];
    [self.contentView addSubview:self.hLine];
    self.hLine.backgroundColor = XL_COLOR_LINE;
    
    [self initLayout];    
}

- (void)initLayout {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.top.bottom.equalTo(self.contentView);
        make.height.mas_offset(48 * kWidthRatio6s);
    }];
    
    [self.numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.left.equalTo(self.titleL.mas_right);
        make.right.equalTo(self.timeL.mas_left);
    }];
    
    [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.numL.mas_right).mas_offset(10 * kWidthRatio6s);
    }];
    
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).mas_offset(-16 * kWidthRatio6s);
        make.centerY.equalTo(self.titleL);
    }];
    
    [self.hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.right.bottom.equalTo(self.contentView);
        make.height.mas_offset(1);
    }];
}

- (void)setRecordModel:(PdcOutflowRecordModel *)recordModel {
    _recordModel = recordModel;
    
    self.timeL.text = [_recordModel.created substringToIndex:10];
    self.titleL.text = _recordModel.transfer_type;
    
    if ([_recordModel.status integerValue] == 1) { //转入成功
        self.numL.text = [NSString stringWithFormat:@"+%@",_recordModel.transfer_amount];
        self.statusL.text = @"(转入成功)";
    } else if ([_recordModel.status integerValue] == 2) { //转出失败
        self.numL.text = [NSString stringWithFormat:@"-%@",_recordModel.transfer_amount];
        self.statusL.text = @"(转出失败)";
    } else {
        self.numL.text = [NSString stringWithFormat:@"-%@",_recordModel.transfer_amount];
        self.statusL.text = @"(待审核)";
    }
}

@end
