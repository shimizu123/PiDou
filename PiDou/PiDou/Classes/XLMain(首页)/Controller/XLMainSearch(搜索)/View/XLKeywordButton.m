//
//  XLKeywordButton.m
//  XLReporterVideo
//
//  Created by kevin on 17/9/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import "XLKeywordButton.h"

@interface XLKeywordButton ()

@end

@implementation XLKeywordButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.titleLabel.font = [UIFont xl_fontOfSize:14.f];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:XL_COLOR_BLUE];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [self setBackgroundColor:COLOR(0xf8f8f8)];
        [self setTitleColor:COLOR(0x666666) forState:UIControlStateNormal];
    }
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    XLViewRadius(self, self.tg_h * 0.5);
}

@end
