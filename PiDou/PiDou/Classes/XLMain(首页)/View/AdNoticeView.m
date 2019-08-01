//
//  AdNoticeView.m
//  PiDou
//
//  Created by 邓康大 on 2019/7/15.
//  Copyright © 2019 ice. All rights reserved.
//

#import "AdNoticeView.h"

@interface AdNoticeView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *nextWatch;
@property (nonatomic, strong) UIButton *watchVideo;

@end

@implementation AdNoticeView
singleton_m(AdNoticeView)

+ (instancetype)adNoticeView {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
    self.backgroundColor = COLOR_A(0x000000, 0.4);
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300 * kWidthRatio6s) / 2, (SCREEN_HEIGHT - 100 * kWidthRatio6s) / 2, 300 * kWidthRatio6s, 100 * kWidthRatio6s)];
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = UIColor.whiteColor;
    XLViewRadius(self.contentView, 5 * kWidthRatio6s);
    
    self.label = [[UILabel alloc] init];
    [self.contentView addSubview:self.label];
    [self.label xl_setTextColor:XL_COLOR_DARKBLACK fontSize:14.f];
    self.label.text = @"您已点赞次数超过每天限制个数，观看视频可免费获得3个点赞次数";
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.numberOfLines = 0;
    
    self.nextWatch = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.nextWatch];
    [self.nextWatch xl_setTitle:@"下次再看" color:UIColor.whiteColor size:11.f];
    self.nextWatch.backgroundColor = XL_COLOR_DARKGRAY;
    [self.nextWatch addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
    XLViewRadius(self.nextWatch, 10 * kWidthRatio6s);
    
    self.watchVideo = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:self.watchVideo];
    [self.watchVideo xl_setTitle:@"观看视频" color:UIColor.whiteColor size:11.f];
    self.watchVideo.backgroundColor = XL_COLOR_DARKGRAY;
    [self.watchVideo addTarget:self action:@selector(watchRewardVideo) forControlEvents:UIControlEventTouchUpInside];
    XLViewRadius(self.watchVideo, 10 * kWidthRatio6s);
    
    [self initLayout];
}

- (void)initLayout {
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(30 * kWidthRatio6s);
        make.right.equalTo(self.contentView).mas_offset(-30 * kWidthRatio6s);
        make.top.equalTo(self.contentView).mas_offset(10 * kWidthRatio6s);
        make.height.mas_offset(34 * kWidthRatio6s);
    }];
    
    [self.nextWatch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(30 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView).mas_offset(-11 * kWidthRatio6s);
        make.width.mas_offset(70 * kWidthRatio6s);
        make.height.mas_offset(20 * kWidthRatio6s);
    }];
    
    [self.watchVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).mas_offset(-30 * kWidthRatio6s);
        make.bottom.equalTo(self.contentView).mas_offset(-11 * kWidthRatio6s);
        make.width.mas_offset(70 * kWidthRatio6s);
        make.height.mas_offset(20 * kWidthRatio6s);
    }];
}

- (void)show {
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (void)watchRewardVideo {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rewardVideo" object:nil];
}

- (void)setIsCommunity:(BOOL)isCommunity {
    _isCommunity = isCommunity;
    self.label.text = _isCommunity ? @"观看视频之后才可参与回馈" : @"您已点赞次数超过每天限制个数，观看视频可免费获得3个点赞次数";
    self.label.textAlignment = NSTextAlignmentCenter;
}

@end
