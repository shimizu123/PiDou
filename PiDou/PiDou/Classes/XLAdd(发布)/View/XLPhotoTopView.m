//
//  XLPhotoTopView.m
//  PiDou
//
//  Created by ice on 2019/4/17.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPhotoTopView.h"
#import "UIButton+XLAdd.h"
#import "HXCircleProgressView.h"
#import "UIImageView+HXExtension.h"
#import "XLPlayerProgress.h"
#import "XLPhotoNaviBar.h"

@interface XLPhotoTopView ()<UIScrollViewDelegate,PHLivePhotoViewDelegate,XLPlayerProgressDelegate,XLPhotoNaviBarDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) CGPoint imageCenter;
@property (strong, nonatomic) UIImage *gifImage;
@property (strong, nonatomic) UIImage *gifFirstFrame;
@property (assign, nonatomic) PHImageRequestID requestID;
@property (assign, nonatomic) PHContentEditingInputRequestID gifRequestID;
@property (strong, nonatomic) PHLivePhotoView *livePhotoView;
@property (assign, nonatomic) BOOL livePhotoAnimating;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) HXCircleProgressView *progressView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@property (assign, nonatomic) BOOL stopCancel;



@property (nonatomic, strong) XLPhotoNaviBar *naviBar;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) XLPlayerProgress *progress;
@property (nonatomic, strong) UIView *playerBgView;

@property (nonatomic, strong) id timeObserve;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign) BOOL isDragged;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat sliderLastValue;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation XLPhotoTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.requestID = -1;
        [self setup];
        
        [self initPlayerUI];
    }
    return self;
}

- (void)setup {
    
    self.playerBgView = [[UIView alloc] init];
    [self addSubview:self.playerBgView];
    
    self.naviBar = [[XLPhotoNaviBar alloc] init];
    [self addSubview:self.naviBar];
    self.naviBar.delegate = self;
    
    self.editButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.editButton];
    [self.editButton xl_setImageName:@"publish_edit" target:self action:@selector(editAction:)];
    [self.editButton xl_setTitle:@"剪辑" color:[UIColor whiteColor] size:11.f];
    [self.editButton layoutButtonWithEdgeInsetsStyle:(XLButtonEdgeInsetsStyleTop) imageTitleSpace:4 * kWidthRatio6s];
    
    
    self.progress = [[XLPlayerProgress alloc] init];
    [self addSubview:self.progress];
    self.progress.delegate = self;
    
    [self initLayout];
    
    
}

- (void)initLayout {
    
    [self.playerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.naviBar.mas_bottom).mas_offset(30 * kWidthRatio6s);
        make.bottom.equalTo(self.progress.mas_top).mas_offset(-20 * kWidthRatio6s);
    }];
    
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_offset(XL_NAVIBAR_H);
    }];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.naviBar).mas_offset(-16 * kWidthRatio6s);
        make.centerY.equalTo(self).mas_offset(30 * kWidthRatio6s);
        make.width.height.mas_offset(40 * kWidthRatio6s);
    }];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_offset(40 * kWidthRatio6s);
    }];
   
}

