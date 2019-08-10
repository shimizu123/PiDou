//
//  XLWalletRecordCell.m
//  PiDou
//
//  Created by ice on 2019/4/11.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLWalletRecordCell.h"
#import "XLPDRecordModel.h"

@interface XLWalletRecordCell () 

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *timeL;

@property (nonatomic, strong) UIView *hLine;

@property (nonatomic, strong) UILabel *statusL;

@end

@implementation XLWalletRecordCell

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

- (void)setRecordModel:(XLPDRecordModel *)recordModel {
    _recordModel = recordModel;
    
    if ([_recordModel.type integerValue] == 2) {
        [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.numL.mas_right).mas_offset(10 * kWidthRatio6s);
        }];
        if ([_recordModel.status isEqualToString:@"0"]) {
            self.statusL.text = @"(提现中...)";
        } else if ([_recordModel.status isEqualToString:@"1"]) {
            self.statusL.text = @"(提现成功)";
        } else if ([_recordModel.status isEqualToString:@"3"]) { 
            self.statusL.text = @"(提现失败)";
        }
    } else {
        [self.statusL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(0);
        }];
    }
    
    self.timeL.text = !XLStringIsEmpty(_recordModel.created) ? _recordModel.created : (!XLStringIsEmpty(_recordModel.date) ? _recordModel.date :_recordModel.join_date);
    self.titleL.text = _recordModel.typeStr;
    
    if ([_recordModel.amount rangeOfString:@"+"].location != NSNotFound || [_recordModel.amount rangeOfString:@"-"].location != NSNotFound) {
        
        
        self.numL.text = [NSString stringWithFormat:@"%@",_recordModel.amount];
    } else {
        if ([_recordModel.type integerValue] == 21 || [_recordModel.type integerValue] == 26) {
            self.numL.text = [NSString stringWithFormat:@"-%@",_recordModel.amount];
        } else {
            self.numL.text = [NSString stringWithFormat:@"+%@",_recordModel.amount];
        }
    }
    
}

@end
