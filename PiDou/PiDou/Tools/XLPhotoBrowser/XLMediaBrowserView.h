//
//  XLMediaBrowserView.h
//  CBNReporterVideo
//
//  Created by kevin on 10/1/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLMediaBrowserView : UIView

@property (nonatomic, strong) NSURL *url;
- (instancetype)initVideoPlayViewWithURL:(NSURL *)url;

- (void)startPlay;
- (void)resumePlay;
- (void)pausePlay;
- (void)stopPlay;

- (void)clearPlay;

@end

NS_ASSUME_NONNULL_END
