//
//  XLPublishBtn.m
//  TG
//
//  Created by kevin on 7/8/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLPublishBtn.h"

@interface XLPublishBtn ()

@property (nonatomic, assign) CGRect oriFrame;

@end

@implementation XLPublishBtn


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.oriFrame = frame;
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setTitleColor:XL_COLOR_BLACK forState:(UIControlStateNormal)];
    self.titleLabel.font = [UIFont xl_fontOfSize:12.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addTarget:self action:@selector(btnTouchUpInside) forControlEvents:(UIControlEventTouchUpInside)];
    [self addTarget:self action:@selector(btnTouchDown) forControlEvents:(UIControlEventTouchDown)];
    [self addTarget:self action:@selector(btnTouchUpOutside) forControlEvents:(UIControlEventTouchUpOutside)];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.xl_x = 0;
    self.imageView.xl_y = 0;
    self.imageView.xl_w = self.xl_w;
    self.imageView.xl_h = self.xl_w;
    
    //self.titleLabel.xl_x = 0;
    //self.titleLabel.xl_w = self.xl_w;
    self.titleLabel.xl_w = self.oriFrame.size.width;
    self.titleLabel.xl_h = self.xl_h - self.imageView.xl_h;
    self.titleLabel.xl_y = self.xl_h - self.titleLabel.xl_h;
    self.titleLabel.xl_centerX = self.imageView.xl_centerX;

}

- (void)btnTouchUpInside {
    CGPoint oriCenter = self.xl_center;
    [UIView animateWithDuration:0.4 animations:^{
        self.xl_w = self.xl_w * 1.3;
        self.xl_h = self.xl_h * 1.3;
        self.xl_center = oriCenter;
        self.alpha = 0;
    }];
    
}

- (void)btnTouchDown {
    CGPoint oriCenter = self.xl_center;
    [UIView animateWithDuration:0.2 animations:^{
        self.xl_w = self.xl_w * 1.1;
        self.xl_h = self.xl_h * 1.1;
        self.xl_center = oriCenter;
    }];
}

- (void)btnTouchUpOutside {
    CGPoint oriCenter = self.xl_center;
    [UIView animateWithDuration:0.3 animations:^{
        self.xl_w = self.oriFrame.size.width;
        self.xl_h = self.oriFrame.size.height;
        self.xl_center = oriCenter;
    }];
}


@end
