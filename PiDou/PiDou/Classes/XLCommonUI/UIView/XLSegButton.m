//
//  XLSegButton.m
//  TG
//
//  Created by kevin on 26/7/2017.
//  Copyright © 2017 YIcai. All rights reserved.
//

#import "XLSegButton.h"

@implementation XLSegButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:XL_COLOR_RED forState:(UIControlStateSelected)];
        [self setTitleColor:XL_COLOR_DARKGRAY forState:(UIControlStateNormal)];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return self;
}

@end
