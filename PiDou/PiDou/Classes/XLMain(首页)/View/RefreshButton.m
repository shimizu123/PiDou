//
//  RefreshView.m
//  PiDou
//
//  Created by 邓康大 on 2019/7/20.
//  Copyright © 2019 ice. All rights reserved.
//

#import "RefreshButton.h"

@interface RefreshButton ()

@end

@implementation RefreshButton

+ (instancetype)refreshButton {
    CGFloat width = 40 * kWidthRatio6s;
    return [[self alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - width - 10 * kWidthRatio6s, SCREEN_HEIGHT - XL_TABBAR_H - 60 * kWidthRatio6s, width, width)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self xl_setImageName:@"refresh" target:self action:@selector(refresh)];
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)removeView {
    [self removeFromSuperview];
}

- (void)refresh {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doubleClickHomeTabBarItem" object:nil];
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.toValue = [NSNumber numberWithFloat:-M_PI * 2];
    rotation.duration = 0.8;
    rotation.cumulative = YES;
    [self.layer addAnimation:rotation forKey:@"rotation"];
}

@end
