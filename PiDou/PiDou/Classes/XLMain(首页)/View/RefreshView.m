//
//  RefreshView.m
//  PiDou
//
//  Created by 邓康大 on 2019/7/20.
//  Copyright © 2019 ice. All rights reserved.
//

#import "RefreshView.h"

@interface RefreshView ()
@property (nonatomic, strong) UIButton *refreshButton;
@end

@implementation RefreshView

+ (instancetype)refreshView {
    CGFloat width = 40 * kWidthRatio6s;
    return [[self alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - width - 8 * kWidthRatio6s, SCREEN_HEIGHT - XL_TABBAR_H - 10 * kWidthRatio6s, width, width)];
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
    self.refreshButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.refreshButton];
    [self.refreshButton xl_setImageName:@"" target:self action:@selector(refresh)];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)removeView {
    [self removeFromSuperview];
}

- (void)refresh {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doubleClickHomeTabBarItem" object:nil];
}

@end
