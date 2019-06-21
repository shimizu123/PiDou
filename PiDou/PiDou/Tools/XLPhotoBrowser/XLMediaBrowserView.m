//
//  XLMediaBrowserView.m
//  CBNReporterVideo
//
//  Created by kevin on 10/1/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMediaBrowserView.h"
#import <AVFoundation/AVFoundation.h>
#import "XLRecordProgress.h"

typedef NS_ENUM(NSInteger, XLPlayState) {
    XLPlayStatePlaying = 0,
    XLPlayStatePause,
    XLPlayStateEnd
};

@interface XLMediaBrowserView ()

/** 播放属性 */
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

/**是否在播放*/
@property (nonatomic, assign, readwrite) BOOL isPlaying;
@property (nonatomic, strong) XLRecordProgress *progress;

@property (nonatomic, strong) id timeObserve;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign) BOOL isDragged;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat sliderLastValue;

@property (nonatomic, assign) UIInterfaceOrientation currentDirection;

/**播放状态*/
@property (nonatomic, assign) XLPlayState playState;

@end

@implementation XLMediaBrowserView

- (instancetype)initVideoPlayViewWithURL:(NSURL *)url {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.url = url;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.progress = [[XLRecordProgress alloc] init];
    [self addSubview:self.progress];
    
    /**手势冲突不做slider手势，如果以后要做，只要打开下面三个slider手势注释，然后调整下XLPhotoBrowser.scrollview滑动即可*/
    // slider开始滑动事件
//    [self.progress addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
//    // slider滑动中事件
//    [self.progress addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    // slider结束滑动事件
//    [self.progress addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    
    [self initLayout];
}

- (void)initLayout {
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(345 * kWidthRatio6s);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).mas_offset(-XL_LEFT_DISTANCE - XL_HOME_INDICATOR_H);
        make.height.mas_offset(15 * kWidthRatio6s);
    }];
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
    
    [self bringSubviewToFront:self.progress];
    
    
    NSUInteger duration = movieAsset.duration.value / movieAsset.duration.timescale; // 获取视频总时长,单位秒
    
    // 添加播放进度计时器
    [self createTimerWithDuration:duration];
}

- (void)playingEnd:(NSNotification *)notification {
    if (!self.isDragged) {
        [self stopPlay];
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
}

#pragma mark - 暂停
- (void)pausePlay {
    if (self.isPlaying) {
        [_player pause];
        self.isPlaying = NO;
        self.playState = XLPlayStatePause;
    }
}

#pragma mark - 停止
- (void)stopPlay {
    if (self.isPlaying) {
        [_player pause];
        self.isPlaying = NO;
        self.playState = XLPlayStateEnd;
    }
    [self clearPlay];
}

- (void)clearPlay {
    self.progress.value = 0;
}


#pragma mark - progress
// 点击开始滑动
- (void)progressSliderTouchBegan:(XLRecordProgress *)sender {
    [self pausePlay];
}
// 滑动中
- (void)progressSliderValueChanged:(XLRecordProgress *)slider {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isDragged = YES;
        BOOL style = false;
        CGFloat value   = slider.value - self.sliderLastValue;
        if (value > 0) { style = YES; }
        if (value < 0) { style = NO; }
        if (value == 0) { return; }
        
        self.sliderLastValue  = slider.value;
        
        CGFloat totalTime     = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        //计算出拖动的当前秒数
        CGFloat dragedSeconds = floorf(totalTime * slider.value);
        
        //转换成CMTime才能给player来控制播放进度
        //        CMTime dragedCMTime   = CMTimeMake(dragedSeconds, 1);
        
        [self playerDraggedTime:dragedSeconds totalTime:totalTime isForward:style];
        
        // 播放过程中画面进行变化，如果不需要画面进行变化，则可以将下面方法放到progressSliderTouchEnded里面
        // 视频总时间长度
        //        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        //计算出拖动的当前秒数
        //        NSInteger dragedSeconds = floorf(total * slider.value);
        [self seekToTime:dragedSeconds completionHandler:nil];
    }else { // player状态加载失败
        // 此时设置slider值为0
        slider.value = 0;
    }
}
// 滑动结束
- (void)progressSliderTouchEnded:(XLRecordProgress *)slider {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isDragged = NO;
        [self resumePlay];
    }
}

// 滑动（拖拽）过程中变化
- (void)playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd {
    CGFloat draggedValue = (CGFloat)draggedTime / (CGFloat)totalTime;
    
    [self updateProgressWithCurrentTime:draggedTime progress:draggedValue];
    
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
        [self updateProgressWithCurrentTime:currentTime progress:value];
    }
}

#pragma mark - 更新slider,更新当前播放时间
- (void)updateProgressWithCurrentTime:(NSInteger)currentTime progress:(CGFloat)progress {
    // 更新slider
    self.progress.value = progress;
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

@end
