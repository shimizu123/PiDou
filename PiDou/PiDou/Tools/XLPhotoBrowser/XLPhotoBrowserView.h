//
//  XLPhotoBrowserView.h
//  CBNReporterVideo
//
//  Created by kevin on 9/1/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLMediaBrowserView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLPhotoBrowserView : UIView

@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) XLMediaBrowserView *mediaBrowserView;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, assign) CGSize zoomImageSize;
@property (nonatomic, assign) CGPoint scrollOffset;
@property (nonatomic, assign) BOOL isFullWidthForLandScape;

@property (nonatomic, strong) void(^scrollViewDidScroll)(CGPoint offset);
@property (nonatomic, copy) void(^scrollViewWillEndDragging)(CGPoint velocity,CGPoint offset);//返回scrollView滚动速度
@property (nonatomic, copy) void(^scrollViewDidEndDecelerating)(void);

@end

NS_ASSUME_NONNULL_END
