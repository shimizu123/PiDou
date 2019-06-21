//
//  XLLineProgress.m
//  TG
//
//  Created by kevin on 14/12/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLLineProgress.h"
#import "CALayer+XLExtension.h"

@interface XLLineProgress ()

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation XLLineProgress
singleton_m(XLLineProgress)

+ (void)initLineProgressView:(UIView *)supView {
    [[self sharedXLLineProgress] initLineProgressView:supView];
}

+ (void)resetProgress {
    [[self sharedXLLineProgress] resetProgress];
}

+ (void)setLineProgress:(CGFloat)progress {
    [[self sharedXLLineProgress] setLineProgress:progress];
}

- (void)initLineProgressView:(UIView *)supView {
    CGFloat lineHeight = 1.5;
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.xl_size = CGSizeMake(supView.xl_w, lineHeight);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, supView.xl_h - _progressLayer.xl_h / 2)];
    [path addLineToPoint:CGPointMake(supView.xl_w, supView.xl_h - _progressLayer.xl_h / 2)];
    _progressLayer.lineWidth = lineHeight;
    _progressLayer.path = path.CGPath;
    //_progressLayer.strokeColor = [UIColor colorWithRed:0.000 green:0.640 blue:1.000 alpha:0.720].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineCap = kCALineCapButt;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    [supView.layer addSublayer:_progressLayer];
}

/**重置*/
- (void)resetProgress {
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    self.progressLayer.hidden = YES;
    self.progressLayer.strokeEnd = 0;
    [CATransaction commit];
}

/**进度*/
- (void)setLineProgress:(CGFloat)progress {
    if (self.progressLayer.hidden) {
        self.progressLayer.hidden = NO;
    }
    self.progressLayer.strokeEnd = XL_CLAMP(progress, 0, 1); // 需要在主线程里面运行
}

@end
