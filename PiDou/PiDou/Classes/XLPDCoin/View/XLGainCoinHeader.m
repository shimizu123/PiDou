//
//  XLGainCoinHeader.m
//  PiDou
//
//  Created by kevin on 23/4/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLGainCoinHeader.h"

@interface XLGainCoinHeader ()

@property (nonatomic, strong) UILabel *titleL;

@end

@implementation XLGainCoinHeader

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
    [self.titleL xl_setTextColor:XL_COLOR_DARKBLACK fontSize:16.f];
    self.titleL.text = @"微信群";
    
    [self initLayout];
}

- (void)initLayout {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(16 * kWidthRatio6s);
        make.top.equalTo(self).mas_offset(16 * kWidthRatio6s);
        make.bottom.equalTo(self).mas_offset(-8 * kWidthRatio6s);
    }];
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    self.titleL.text = _titleName;
}

@end