#pragma mark - XLPlayerProgressDelegate
- (void)playerProgress:(XLPlayerProgress *)playerProgress play:(BOOL)play {
    [self didPlayBtnClick:self.videoPlayBtn];
}
// 点击开始滑动
- (void)progressSliderTouchBegan:(XLPlayerProgress *)progress {
    [_player pause];
    self.videoPlayBtn.selected = YES;
    self.progress.playing = YES;
}
// 滑动中
- (void)progressSliderValueChanged:(XLPlayerProgress *)progress {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isDragged = YES;
        BOOL style = false;
        CGFloat value   = progress.progress.value - self.sliderLastValue;
        if (value > 0) { style = YES; }
        if (value < 0) { style = NO; }
        if (value == 0) { return; }
        
        self.sliderLastValue  = progress.progress.value;
        
        CGFloat totalTime     = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        //计算出拖动的当前秒数
        CGFloat dragedSeconds = floorf(totalTime * progress.progress.value);
        
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
        progress.progress.value = 0;
    }
}
// 滑动结束
- (void)progressSliderTouchEnded:(XLPlayerProgress *)progress {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isDragged = NO;
        [_player play];
        self.videoPlayBtn.selected = YES;
        self.progress.playing = YES;
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
        [self.player pause];
        
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

#pragma mark - XLPhotoNaviBarDelegate
- (void)didCloseWithPhotoNaviBar:(XLPhotoNaviBar *)photoNaviBar {
    if (_delegate && [_delegate respondsToSelector:@selector(onCloseWithPhotoTopView:)]) {
        [_delegate onCloseWithPhotoTopView:self];
    }
}
- (void)didNextWithPhotoNaviBar:(XLPhotoNaviBar *)photoNaviBar {
    if (_delegate && [_delegate respondsToSelector:@selector(onNextWithPhotoTopView:)]) {
        [_delegate onNextWithPhotoTopView:self];
    }
}


#pragma mark - 点击编辑
- (void)editAction:(UIButton *)button {
    XLLog(@"点击编辑");
    if (_delegate && [_delegate respondsToSelector:@selector(onEditWithPhotoTopView:)]) {
        [_delegate onEditWithPhotoTopView:self];
    }
}

- (void)initPlayerUI {
    [self.playerBgView addSubview:self.scrollView];
#if HasYYKitOrWebImage
    [self.scrollView addSubview:self.animatedImageView];
#else
    [self.scrollView addSubview:self.imageView];
#endif
    [self.playerBgView.layer addSublayer:self.playerLayer];
    [self.playerBgView addSubview:self.videoPlayBtn];
    [self.playerBgView addSubview:self.progressView];
    [self.playerBgView addSubview:self.loadingView];
}
- (CGFloat)getScrollViewZoomScale {
    return self.scrollView.zoomScale;
}
- (void)setScrollViewZoomScale:(CGFloat)zoomScale {
    [self.scrollView setZoomScale:zoomScale];
}
- (CGSize)getScrollViewContentSize {
    return self.scrollView.contentSize;
}
- (void)setScrollViewContnetSize:(CGSize)contentSize {
    [self.scrollView setContentSize:contentSize];
}
- (CGPoint)getScrollViewContentOffset {
    return self.scrollView.contentOffset;
}
- (void)setScrollViewContentOffset:(CGPoint)contentOffset {
    [self.scrollView setContentOffset:contentOffset];
}
- (void)resetScale:(BOOL)animated {
    if (self.model.type != HXPhotoModelMediaTypePhotoGif) {
        self.gifImage = nil;
    }
    [self resetScale:1.0f animated:animated];
}
- (void)resetScale:(CGFloat)scale animated:(BOOL)animated {
    [self.scrollView setZoomScale:scale animated:animated];
}
- (void)againAddImageView {
    [self refreshImageSize];
    [self.scrollView setZoomScale:1.0f];
#if HasYYKitOrWebImage
    [self.scrollView addSubview:self.animatedImageView];
#else
    [self.scrollView addSubview:self.imageView];
#endif
    if (self.model.subType == HXPhotoModelMediaSubTypeVideo) {
        self.videoPlayBtn.hidden = NO;
        [self.layer addSublayer:self.playerLayer];
        [self.playerBgView addSubview:self.videoPlayBtn];
        self.videoPlayBtn.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.videoPlayBtn.alpha = 1;
        }];
    }
}
- (CGSize)getImageSize {
    CGFloat width = self.playerBgView.frame.size.width;
    CGFloat height = self.playerBgView.frame.size.height;
    CGFloat imgWidth = self.model.imageSize.width;
    CGFloat imgHeight = self.model.imageSize.height;
    CGFloat w;
    CGFloat h;
    
    imgHeight = width / imgWidth * imgHeight;
    if (imgHeight > height) {
        w = height / self.model.imageSize.height * imgWidth;
        h = height;
    }else {
        w = width;
        h = imgHeight;
    }
    return CGSizeMake(w, h);
}
- (void)refreshImageSize {
    CGFloat width = self.playerBgView.frame.size.width;
    CGFloat height = self.playerBgView.frame.size.height;
    CGFloat imgWidth = self.model.imageSize.width;
    CGFloat imgHeight = self.model.imageSize.height;
    CGFloat w;
    CGFloat h;
    
    imgHeight = width / imgWidth * imgHeight;
    if (imgHeight > height) {
        w = height / self.model.imageSize.height * imgWidth;
        h = height;
        self.scrollView.maximumZoomScale = width / w + 0.5;
    }else {
        w = width;
        h = imgHeight;
        self.scrollView.maximumZoomScale = 2.5;
    }
#if HasYYKitOrWebImage
    self.animatedImageView.frame = CGRectMake(0, 0, w, h);
    self.animatedImageView.center = CGPointMake(width / 2, height / 2);
    self.playerLayer.frame = self.animatedImageView.frame;
#else
    self.imageView.frame = CGRectMake(0, 0, w, h);
    self.imageView.center = CGPointMake(width / 2, height / 2);
    self.playerLayer.frame = self.imageView.frame;
#endif
    self.videoPlayBtn.frame = self.playerLayer.frame;
}
- (void)setModel:(HXPhotoModel *)model {
    _model = model;
    [self cancelRequest];
    self.playerLayer.player = nil;
    self.player = nil;
    self.playerItem = nil;
    self.progressView.hidden = YES;
    [self.loadingView stopAnimating];
    self.progressView.progress = 0;
    
    [self resetScale:NO];
    
    CGFloat width = self.playerBgView.frame.size.width;
    CGFloat height = self.playerBgView.frame.size.height;
    CGFloat imgWidth = self.model.imageSize.width;
    CGFloat imgHeight = self.model.imageSize.height;
    CGFloat w;
    CGFloat h;
    
    imgHeight = width / imgWidth * imgHeight;
    if (imgHeight > height) {
        w = height / self.model.imageSize.height * imgWidth;
        h = height;
        self.scrollView.maximumZoomScale = width / w + 0.5;
    }else {
        w = width;
        h = imgHeight;
        self.scrollView.maximumZoomScale = 2.5;
    }
#if HasYYKitOrWebImage
    self.animatedImageView.frame = CGRectMake(0, 0, w, h);
    self.animatedImageView.center = CGPointMake(width / 2, height / 2);
    self.playerLayer.frame = self.animatedImageView.frame;
    self.videoPlayBtn.frame = self.playerLayer.frame;
    self.animatedImageView.hidden = NO;
#else
    self.imageView.frame = CGRectMake(0, 0, w, h);
    self.imageView.center = CGPointMake(width / 2, height / 2);
    self.playerLayer.frame = self.imageView.frame;
    self.videoPlayBtn.frame = self.playerLayer.frame;
    self.imageView.hidden = NO;
#endif
    HXWeakSelf
    if (model.type == HXPhotoModelMediaTypeCameraPhoto || model.type == HXPhotoModelMediaTypeCameraVideo) {
        if (model.networkPhotoUrl) {
            self.progressView.hidden = model.downloadComplete;
            CGFloat progress = (CGFloat)model.receivedSize / model.expectedSize;
            self.progressView.progress = progress;
#if HasYYKitOrWebImage
            [self.animatedImageView hx_setImageWithModel:model progress:^(CGFloat progress, HXPhotoModel *model) {
                if (weakSelf.model == model) {
                    weakSelf.progressView.progress = progress;
                }
            } completed:^(UIImage *image, NSError *error, HXPhotoModel *model) {
                if (weakSelf.model == model) {
                    if (error != nil) {
                        [weakSelf.progressView showError];
                    }else {
                        if (image) {
                            if (weakSelf.cellDownloadImageComplete) weakSelf.cellDownloadImageComplete(weakSelf);
                            weakSelf.progressView.progress = 1;
                            weakSelf.progressView.hidden = YES;
                            weakSelf.animatedImageView.image = image;
                            [weakSelf refreshImageSize];
                        }
                    }
                }
            }];
#else
            [self.imageView hx_setImageWithModel:model progress:^(CGFloat progress, HXPhotoModel *model) {
                if (weakSelf.model == model) {
                    weakSelf.progressView.progress = progress;
                }
            } completed:^(UIImage *image, NSError *error, HXPhotoModel *model) {
                if (weakSelf.model == model) {
                    if (error != nil) {
                        [weakSelf.progressView showError];
                    }else {
                        if (image) {
                            if (weakSelf.cellDownloadImageComplete) weakSelf.cellDownloadImageComplete(weakSelf);
                            weakSelf.progressView.progress = 1;
                            weakSelf.progressView.hidden = YES;
                            weakSelf.imageView.image = image;
                            [weakSelf refreshImageSize];
                        }
                    }
                }
            }];
#endif
        }else {
#if HasYYKitOrWebImage
            self.animatedImageView.image = model.thumbPhoto;
#else
            self.imageView.image = model.thumbPhoto;
#endif
            model.tempImage = nil;
        }
    }else {
        if (model.type == HXPhotoModelMediaTypeLivePhoto) {
            if (model.tempImage) {
#if HasYYKitOrWebImage
                self.animatedImageView.image = model.tempImage;
#else
                self.imageView.image = model.tempImage;
#endif
                model.tempImage = nil;
            }else {
                self.requestID = [model requestThumbImageWithSize:CGSizeMake(self.hx_w * 0.5, self.hx_h * 0.5) completion:^(UIImage *image, HXPhotoModel *model, NSDictionary *info) {
                    if (weakSelf.model != model) return;
#if HasYYKitOrWebImage
                    weakSelf.animatedImageView.image = image;
#else
                    weakSelf.imageView.image = image;
#endif
                }];
            }
        }else {
            if (model.previewPhoto) {
#if HasYYKitOrWebImage
                self.animatedImageView.image = model.previewPhoto;
#else
                self.imageView.image = model.previewPhoto;
#endif
                model.tempImage = nil;
            }else {
                if (model.tempImage) {
#if HasYYKitOrWebImage
                    self.animatedImageView.image = model.tempImage;
#else
                    self.imageView.image = model.tempImage;
#endif
                    model.tempImage = nil;
                }else {
                    CGSize requestSize;
                    if (imgHeight > imgWidth / 9 * 20 ||
                        imgWidth > imgHeight / 9 * 20) {
                        requestSize = CGSizeMake(self.hx_w * 0.6, self.hx_h * 0.6);
                    }else {
                        requestSize = CGSizeMake(model.endImageSize.width, model.endImageSize.height);
                    }
                    self.requestID =[model requestThumbImageWithSize:requestSize completion:^(UIImage *image, HXPhotoModel *model, NSDictionary *info) {
                        if (weakSelf.model != model) return;
#if HasYYKitOrWebImage
                        weakSelf.animatedImageView.image = image;
#else
                        weakSelf.imageView.image = image;
#endif
                    }];
                }
            }
        }
    }
    if (model.subType == HXPhotoModelMediaSubTypeVideo) {
        self.playerLayer.hidden = NO;
        self.videoPlayBtn.hidden = NO;
    }else {
        self.playerLayer.hidden = YES;
        self.videoPlayBtn.hidden = YES;
    }
}
- (void)requestHDImage {
    self.avAsset = nil;
    if (self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
        self.requestID = -1;
    }
    CGFloat width = self.playerBgView.frame.size.width;
    CGFloat height = self.playerBgView.frame.size.height;
    CGFloat imgWidth = self.model.imageSize.width;
    CGFloat imgHeight = self.model.imageSize.height;
    CGSize size;
    HXWeakSelf
    CGFloat scale;
    if (HX_IS_IPhoneX_All) {
        scale = 3.0f;
    }else if ([UIScreen mainScreen].bounds.size.width == 320) {
        scale = 2.0;
    }else if ([UIScreen mainScreen].bounds.size.width == 375) {
        scale = 2.5;
    }else {
        scale = 3.0;
    }
    
    if (imgHeight > imgWidth / 9 * 20 ||
        imgWidth > imgHeight / 9 * 20) {
        size = CGSizeMake(width * scale, height * scale);
    }else {
        size = CGSizeMake(self.model.endImageSize.width * scale, self.model.endImageSize.height * scale);
    }
    if (self.model.type == HXPhotoModelMediaTypeCameraPhoto) {
        if (self.model.networkPhotoUrl) {
            if (!self.model.downloadComplete) {
                self.progressView.hidden = NO;
                self.progressView.progress = (CGFloat)self.model.receivedSize / self.model.expectedSize;;
            }else if (self.model.downloadError) {
                [self.progressView showError];
            }
        }
    }else if (self.model.type == HXPhotoModelMediaTypeLivePhoto) {
        if (_livePhotoView.livePhoto) {
            [self.livePhotoView stopPlayback];
            [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
            return;
        }
        if (self.model.iCloudRequestID) {
            [[PHImageManager defaultManager] cancelImageRequest:self.model.iCloudRequestID];
            self.model.iCloudRequestID = -1;
        }
        self.requestID = [self.model requestLivePhotoWithSize:self.model.endImageSize startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            if (weakSelf.model.isICloud) {
                weakSelf.progressView.hidden = NO;
            }
            weakSelf.requestID = iCloudRequestId;
        } progressHandler:^(double progress, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            if (weakSelf.model.isICloud) {
                weakSelf.progressView.hidden = NO;
            }
            weakSelf.progressView.progress = progress;
        } success:^(PHLivePhoto *livePhoto, HXPhotoModel *model, NSDictionary *info) {
            if (weakSelf.model != model) return;
            [weakSelf downloadICloudAssetComplete];
#if HasYYKitOrWebImage
            weakSelf.livePhotoView.frame = weakSelf.animatedImageView.frame;
            weakSelf.animatedImageView.hidden = YES;
#else
            weakSelf.livePhotoView.frame = weakSelf.imageView.frame;
            weakSelf.imageView.hidden = YES;
#endif
            [weakSelf.scrollView addSubview:weakSelf.livePhotoView];
            weakSelf.livePhotoView.livePhoto = livePhoto;
            [weakSelf.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
        } failed:^(NSDictionary *info, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            weakSelf.progressView.hidden = YES;
        }];
    }else if (self.model.type == HXPhotoModelMediaTypePhoto) {
        self.requestID = [self.model requestPreviewImageWithSize:size startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            if (weakSelf.model.isICloud) {
                weakSelf.progressView.hidden = NO;
            }
            weakSelf.requestID = iCloudRequestId;
        } progressHandler:^(double progress, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            if (weakSelf.model.isICloud) {
                weakSelf.progressView.hidden = NO;
            }
            weakSelf.progressView.progress = progress;
        } success:^(UIImage *image, HXPhotoModel *model, NSDictionary *info) {
            if (weakSelf.model != model) return;
            [weakSelf downloadICloudAssetComplete];
            weakSelf.progressView.hidden = YES;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
#if HasYYKitOrWebImage
            [weakSelf.animatedImageView.layer removeAllAnimations];
            weakSelf.animatedImageView.image = image;
            [weakSelf.animatedImageView.layer addAnimation:transition forKey:nil];
#else
            [weakSelf.imageView.layer removeAllAnimations];
            weakSelf.imageView.image = image;
            [weakSelf.imageView.layer addAnimation:transition forKey:nil];
#endif
        } failed:^(NSDictionary *info, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            weakSelf.progressView.hidden = YES;
        }];
    }else if (self.model.type == HXPhotoModelMediaTypePhotoGif) {
        if (self.gifImage) {
#if HasYYKitOrWebImage
            if (self.animatedImageView.image != self.gifImage) {
                self.animatedImageView.image = self.gifImage;
            }
#else
            if (self.imageView.image != self.gifImage) {
                self.imageView.image = self.gifImage;
            }
#endif
        }else {
            self.requestID = [self.model requestImageDataStartRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel *model) {
                if (weakSelf.model != model) return;
                if (weakSelf.model.isICloud) {
                    weakSelf.progressView.hidden = NO;
                }
                weakSelf.requestID = iCloudRequestId;
            } progressHandler:^(double progress, HXPhotoModel *model) {
                if (weakSelf.model != model) return;
                if (weakSelf.model.isICloud) {
                    weakSelf.progressView.hidden = NO;
                }
                weakSelf.progressView.progress = progress;
            } success:^(NSData *imageData, UIImageOrientation orientation, HXPhotoModel *model, NSDictionary *info) {
                if (weakSelf.model != model) return;
                [weakSelf downloadICloudAssetComplete];
                weakSelf.progressView.hidden = YES;
#if HasYYKitOrWebImage
                YYImage *gifImage = [YYImage imageWithData:imageData];
                weakSelf.animatedImageView.image = gifImage;
                weakSelf.gifImage = gifImage;
#else
                UIImage *gifImage = [UIImage hx_animatedGIFWithData:imageData];
                weakSelf.imageView.image = gifImage;
                weakSelf.gifImage = gifImage;
                if (gifImage.images.count == 0) {
                    weakSelf.gifFirstFrame = gifImage;
                }else {
                    weakSelf.gifFirstFrame = gifImage.images.firstObject;
                }
#endif
                weakSelf.model.tempImage = nil;
            } failed:^(NSDictionary *info, HXPhotoModel *model) {
                if (weakSelf.model != model) return;
                weakSelf.progressView.hidden = YES;
            }];
        }
    }
    if (self.player != nil) return;
    if (self.model.subType == HXPhotoModelMediaSubTypeVideo) {
        [self.model requestAVAssetStartRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            [weakSelf.loadingView startAnimating];
            weakSelf.videoPlayBtn.hidden = YES;
            weakSelf.requestID = iCloudRequestId;
        } progressHandler:^(double progress, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            weakSelf.progressView.progress = progress;
        } success:^(AVAsset *avAsset, AVAudioMix *audioMix, HXPhotoModel *model, NSDictionary *info) {
            if (weakSelf.model != model) return;
            weakSelf.avAsset = avAsset;
            [weakSelf downloadICloudAssetComplete];
            weakSelf.progressView.hidden = YES;
            [weakSelf.loadingView stopAnimating];
            weakSelf.videoPlayBtn.hidden = NO;
            weakSelf.playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
            weakSelf.player = [AVPlayer playerWithPlayerItem:weakSelf.playerItem];
            weakSelf.playerLayer.player = weakSelf.player;
            [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:weakSelf.player.currentItem];
            NSUInteger duration = avAsset.duration.value / avAsset.duration.timescale; // 获取视频总时长,单位秒
            weakSelf.progress.totalTime = duration;
            // 添加播放进度计时器
            [weakSelf createTimerWithDuration:duration];
        } failed:^(NSDictionary *info, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            [weakSelf.loadingView stopAnimating];
            weakSelf.videoPlayBtn.hidden = NO;
            weakSelf.progressView.hidden = YES;
        }];
    }
}


