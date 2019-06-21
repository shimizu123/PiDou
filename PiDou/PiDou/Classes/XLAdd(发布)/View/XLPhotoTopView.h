//
//  XLPhotoTopView.h
//  PiDou
//
//  Created by ice on 2019/4/17.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import "HXPhotoManager.h"
#import "HXPhotoView.h"
#if __has_include(<SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#elif __has_include("UIImageView+WebCache.h")
#import "UIImageView+WebCache.h"
#endif

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYWebImage.h>
#elif __has_include("YYWebImage.h")
#import "YYWebImage.h"
#elif __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYKit.h>
#elif __has_include("YYKit.h")
#import "YYKit.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@class XLPhotoTopView;
@protocol XLPhotoTopViewDelegate <NSObject>

- (void)onCloseWithPhotoTopView:(XLPhotoTopView *)photoTopView;
- (void)onNextWithPhotoTopView:(XLPhotoTopView *)photoTopView;
- (void)onEditWithPhotoTopView:(XLPhotoTopView *)photoTopView;

@end

@interface XLPhotoTopView : UIView

@property (nonatomic, weak) id <XLPhotoTopViewDelegate> delegate;

@property (strong, nonatomic) HXPhotoModel *model;

#if HasYYKitOrWebImage
@property (strong, nonatomic) YYAnimatedImageView *animatedImageView;
#endif

@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic, readonly) AVPlayerLayer *playerLayer;
@property (strong, nonatomic, readonly) UIImage *gifImage;
@property (strong, nonatomic, readonly) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *videoPlayBtn;
@property (assign, nonatomic) CGFloat zoomScale;
@property (assign, nonatomic) BOOL dragging;
@property (strong, nonatomic) AVAsset *avAsset;
@property (nonatomic, copy) void (^cellTapClick)(void);
@property (nonatomic, copy) void (^cellDidPlayVideoBtn)(BOOL play);
@property (nonatomic, copy) void (^cellDownloadICloudAssetComplete)(XLPhotoTopView *myCell);
@property (nonatomic, copy) void (^cellDownloadImageComplete)(XLPhotoTopView *myCell);
- (void)againAddImageView;
- (void)refreshImageSize;
- (void)resetScale:(BOOL)animated;
- (void)resetScale:(CGFloat)scale animated:(BOOL)animated;
- (void)requestHDImage;
- (void)cancelRequest;
- (CGSize)getImageSize;

- (CGFloat)getScrollViewZoomScale;
- (void)setScrollViewZoomScale:(CGFloat)zoomScale;
- (CGSize)getScrollViewContentSize;
- (void)setScrollViewContnetSize:(CGSize)contentSize;
- (CGPoint)getScrollViewContentOffset;
- (void)setScrollViewContentOffset:(CGPoint)contentOffset;

@end

NS_ASSUME_NONNULL_END
