//
//  XLVerityBtn.m
//  TG
//
//  Created by kevin on 31/7/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLVerityBtn.h"

@interface XLVerityBtn ()

@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation XLVerityBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    //[self xl_setTitle:@"获取验证码" color:xl_COLOR_BLACK size:12.f target:self action:@selector(getCode)];
    [self xl_setTitle:@"获取验证码" color:XL_COLOR_RED size:16.f];
    [self setTitleColor:XL_COLOR_DARKGRAY forState:(UIControlStateDisabled)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.xl_x = self.xl_w - self.titleLabel.xl_w;
}

- (void)getCode {
    self.enabled = NO;
    self.timeCount = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
}

- (void)countDown {
    if (self.timeCount != 1) {
        self.timeCount--;
        self.enabled = NO;
        
        [self setTitle:[NSString stringWithFormat:@"(%lds)重新获取", (long)self.timeCount] forState:UIControlStateNormal];
    } else {
        [self reset];
    }
}

- (void)reset {
    self.enabled = YES;
    [self setTitle:@"重新获取" forState:UIControlStateNormal];
    [self setTitleColor:XL_COLOR_RED forState:(UIControlStateNormal)];
    // 停掉定时器
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    // 停掉定时器
    [self.timer invalidate];
    self.timer = nil;
}

@end
