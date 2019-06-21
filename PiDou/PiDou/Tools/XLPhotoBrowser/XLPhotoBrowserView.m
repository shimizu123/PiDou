//
//  XLPhotoBrowserView.m
//  CBNReporterVideo
//
//  Created by kevin on 9/1/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPhotoBrowserView.h"

#define kMinZoomScale 0.6f
#define kMaxZoomScale 2.0f

@interface XLPhotoBrowserView () <UIScrollViewDelegate>



@end

@implementation XLPhotoBrowserView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.scrollview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollview.frame = self.bounds;
    [self adjustFrame];
}

- (void)adjustFrame {
    //    CGRect frame = self.scrollview.frame;
    CGRect frame = self.frame;
    //   NSLog(@"%@",NSStringFromCGRect(self.frame));
    if (self.imageview.image) {
        CGSize imageSize = self.imageview.image.size;//获得图片的size
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (_isFullWidthForLandScape) {//图片宽度始终==屏幕宽度(新浪微博就是这种效果)
            CGFloat ratio = frame.size.width / imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        } else{
            if (frame.size.width <= frame.size.height) {
                //竖屏时候
                CGFloat ratio = frame.size.width / imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{ //横屏的时候
                CGFloat ratio = frame.size.height / imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageview.frame = imageFrame;
        //        NSLog(@"%@",NSStringFromCGRect(_scrollview.frame));
        //        NSLog(@"%@",NSStringFromCGRect(self.imageview.frame));
        //        self.scrollview.frame = self.imageview.frame;
        self.scrollview.contentSize = self.imageview.frame.size;
        self.imageview.center = [self centerOfScrollViewContent:self.scrollview];
        
        //根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
        CGFloat maxScale = frame.size.height / imageFrame.size.height;
        maxScale = frame.size.width / imageFrame.size.width > maxScale ? frame.size.width / imageFrame.size.width : maxScale;
        //超过了设置的最大的才算数
        maxScale = maxScale > kMaxZoomScale ? maxScale : kMaxZoomScale;
        //初始化
        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
    } else {
        frame.origin = CGPointZero;
        self.imageview.frame = frame;
        //重置内容大小
        self.scrollview.contentSize = self.imageview.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;
    self.zoomImageSize = self.imageview.frame.size;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.url) {
        // 播放视频的时候不做放大缩小
        return nil;
    }
    return self.imageview;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    self.zoomImageSize = view.frame.size;
    self.scrollOffset = scrollView.contentOffset;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if(self.scrollViewWillEndDragging) {
        self.scrollViewWillEndDragging(velocity, scrollView.contentOffset);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollViewDidEndDecelerating) {
        self.scrollViewDidEndDecelerating();
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //这里是缩放进行时调整
    self.imageview.center = [self centerOfScrollViewContent:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollOffset = scrollView.contentOffset;
    if (self.scrollViewDidScroll) {
        self.scrollViewDidScroll(self.scrollOffset);
    }
}

#pragma mark - setter
- (void)setUrl:(NSURL *)url {
    _url = url;
    [self.scrollview addSubview:self.mediaBrowserView];
    self.mediaBrowserView.url = _url;
    [self.mediaBrowserView startPlay];
}

#pragma mark - lazy load
- (UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        [_scrollview addSubview:self.imageview];
        _scrollview.delegate = self;
        _scrollview.clipsToBounds = YES;
    }
    return _scrollview;
}

- (UIImageView *)imageview {
    if (!_imageview) {
        _imageview = [[UIImageView alloc] init];
        _imageview.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _imageview.userInteractionEnabled = YES;
        _imageview.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageview;
}

- (XLMediaBrowserView *)mediaBrowserView {
    if (!_mediaBrowserView) {
        _mediaBrowserView = [[XLMediaBrowserView alloc] initVideoPlayViewWithURL:self.url];
        _scrollview.scrollEnabled = NO;
    }
    return _mediaBrowserView;
}

@end
