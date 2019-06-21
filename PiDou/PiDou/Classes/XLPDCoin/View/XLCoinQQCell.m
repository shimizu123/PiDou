//
//  XLCoinQQCell.m
//  PiDou
//
//  Created by kevin on 23/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCoinQQCell.h"

@interface XLCoinQQCell ()

@property (nonatomic, strong) UILabel *titleL;

@end

@implementation XLCoinQQCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleL = [[UILabel alloc] init];
    [self addSubview:self.titleL];
    [self.titleL xl_setTextColor:XL_COLOR_BLACK fontSize:14.f];
    
    
    [self initLayout];
}

- (void)initLayout {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(16 * kWidthRatio6s);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).mas_offset(-16 * kWidthRatio6s);
    }];
}

//- (void)setTitleName:(NSString *)titleName {
//    _titleName = titleName;
//    self.titleL.text = _titleName;
//}

- (void)setQqModel:(XLQQModel *)qqModel {
    _qqModel = qqModel;
    self.titleL.text = [NSString stringWithFormat:@"%@：%@",_qqModel.title,_qqModel.qq_no];
}

@end
