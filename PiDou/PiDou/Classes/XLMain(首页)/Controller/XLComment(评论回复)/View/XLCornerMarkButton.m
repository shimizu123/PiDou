//
//  XLCornerMarkButton.m
//  PiDou
//
//  Created by ice on 2019/4/8.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLCornerMarkButton.h"

@implementation XLCornerMarkButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setTitleColor:XL_COLOR_BLACK forState:(UIControlStateNormal)];
    self.titleLabel.font = [UIFont xl_fontOfSize:12.f];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, self.xl_h - 27, 0);
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

@end
