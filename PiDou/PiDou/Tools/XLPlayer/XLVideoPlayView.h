//
//  XLVideoPlayView.h
//  CBNReporterVideo
//
//  Created by kevin on 24/8/18.
//  Copyright © 2018年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XLPlayState) {
    XLPlayStatePlaying = 0,
    XLPlayStatePause,
    XLPlayStateEnd
};

@class XLVideoPlayView;
@protocol XLVideoPlayViewDelegate <NSObject>

- (void)playView:(XLVideoPlayView *)playView updateRecordState:(XLPlayState)recordState;
- (void)didClicPlayView:(XLVideoPlayView *)playView;

@end

@interface XLVideoPlayView : UIView

- (instancetype)initVideoPlayViewWithURL:(NSURL *)url;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, weak) id <XLVideoPlayViewDelegate> delegate;

/**播放状态*/
@property (nonatomic, assign) XLPlayState playState;
/**是否在播放*/
@property (nonatomic, assign, readonly) BOOL isPlaying;

- (void)startPlay;
- (void)resumePlay;
- (void)pausePlay;
- (void)stopPlay;

- (void)clearPlay;

@end
