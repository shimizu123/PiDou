//
//  XLVideoPlayView.m
//  CBNReporterVideo
//
//  Created by kevin on 24/8/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import "XLVideoPlayView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+CustomControlView.h"
#import "MMMaterialDesignSpinner.h"
#import "XLLineProgress.h"

@interface XLVideoPlayView () <UIGestureRecognizerDelegate>

/** 播放属性 */
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

/**是否在播放*/
@property (nonatomic, assign, readwrite) BOOL isPlaying;
@property (nonatomic, strong) XLLineProgress *progress;

@property (nonatomic, strong) id timeObserve;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign) BOOL isDragged;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat sliderLastValue;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIImageView *bottomImageView;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
/** 滑杆 */
@property (nonatomic, strong) ASValueTrackingSlider   *videoSlider;

@property (nonatomic, strong) UIView *kongBotView;

@property (nonatomic, strong) UIButton *bgButton;

@end

@implementation XLVideoPlayView

- (instancetype)initVideoPlayViewWithURL:(NSURL *)url {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.bgButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:self.bgButton];
    [self.bgButton addTarget:self action:@selector(didClickBg:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.playButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.playButton xl_setImageName:@"video_play_2" selectImage:@"video_pause" target:self action:@selector(playAction)];
    self.playButton.selected = NO; // 一开始播放中
    [self addSubview:self.playButton];
    
    [self addSubview:self.bottomImageView];
    
    
    [self.bottomImageView addSubview:self.currentTimeLabel];
    [self.bottomImageView addSubview:self.progressView];
    [self.bottomImageView addSubview:self.totalTimeLabel];
    [self.bottomImageView addSubview:self.videoSlider];
    
    self.kongBotView = [[UIView alloc] initWithFrame:(CGRectMake(0, self.xl_h - XL_TABBAR_H - 1, self.xl_w, 1))];
    [self addSubview:self.kongBotView];
    self.kongBotView.backgroundColor = XL_COLOR_BLACK;
    
    [XLLineProgress initLineProgressView:self.kongBotView];
    
    [self resetControlView];
    
    [self hideControlView];
    
    [self initLayout];
}

- (void)initLayout {

    
    [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_offset(210 * kWidthRatio6s);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).mas_offset(-XL_TABBAR_H);
        make.height.mas_equalTo(50);
    }];
    
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomImageView.mas_left).offset(3);
        make.centerY.equalTo(self.bottomImageView.mas_centerY);
        make.width.mas_equalTo(43);
    }];

    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomImageView.mas_right).offset(-3);
        make.centerY.equalTo(self.bottomImageView.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.bottomImageView.mas_centerY);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];
}

- (void)didClickBg:(UIButton *)button {
    [self endEditing:YES];
    button.selected = !button.selected;
    if (button.selected) {
        [self showControlView];
    } else {
        [self hideControlView];
    }
    if ([_delegate respondsToSelector:@selector(didClicPlayView:)]) {
        [_delegate didClicPlayView:self];
    }
}

- (void)resetControlView {
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.progressView.progress       = 0;
    self.videoSlider.value           = 0;
    
}

- (void)showControlView {
    self.bottomImageView.alpha = 1;
    self.playButton.alpha = 1;
    self.kongBotView.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideControlView];
    });
}

- (void)hideControlView {
    self.bottomImageView.alpha = 0;
    self.playButton.alpha = 0;
    self.kongBotView.hidden = NO;
}

- (void)initPlayer {

    if (_playerLayer) {
        [self removePlayer];
    }

    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:self.url options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.bounds;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (currentOrientation == UIInterfaceOrientationPortrait) {
        // 竖屏的时候
        
    }
    [self.layer addSublayer:_playerLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //[self bringSubviewToFront:self.progress];
    [self bringSubviewToFront:self.playButton];
    [self bringSubviewToFront:self.bottomImageView];
    [self bringSubviewToFront:self.kongBotView];
    
    NSUInteger duration = movieAsset.duration.value / movieAsset.duration.timescale; // 获取视频总时长,单位秒
    
    // 添加播放进度计时器
    [self createTimerWithDuration:duration];
}

- (void)createTimerWithDuration:(NSUInteger)duration {
    __weak typeof(self) weakSelf = self;
    CGFloat seconds = 0.01;
    if (duration > 60 * 30) {
        seconds = 1;
    } else if (duration > 60) {
        seconds = 0.1;
    }
    CMTime interval = CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC);
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime = (CGFloat)currentItem.duration.value /   currentItem.duration.timescale;
            CGFloat value = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            [weakSelf playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
        }
    }];
    
}

/**
 * 正常播放
 
 * @param currentTime 当前播放时长
 * @param totalTime   视频总时长
 * @param value       slider的value(0.0~1.0)
 */
- (void)playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {

    if (!self.isDragged) {
        [self updateProgressWithCurrentTime:currentTime totalTime:totalTime progress:value];
    }
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    if (!self.isDragged) {
        // 更新slider
        self.videoSlider.value           = value;
        // 更新当前播放时间
        self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    }
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}

