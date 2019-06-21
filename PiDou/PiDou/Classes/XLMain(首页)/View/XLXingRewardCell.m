//
//  XLXingRewardCell.m
//  PiDou
//
//  Created by ice on 2019/5/12.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLXingRewardCell.h"

@interface XLXingRewardCell ()

@property (nonatomic, strong) UIImageView *xingImgV;
@property (nonatomic, strong) UILabel *xingNumL;

@end

@implementation XLXingRewardCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    XLViewRadius(self.contentView, 4 * kWidthRatio6s);
    
    self.contentView.backgroundColor = XL_COLOR_BG;
    
    self.xingImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.xingImgV];
    self.xingImgV.image = [UIImage imageNamed:@"xing_ticket"];
    
    self.xingNumL = [[UILabel alloc] init];
    [self.contentView addSubview:self.xingNumL];
    [self.xingNumL xl_setTextColor:XL_COLOR_BLACK fontSize:12.f];
    self.xingNumL.text = @"1星票";
    self.xingNumL.textAlignment = NSTextAlignmentCenter;
    
    
    [self initLayout];
}

- (void)initLayout {
    [self.xingImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(3 * kWidthRatio6s);
        make.left.equalTo(self.contentView).mas_offset(10 * kWidthRatio6s);
        make.right.equalTo (self.contentView).mas_offset(-10 * kWidthRatio6s);
        make.width.equalTo(self.xingImgV.mas_height);
    }];
    
    [self.xingNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.xingImgV.mas_bottom);
        make.bottom.equalTo(self.contentView).mas_offset(-8 * kWidthRatio6s);
    }];
}

- (void)setHightlight:(BOOL)hightlight {
    _hightlight = hightlight;
    if (_hightlight) {
        self.contentView.backgroundColor = COLOR_A(0xFC4040, 0.1);
    } else {
        self.contentView.backgroundColor = XL_COLOR_BG;
    }
}

- (void)setNumStr:(NSString *)numStr {
    _numStr = numStr;
    self.xingNumL.text = [NSString stringWithFormat:@"%@星票",_numStr];
}


@end