#pragma mark - 添加播放定时器
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
    self.progress.progress.value = progress;
    // 更新当前播放时间
//    NSInteger hour = currentTime / 3600;
//    NSInteger minute = currentTime % 3600 / 60;
//    NSInteger second = currentTime % 60;
//    NSString *time = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",hour,minute,second];
//    self.timeView.timeL.text = [NSString stringWithFormat:@"%@", time];
    self.progress.currentTime = currentTime;
}

- (void)downloadICloudAssetComplete {
    self.progressView.hidden = YES;
    [self.loadingView stopAnimating];
    if (self.model.isICloud) {
        self.model.iCloudDownloading = NO;
        self.model.isICloud = NO;
        if (self.cellDownloadICloudAssetComplete) {
            self.cellDownloadICloudAssetComplete(self);
        }
    }
}
- (void)pausePlayerAndShowNaviBar {
    [self.player.currentItem seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}
- (void)cancelRequest {
    if (self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
        self.requestID = -1;
    }
    //    self.videoPlayBtn.hidden = YES;
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    if (self.model.type == HXPhotoModelMediaTypeLivePhoto) {
        if (_livePhotoView.livePhoto) {
            self.livePhotoView.livePhoto = nil;
            [self.livePhotoView removeFromSuperview];
#if HasYYKitOrWebImage
            self.animatedImageView.hidden = NO;
#else
            self.imageView.hidden = NO;
#endif
            [self stopLivePhoto];
        }
    }else if (self.model.type == HXPhotoModelMediaTypePhoto) {
#if HasYYWebImage
        [self.animatedImageView yy_cancelCurrentImageRequest];
#elif HasYYKit
        [self.animatedImageView cancelCurrentImageRequest];
#elif HasSDWebImage
        [self.imageView sd_cancelCurrentAnimationImagesLoad];
#endif
    }else if (self.model.type == HXPhotoModelMediaTypePhotoGif) {
        if (!self.stopCancel) {
#if HasYYKitOrWebImage
            self.animatedImageView.currentAnimatedImageIndex = 0;
#else
            self.imageView.image = nil;
            self.gifImage = nil;
            self.imageView.image = self.gifFirstFrame;
#endif
        }else {
            self.stopCancel = NO;
        }
    }
    if (self.model.subType == HXPhotoModelMediaSubTypeVideo) {
        if (self.player != nil && !self.stopCancel) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
            [self.player pause];
            self.videoPlayBtn.selected = NO;
            self.progress.playing = NO;
            [self.player seekToTime:kCMTimeZero];
            self.playerLayer.player = nil;
            self.player = nil;
            self.playerItem = nil;
        }
        self.stopCancel = NO;
    }
}
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.cellTapClick) {
        self.cellTapClick();
    }
}
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGFloat width = self.playerBgView.frame.size.width;
        CGFloat height = self.playerBgView.frame.size.height;
        CGPoint touchPoint;
        if (self.model.type == HXPhotoModelMediaTypeLivePhoto) {
            touchPoint = [tap locationInView:self.livePhotoView];
        }else {
#if HasYYKitOrWebImage
            touchPoint = [tap locationInView:self.animatedImageView];
#else
            touchPoint = [tap locationInView:self.imageView];
#endif
        }
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = width / newZoomScale;
        CGFloat ysize = height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}
