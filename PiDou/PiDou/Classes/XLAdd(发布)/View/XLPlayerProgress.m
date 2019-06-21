//
//  XLPlayerProgress.m
//  PiDou
//
//  Created by ice on 2019/4/17.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPlayerProgress.h"


@interface XLPlayerProgress ()

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *fromTimeL;
@property (nonatomic, strong) UILabel *toTimeL;



@end

@implementation XLPlayerProgress

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.playButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.playButton];
    [self.playButton xl_setImageName:@"publish_play_white" selectImage:@"publish_pause_white" target:self action:@selector(playAction:)];
    
    self.fromTimeL = [[UILabel alloc] init];
    [self addSubview:self.fromTimeL];
    [self.fromTimeL xl_setTextColor:[UIColor whiteColor] fontSize:14.f];
    self.fromTimeL.text = @"00:00";
    
    self.toTimeL = [[UILabel alloc] init];
    [self addSubview:self.toTimeL];
    [self.toTimeL xl_setTextColor:[UIColor whiteColor] fontSize:14.f];
    self.toTimeL.text = @"00:00";
    
    self.progress = [[XLRecordProgress alloc] init];
    [self addSubview:self.progress];
    
    // slider开始滑动事件
    [self.progress addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.progress addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.progress addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    [self initLayout];
}

- (void)initLayout {
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).mas_offset(6 * kWidthRatio6s);
        make.width.height.mas_offset(24 * kWidthRatio6s);
    }];
    
    [self.fromTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right);
        make.centerY.equalTo(self.playButton);
    }];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fromTimeL.mas_right).mas_offset(10 * kWidthRatio6s);
        //make.centerY.equalTo(self);
        make.height.mas_offset(10 * kWidthRatio6s);
        make.right.equalTo(self.toTimeL.mas_left).mas_offset(-10 * kWidthRatio6s);
        make.top.equalTo(self).mas_offset(19 * kWidthRatio6s);
    }];
    
    [self.toTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-15 * kWidthRatio6s);
        make.centerY.equalTo(self.fromTimeL);
    }];
}

- (void)playAction:(UIButton *)button {
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(playerProgress:play:)]) {
        [_delegate playerProgress:self play:button.selected];
    }
}

- (void)setCurrentTime:(NSInteger)currentTime {
    _currentTime = currentTime;
    // 更新当前播放时间
    NSInteger hour = currentTime / 3600;
    NSInteger minute = currentTime % 3600 / 60;
    NSInteger second = currentTime % 60;
     NSString *time = @"00:00";
    if (hour) {
        time = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",hour,minute,second];
    } else {
        time = [NSString stringWithFormat:@"%.2ld:%.2ld",minute,second];
    }
    self.fromTimeL.text = [NSString stringWithFormat:@"%@", time];
}

- (void)setTotalTime:(NSInteger)totalTime {
    _totalTime = totalTime;
    // 更新当前播放时间
    NSInteger hour = _totalTime / 3600;
    NSInteger minute = _totalTime % 3600 / 60;
    NSInteger second = _totalTime % 60;
    NSString *time = @"00:00";
    if (hour) {
        time = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",hour,minute,second];
    } else {
        time = [NSString stringWithFormat:@"%.2ld:%.2ld",minute,second];
    }
    self.toTimeL.text = [NSString stringWithFormat:@"%@", time];
}

#pragma mark - progress
// 点击开始滑动
- (void)progressSliderTouchBegan:(XLRecordProgress *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(progressSliderTouchBegan:)]) {
        [_delegate progressSliderTouchBegan:self];
    }
}
// 滑动中
- (void)progressSliderValueChanged:(XLRecordProgress *)slider {
    if (_delegate && [_delegate respondsToSelector:@selector(progressSliderValueChanged:)]) {
        [_delegate progressSliderValueChanged:self];
    }
}
// 滑动结束
- (void)progressSliderTouchEnded:(XLRecordProgress *)slider {
    if (_delegate && [_delegate respondsToSelector:@selector(progressSliderTouchEnded:)]) {
        [_delegate progressSliderTouchEnded:self];
    }
}


- (void)setPlaying:(BOOL)playing {
    _playing = playing;
    self.playButton.selected = _playing;
}

@end
