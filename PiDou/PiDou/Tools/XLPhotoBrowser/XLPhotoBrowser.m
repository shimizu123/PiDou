//
//  XLPhotoBrowser.m
//  CBNReporterVideo
//
//  Created by kevin on 9/1/2019.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLPhotoBrowser.h"
#import "XLPhotoBrowserView.h"
#import "UIImage+TGExtension.h"
#import "YYImageCoder.h"

#define XLPhotoBrowserImageViewMargin 10
// browser中显示图片动画时长
#define XLPhotoBrowserShowImageAnimationDuration 0.35f
// browser中隐藏图片动画时长
#define XLPhotoBrowserHideImageAnimationDuration 0.35f

@interface XLPhotoBrowser () <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UIView *_contentView;
    BOOL _hasShowedFistView;//开始展示图片浏览器
}

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) XLPhotoBrowserView *photoBrowserView;
@property (nonatomic, strong) UIImageView *tempView; // pan过程中的图片

// 手势
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UIPanGestureRecognizer *pan;

@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation XLPhotoBrowser

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor blackColor];
    self.saveButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:self.saveButton];
    [self.saveButton xl_setTitle:@"保存" color:XL_COLOR_RED size:14.f target:self action:@selector(savePhoto:)];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(16 * kWidthRatio6s);
        make.bottom.equalTo(self).mas_offset(-16 * kWidthRatio6s - XL_HOME_INDICATOR_H);
        make.width.mas_offset(58 * kWidthRatio6s);
        make.height.mas_offset(28 * kWidthRatio6s);
    }];
}

- (void)savePhoto:(UIButton *)button {
    XLLog(@"保存图片");
    
    [self.photoBrowserView.imageview.image yy_saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
        [HUDController hideHUDWithText:@"保存成功"];
    }];
}

//当视图移动完成后调用
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self setupScrollView];
    [self addGestureRecognizer:self.singleTap];
    [self addGestureRecognizer:self.doubleTap];
    [self addGestureRecognizer:self.pan];
    if (_scrollView.subviews.count > 0 && _scrollView.subviews.count > self.currentImageIndex) {
        self.photoBrowserView = _scrollView.subviews[self.currentImageIndex];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.bounds;
    rect.size.width += XLPhotoBrowserImageViewMargin * 2;
    _scrollView.bounds = rect;
    _scrollView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height *0.5);
    CGFloat y = 0;
    __block CGFloat w = _scrollView.frame.size.width - XLPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    [_scrollView.subviews enumerateObjectsUsingBlock:^(XLPhotoBrowserView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = XLPhotoBrowserImageViewMargin + idx * (XLPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    [self bringSubviewToFront:self.saveButton];
}

- (void)setupScrollView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    for (int i = 0; i < self.imageArray.count; i++) {
        XLPhotoBrowserView *view = [[XLPhotoBrowserView alloc] init];
        view.imageview.tag = i;
        [_scrollView addSubview:view];
    }
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

- (void)showFirstImage {
    self.userInteractionEnabled = NO;
    if (self.sourceImagesContainerView) {
        UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
        CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
        UIImageView *tempView = [[UIImageView alloc] init];
        tempView.frame = rect;
        tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
        [self addSubview:tempView];
        tempView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGFloat placeImageSizeW = tempView.image.size.width;
        CGFloat placeImageSizeH = tempView.image.size.height;
        CGRect targetTemp;
        CGFloat selfW = self.frame.size.width;
        CGFloat selfH = self.frame.size.height;
        
        CGFloat placeHolderH = (placeImageSizeH * selfW)/placeImageSizeW;
        if (placeHolderH <= selfH) {
            targetTemp = CGRectMake(0, (selfH - placeHolderH) * 0.5 , selfW, placeHolderH);
        } else {//图片高度>屏幕高度
            targetTemp = CGRectMake(0, 0, selfW, placeHolderH);
        }
        // 先隐藏scrollview
        _scrollView.hidden = YES;
        [UIView animateWithDuration:XLPhotoBrowserShowImageAnimationDuration animations:^{
            // 将点击的临时imageview动画放大到和目标imageview一样大
            tempView.frame = targetTemp;
        } completion:^(BOOL finished) {
            // 动画完成后，删除临时imageview，让目标imageview显示
            _hasShowedFistView = YES;
            [tempView removeFromSuperview];
            _scrollView.hidden = NO;
            self.userInteractionEnabled = YES;
        }];
    } else {
        _photoBrowserView.alpha = 0;
        _contentView.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            // 将点击的临时imageview动画放大到和目标imageview一样大
            _photoBrowserView.alpha = 1;
            _contentView.alpha = 1;
        } completion:^(BOOL finished) {
            _hasShowedFistView = YES;
            self.userInteractionEnabled = YES;
        }];
    }
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index {
    if (_scrollView.subviews.count <= index) {
        return;
    }
    
    XLPhotoBrowserView *view = _scrollView.subviews[index];
    if (self.imageArray.count > index) {
        id obj = self.imageArray[index];
        if ([obj isKindOfClass:[NSURL class]]) {
            view.imageview.image = [UIImage thumbnailImageForVideo:obj atTime:0.1];
            view.url = obj;
            self.saveButton.hidden = YES;
        } else if ([obj isKindOfClass:[UIImage class]]) {
            view.imageview.image = obj;
            self.saveButton.hidden = NO;
        } else {
            [view.imageview sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:nil];
        }
    }
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index {
    if (self.sourceImagesContainerView) {
        return [self getCurrentImageWithIndex:index];
    } else {
        return nil;
    }
    
    return nil;
}

- (UIImage *)getCurrentImageWithIndex:(NSInteger)index {
    id obj = self.imageArray[index];
    if ([obj isKindOfClass:[NSURL class]]) {
        return [UIImage thumbnailImageForVideo:obj atTime:0.1];
    } else if ([obj isKindOfClass:[UIImage class]]) {
        return obj;
    } else {
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj]]];
    }
}