#pragma mark - < PHLivePhotoViewDelegate >
- (void)livePhotoView:(PHLivePhotoView *)livePhotoView willBeginPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    self.livePhotoAnimating = YES;
}
- (void)livePhotoView:(PHLivePhotoView *)livePhotoView didEndPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    [self stopLivePhoto];
}
- (void)stopLivePhoto {
    self.livePhotoAnimating = NO;
    [self.livePhotoView stopPlayback];
}
#pragma mark - < UIScrollViewDelegate >
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.model.subType == HXPhotoModelMediaSubTypeVideo) {
        return nil;
    }
    if (self.model.type == HXPhotoModelMediaTypeLivePhoto) {
        return self.livePhotoView;
    }else {
#if HasYYKitOrWebImage
        return self.animatedImageView;
#else
        return self.imageView;
#endif
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    if (self.model.type == HXPhotoModelMediaTypeLivePhoto) {
        self.livePhotoView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }else {
#if HasYYKitOrWebImage
        self.animatedImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
#else
        self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
#endif
    }
}
- (void)didPlayBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    self.progress.playing = button.selected;
    if (button.selected) {
        [self.player play];
    }else {
        [self.player pause];
    }
    if (self.cellDidPlayVideoBtn) {
        self.cellDidPlayVideoBtn(button.selected);
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.scrollView.frame, self.bounds)) {
        self.scrollView.frame = self.bounds;
        self.scrollView.contentSize = CGSizeMake(self.hx_w, self.hx_h);
    }
    self.progressView.center = CGPointMake(self.hx_w / 2, self.hx_h / 2);
    self.loadingView.center = self.progressView.center;
}
#pragma mark - < 懒加载 >
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.minimumZoomScale = 1;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#else
            if ((NO)) {
#endif
            }
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
            [_scrollView addGestureRecognizer:tap1];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
            tap2.numberOfTapsRequired = 2;
            [tap1 requireGestureRecognizerToFail:tap2];
            [_scrollView addGestureRecognizer:tap2];
        }
        return _scrollView;
    }
    - (CGFloat)zoomScale {
        return self.scrollView.zoomScale;
    }
