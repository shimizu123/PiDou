//
//  XLTopBotButton.m
//  TG
//
//  Created by kevin on 21/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLTopBotButton.h"



@implementation XLTopBotButton

- (CGFloat)interitemSpacing {
    if (!_interitemSpacing) {
        _interitemSpacing = 10 * kWidthRatio6s;
    }
    return _interitemSpacing;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    CGFloat x = (self.xl_w - self.imageView.xl_w) * 0.5;
    self.imageView.xl_x = x;

    CGFloat y = (self.xl_h - self.imageView.xl_h - (self.titleLabel.font.pointSize + 1) - self.interitemSpacing) * 0.5;
    self.imageView.xl_y = y;

    self.titleLabel.xl_x = 0;
    self.titleLabel.xl_w = self.xl_w;
    self.titleLabel.xl_y = CGRectGetMaxY(self.imageView.frame) + self.interitemSpacing;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
//    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
}

@end
