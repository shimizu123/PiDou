//
//  XLPlayerProgress.h
//  PiDou
//
//  Created by ice on 2019/4/17.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLRecordProgress.h"

NS_ASSUME_NONNULL_BEGIN

@class XLPlayerProgress;
@protocol XLPlayerProgressDelegate <NSObject>

- (void)playerProgress:(XLPlayerProgress *)playerProgress play:(BOOL)play;
// 点击开始滑动
- (void)progressSliderTouchBegan:(XLPlayerProgress *)progress;
// 滑动中
- (void)progressSliderValueChanged:(XLPlayerProgress *)progress;
// 滑动结束
- (void)progressSliderTouchEnded:(XLPlayerProgress *)progress;

@end

@interface XLPlayerProgress : UIView

@property (nonatomic, weak) id <XLPlayerProgressDelegate> delegate;

@property (nonatomic, strong) XLRecordProgress *progress;

@property (nonatomic, assign) NSInteger currentTime;
@property (nonatomic, assign) NSInteger totalTime;

@property (nonatomic, assign) BOOL playing;

@end

NS_ASSUME_NONNULL_END