#pragma mark - 更新slider,更新当前播放时间
- (void)updateProgressWithCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime progress:(CGFloat)progress {
    // 更新slider
    //self.progress.value = progress;
    [XLLineProgress setLineProgress:progress];
    // 更新当前播放时间
    NSInteger hour = currentTime / 3600;
    NSInteger minute = currentTime % 3600 / 60;
    NSInteger second = currentTime % 60;
    NSString *time = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",hour,minute,second];
    //self.timeView.timeL.text = [NSString stringWithFormat:@"%@", time];
    
    
}

- (void)playingEnd:(NSNotification *)notification {
    if (!self.isDragged) {
        [self stopPlay];
    }
}

#pragma mark - 点击播放暂停按钮
- (void)playAction {
    if (!self.playButton.selected) {
        if (self.playState == XLPlayStateEnd) {
            [self startPlay];
        } else {
            [self resumePlay];
        }
    } else {
        [self pausePlay];
    }
    
}

#pragma mark - 播放
- (void)startPlay {
    if (self.isPlaying) {
        return;
    }
    
    [self initPlayer];
    
    // 播放
    [_player play];

    self.isPlaying = YES;
    self.playState = XLPlayStatePlaying;
    self.playButton.selected = YES;
}

#pragma mark - 继续播放
- (void)resumePlay {
    if (self.isPlaying) {
        return;
    }

    // 播放
    [_player play];
    
    self.isPlaying = YES;
    self.playState = XLPlayStatePlaying;
    self.playButton.selected = YES;
}

#pragma mark - 暂停
- (void)pausePlay {
    if (self.isPlaying) {
        [_player pause];
        self.isPlaying = NO;
        self.playState = XLPlayStatePause;
        self.playButton.selected = NO;
    }
}

#pragma mark - 停止
- (void)stopPlay {
    if (self.isPlaying) {
        [_player pause];
        self.isPlaying = NO;
        self.playState = XLPlayStateEnd;
        self.playButton.selected = NO;
    }
    [self clearPlay];
}

- (void)clearPlay {
    //self.timeView.timeL.text = @"00:00:00";
    //self.progress.value = 0;
    [XLLineProgress resetProgress];
    
}

- (void)setPlayState:(XLPlayState)playState {
    _playState = playState;
    if (_delegate && [_delegate respondsToSelector:@selector(playView:updateRecordState:)]) {
        [_delegate playView:self updateRecordState:_playState];
    }
}



// 滑动（拖拽）过程中变化
- (void)playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd {
    CGFloat draggedValue = (CGFloat)draggedTime / (CGFloat)totalTime;
    
    [self updateProgressWithCurrentTime:draggedTime totalTime:totalTime progress:draggedValue];
    
    self.isDragged = YES;
    
    
}

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        [self pausePlay];
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1); //kCMTimeZero
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:dragedCMTime toleranceBefore:CMTimeMake(1,1) toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
            // 视频跳转回调
            if (completionHandler) { completionHandler(finished); }
            
//            weakSelf.seekTime = 0;
            weakSelf.isDragged = NO;
            
        }];
    }
}

- (void)removePlayer {
    [_playerLayer removeFromSuperlayer];
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    _playerLayer = nil;
    _player = nil;
    _playerItem = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removePlayer];
    
}



- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor clearColor];
    }
    return _progressView;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}


- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.alpha                  = 1;
        _bottomImageView.image                  = ZFPlayerImage(@"ZFPlayer_bottom_shadow");
    }
    return _bottomImageView;
}

- (ASValueTrackingSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[ASValueTrackingSlider alloc] init];
        _videoSlider.popUpViewCornerRadius = 0.0;
        _videoSlider.popUpViewColor = RGBA(19, 19, 9, 1);
        _videoSlider.popUpViewArrowLength = 8;
        
        [_videoSlider setThumbImage:ZFPlayerImage(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];

        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_videoSlider addGestureRecognizer:sliderTap];

        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [_videoSlider addGestureRecognizer:panRecognizer];
    }
    return _videoSlider;
}


- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender {
    [self zf_playerCancelAutoFadeOutControlView];
    self.videoSlider.popUpView.hidden = YES;

}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender {
    
}

- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender {
    //self.showing = YES;
   
}
/**
 *  UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap {
//    if ([tap.view isKindOfClass:[UISlider class]]) {
//        UISlider *slider = (UISlider *)tap.view;
//        CGPoint point = [tap locationInView:slider];
//        CGFloat length = slider.frame.size.width;
//        // 视频跳转的value
//        CGFloat tapValue = point.x / length;
//        if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTap:)]) {
//            [self.delegate zf_controlView:self progressSliderTap:tapValue];
//        }
//    }
}
// 不做处理，只是为了滑动slider其他地方不响应其他手势
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {}

@end