#if HasYYKitOrWebImage
    - (YYAnimatedImageView *)animatedImageView {
        if (!_animatedImageView) {
            _animatedImageView = [[YYAnimatedImageView alloc] init];
        }
        return _animatedImageView;
    }
#endif
    - (UIImageView *)imageView {
        if (!_imageView) {
            _imageView = [[UIImageView alloc] init];
        }
        return _imageView;
    }
    - (PHLivePhotoView *)livePhotoView {
        if (!_livePhotoView) {
            _livePhotoView = [[PHLivePhotoView alloc] init];
            _livePhotoView.clipsToBounds = YES;
            _livePhotoView.contentMode = UIViewContentModeScaleAspectFill;
            _livePhotoView.delegate = self;
        }
        return _livePhotoView;
    }
    - (UIButton *)videoPlayBtn {
        if (!_videoPlayBtn) {
            _videoPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_videoPlayBtn setImage:[UIImage hx_imageNamed:@"hx_multimedia_videocard_play"] forState:UIControlStateNormal];
            [_videoPlayBtn setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
            [_videoPlayBtn addTarget:self action:@selector(didPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        return _videoPlayBtn;
    }
    - (HXCircleProgressView *)progressView {
        if (!_progressView) {
            _progressView = [[HXCircleProgressView alloc] init];
            _progressView.hidden = YES;
        }
        return _progressView;
    }
    - (UIActivityIndicatorView *)loadingView {
        if (!_loadingView) {
            _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [_loadingView stopAnimating];
        }
        return _loadingView;
    }
    - (AVPlayerLayer *)playerLayer {
        if (!_playerLayer) {
            _playerLayer = [[AVPlayerLayer alloc] init];
            _playerLayer.hidden = YES;
            _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        }
        return _playerLayer;
    }
    - (void)dealloc {
        [self cancelRequest];
    }
    
@end
