//
//  XLPlayerControlView.h
//  TG
//
//  Created by kevin on 28/9/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import <Foundation/Foundation.h>

// 播放器的几种状态
typedef NS_ENUM(NSInteger, XLPlayerState) {
    XLPlayerStateFailed,     // 播放失败
    XLPlayerStateBuffering,  // 缓冲中
    XLPlayerStatePlaying,    // 播放中
    XLPlayerStateStopped,    // 停止播放
    XLPlayerStatePause       // 暂停播放
};
@interface XLPlayerControlView : UIView

/**是否展示会退按钮*/
@property (nonatomic, assign) BOOL xl_showBackBtn;
/**是否是语音播放*/
@property (nonatomic, assign) BOOL xl_isVoice;

/** 播发器的几种状态 */
@property (nonatomic, assign) XLPlayerState xl_state;

@end
