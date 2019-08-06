//
//  DialogView.m
//  PiDou
//
//  Created by 邓康大 on 2019/8/6.
//  Copyright © 2019 ice. All rights reserved.
//

#import "DialogView.h"

@interface DialogView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation DialogView
singleton_m(DialogView)


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setImage:[UIImage imageNamed:@"dialog"]];
    
    self.label = [[UILabel alloc] init];
    [self addSubview:self.label];
    self.label.text = @"连续点赞\n需间隔10秒哦！";
    self.label.numberOfLines = 2;
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.label xl_setTextColor:UIColor.whiteColor fontSize:9.f];
    
    [self initLayout];
}

- (void)initLayout {
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).mas_offset(20 * kWidthRatio6s);
    }];
}

- (void)showView:(UIView *)container {
    DialogView *dialog = [[DialogView alloc] init];
    [container addSubview:dialog];
    [dialog mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).mas_offset(30 * kWidthRatio6s);
        make.bottom.equalTo(container).mas_offset(-30 * kWidthRatio6s);
    }];
    dialog.alpha = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        dialog.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            dialog.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeView];
        }];
    }];
}

- (void)removeView {
    [self removeFromSuperview];
}

@end
