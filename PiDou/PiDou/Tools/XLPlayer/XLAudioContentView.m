//
//  XLAudioContentView.m
//  TG
//
//  Created by kevin on 30/5/18.
//  Copyright © 2018年 YIcai. All rights reserved.
//

#import "XLAudioContentView.h"
#import "UIView+CustomControlView.h"

@interface XLAudioContentView ()

@property (nonatomic, strong) UIButton *clickButton;
@property (nonatomic, strong) UIImageView *voiceImgV;
@property (nonatomic, strong) UILabel *durationL;


@end

@implementation XLAudioContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
        // app退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        // app进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)setup {
    self.clickButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:self.clickButton];
    self.clickButton.backgroundColor = XL_COLOR_BLACK;
    [self.clickButton addTarget:self action:@selector(playVoiceAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    self.voiceImgV = [[UIImageView alloc] init];
    [self addSubview:self.voiceImgV];
    
    self.durationL = [[UILabel alloc] init];
    [self addSubview:self.durationL];
    [self.durationL xl_setTextColor:[UIColor whiteColor] fontSize:16.f];
    
    
    
    [self initLayout];
}

- (void)initLayout {
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.voiceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.clickButton);
        make.left.equalTo(self.clickButton).mas_equalTo(13 * kWidthRatio6s);
        make.width.mas_equalTo(14 * kWidthRatio6s);
        make.height.mas_equalTo(18 * kWidthRatio6s);
    }];
    
    [self.durationL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceImgV.mas_right).mas_equalTo(XL_LEFT_DISTANCE);
        make.centerY.equalTo(self.clickButton);
        make.right.equalTo(self.clickButton);
    }];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    XLViewRadius(self.clickButton, self.xl_h * 0.5);
}
#pragma mark - 点击语音播放
- (void)playVoiceAction:(UIButton *)btn {
    self.clickButton.enabled = NO;
    /** 重播按钮事件 */
    if (!self.voiceImgV.isAnimating) {
        [self repeatBtnClick:nil];
    } else {
        [self.voiceImgV stopAnimating];
        self.voiceImgV.image = [UIImage imageNamed:@"answerAudio-3"];
        
        if ([self.delegate respondsToSelector:@selector(zf_controlView:playAction:)]) {
            [self.delegate zf_controlView:self playAction:nil];
        }
    }
    self.clickButton.enabled = YES;
}

#pragma mark - 重播
- (void)repeatBtnClick:(UIButton *)sender {
    // 重置控制层View
    [self zf_playerResetControlView];
    [self zf_playerShowControlView];
    if (_assistant && [_assistant respondsToSelector:@selector(audioContentViewRepeatPlay)]) {
        [_assistant audioContentViewRepeatPlay];
    }
//    if ([self.delegate respondsToSelector:@selector(zf_controlView:repeatPlayAction:)]) {
//        [self.delegate zf_controlView:self repeatPlayAction:sender];
//    }
}

/**
 * 开始播放（用来隐藏placeholderImageView）
 */
- (void)zf_playerItemPlaying {
    if (CGRectEqualToRect(self.frame,CGRectZero)) {
        return;
    }
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"answerAudio-%d",i+1]];
        
        [images addObject:img];
    }
    self.voiceImgV.animationImages = images;
    self.voiceImgV.animationDuration = 1.5;
    self.voiceImgV.animationRepeatCount = 0;
    [self.voiceImgV startAnimating];
}
/**
 * 播放完了
 */
- (void)zf_playerPlayEnd {
    [self.voiceImgV stopAnimating];
    self.voiceImgV.image = [UIImage imageNamed:@"answerAudio-3"];
}

- (void)setVideolen:(NSInteger)videolen {
    _videolen = videolen;
    if (_videolen > 0) {
        NSInteger m = _videolen / 60;
        NSInteger s = _videolen % 60;
        if (m) {
            if (s) {
                self.durationL.text = [NSString stringWithFormat:@"%ld'%ld\"",m,s];
            } else {
                self.durationL.text = [NSString stringWithFormat:@"%ld'",m];
            }
        } else {
            self.durationL.text = [NSString stringWithFormat:@"%ld\"",s];
        }
        
    } else {
        self.durationL.text = @"审核中";
    }
}


/** 小屏播放 */
- (void)zf_playerBottomShrinkPlay {
    // 不限时小屏幕
    [self zf_playerHideControlView];
}


/**
 *  回到cell显示
 */
- (void)zf_playerCellPlay {
    [self zf_playerShowControlView];
}


/**
 *  显示控制层
 */
- (void)zf_playerShowControlView {
    self.hidden = NO;
    self.superview.hidden = NO;
}

/**
 *  隐藏控制层
 */
- (void)zf_playerHideControlView {
    self.hidden = YES;
    self.superview.hidden = YES;
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    [self zf_playerCancelAutoFadeOutControlView];
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    [self zf_playerShowControlView];
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

@end