#pragma mark - setter
- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    self.imageCount = _imageArray.count;
}



- (void)setSourceImagesContainerView:(UIView *)sourceImagesContainerView {
    _sourceImagesContainerView = sourceImagesContainerView;
}

#pragma mark - tap
#pragma mark - 单击
- (void)photoClick:(UITapGestureRecognizer *)recognizer {
    [self hidePhotoBrowser];
}

#pragma mark - 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    XLPhotoBrowserView *view = _scrollView.subviews[self.currentImageIndex];

    CGPoint touchPoint = [recognizer locationInView:self];
    if (view.scrollview.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + view.scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + view.scrollview.contentOffset.y;//需要放大的图片的Y点
        [view.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    } else {
        [view.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
}

#pragma mark - 长按
- (void)didPan:(UIPanGestureRecognizer *)panGesture {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {//横屏不允许拉动图片
        return;
    }
    //transPoint : 手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负。
    //locationPoint ： 手指在视图上的位置（x,y）就是手指在视图本身坐标系的位置。
    //velocity： 手指在视图上移动的速度（x,y）, 正负也是代表方向。
    CGPoint transPoint = [panGesture translationInView:self];
    //    CGPoint locationPoint = [panGesture locationInView:self];
    CGPoint velocity = [panGesture velocityInView:self];//速度
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self prepareForHide];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            double delt = 1 - fabs(transPoint.y) / self.frame.size.height;
            delt = MAX(delt, 0);
            double s = MAX(delt, 0.5);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(transPoint.x/s, transPoint.y/s);
            CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
            self.tempView.transform = CGAffineTransformConcat(translation, scale);
            self.coverView.alpha = delt;
        }
            break;
        case UIGestureRecognizerStateEnded:
            //        case UIGestureRecognizerStateCancelled:
        {
            if (fabs(transPoint.y) > 220 || fabs(velocity.y) > 500) {//退出图片浏览器
                [self hideAnimation];
            } else {//回到原来的位置
                [self bounceToOrigin];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 隐藏
- (void)hidePhotoBrowser {
    [self prepareForHide];
    [self hideAnimation];
}

- (void)hideAnimation {
    self.userInteractionEnabled = NO;
    CGRect targetTemp;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *sourceView = [self getSourceView];
    if (!sourceView) {
        targetTemp = CGRectMake(window.center.x, window.center.y, 0, 0);
    }
    if (self.sourceImagesContainerView) {
        UIView *sourceView = [self getSourceView];
        targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    } else {
        //默认回到屏幕中央
        targetTemp = CGRectMake(window.center.x, window.center.y, 0, 0);
    }
    
    self.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    [UIView animateWithDuration:XLPhotoBrowserHideImageAnimationDuration animations:^{
        if (self.sourceImagesContainerView) {
            _tempView.transform = CGAffineTransformInvert(self.transform);
        }
        _coverView.alpha = 0;
        _tempView.frame = targetTemp;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_tempView removeFromSuperview];
        [_contentView removeFromSuperview];
        _tempView = nil;
        _contentView = nil;
        sourceView.hidden = NO;
    }];
}


- (UIView *)getSourceView {
    if (_currentImageIndex <= self.sourceImagesContainerView.subviews.count - 1) {
        UIView *sourceView = self.sourceImagesContainerView.subviews[_currentImageIndex];
        return sourceView;
    }
    return nil;
}

- (void)prepareForHide {
    [_contentView insertSubview:self.coverView belowSubview:self];
    _photoBrowserView.hidden = YES;
    [self addSubview:self.tempView];
    self.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
    UIView *view = [self getSourceView];
    view.hidden = YES;
}

#pragma mark - 回到原来位置
- (void)bounceToOrigin {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:XLPhotoBrowserHideImageAnimationDuration animations:^{
        self.tempView.transform = CGAffineTransformIdentity;
        _coverView.alpha = 1;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        [_tempView removeFromSuperview];
        [_coverView removeFromSuperview];
        _tempView = nil;
        _coverView = nil;
        _photoBrowserView.hidden = NO;
        self.backgroundColor = [UIColor blackColor];
        _contentView.backgroundColor = [UIColor blackColor];
        UIView *view = [self getSourceView];
        view.hidden = NO;
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    long left = index - 1;
    long right = index + 1;
    left = left > 0 ? left : 0;
    right = right > self.imageCount ? self.imageCount : right;
    
    for (long i = left; i < right; i++) {
        [self setupImageOfImageViewForIndex:i];
    }
}

//scrollview结束滚动调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int autualIndex = scrollView.contentOffset.x / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    self.photoBrowserView = _scrollView.subviews[self.currentImageIndex];
    
    //将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
    for (XLPhotoBrowserView *view in _scrollView.subviews) {
        if (view.imageview.tag != autualIndex) {
            view.scrollview.zoomScale = 1.0;
        }
    }
}

#pragma mark - public methods
- (void)show {
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor blackColor];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = window.center;
    _contentView.bounds = window.bounds;
    
    if (iPHONE_X) {
        self.frame = CGRectMake(0, XL_STATUS_H,SCREEN_WIDTH,SCREEN_HEIGHT - XL_STATUS_H - XL_HOME_INDICATOR_H);
    } else {
        self.frame = _contentView.bounds;
    }
    window.windowLevel = UIWindowLevelStatusBar + 10.0f;//隐藏状态栏
    [_contentView addSubview:self];
    
    [window addSubview:_contentView];
    
    // 这个版本不考虑旋转问题
//    [self performSelector:@selector(onDeviceOrientationChangeWithObserver) withObject:nil afterDelay:XLPhotoBrowserShowImageAnimationDuration + 0.2];
}

#pragma mark - lazy load
//做颜色渐变动画的view，让退出动画更加柔和
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}

