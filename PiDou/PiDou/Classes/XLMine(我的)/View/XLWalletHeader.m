//
//  XLWalletHeader.m
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLWalletHeader.h"


@interface XLWalletHeader ()

@property (nonatomic, strong) UILabel *titleL;

@end

@implementation XLWalletHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.titleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleL];
    [self.titleL xl_setTextColor:XL_COLOR_BLACK fontSize:14.f];
    self.titleL.text = @"充值方式";
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(16 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView).mas_offset(-8 * kWidthRatio6s);
        make.height.mas_offset(20 * kWidthRatio6s);
    }];
    
}

@end