- (UIImageView *)tempView {
    if (!_tempView) {
        XLPhotoBrowserView *photoBrowserView = _scrollView.subviews[self.currentImageIndex];
        UIImageView *currentImageView = photoBrowserView.imageview;
        CGFloat tempImageX = currentImageView.frame.origin.x - photoBrowserView.scrollOffset.x;
        CGFloat tempImageY = currentImageView.frame.origin.y - photoBrowserView.scrollOffset.y;
        
        CGFloat tempImageW = photoBrowserView.zoomImageSize.width;
        CGFloat tempImageH = photoBrowserView.zoomImageSize.height;
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (UIDeviceOrientationIsLandscape(orientation)) {//横屏
            
            //处理长图,图片太长会导致旋转动画飞掉
            if (tempImageH > SCREEN_HEIGHT) {
                tempImageH = tempImageH > (tempImageW * 1.5)? (tempImageW * 1.5):tempImageH;
                if (fabs(tempImageY) > tempImageH) {
                    tempImageY = 0;
                }
            }
            
        }
        
        _tempView = [[UIImageView alloc] init];
        //这边的contentmode要跟 HZPhotoGrop里面的按钮的 contentmode保持一致（防止最后出现闪动的动画）
        _tempView.contentMode = UIViewContentModeScaleAspectFill;
        _tempView.clipsToBounds = YES;
        _tempView.frame = CGRectMake(tempImageX, tempImageY, tempImageW, tempImageH);
        _tempView.image = currentImageView.image;
    }
    return _tempView;
}

- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.delaysTouchesBegan = YES;
        //只能有一个手势存在
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        //        _doubleTap.numberOfTouchesRequired = 1;
    }
    return _doubleTap;
}

- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    }
    return _pan;
}



@end
