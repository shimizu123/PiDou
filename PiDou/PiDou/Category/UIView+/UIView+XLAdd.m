//
//  UIView+XLAdd.m
//  PiDou
//
//  Created by ice on 2019/4/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import "UIView+XLAdd.h"

@implementation UIView (XLAdd)


- (void)setXl_x:(CGFloat)xl_x {
    CGRect frame = self.frame;
    frame.origin.x = xl_x;
    self.frame = frame;
}

- (CGFloat)xl_x {
    return self.frame.origin.x;
}

- (void)setXl_y:(CGFloat)xl_y {
    CGRect frame = self.frame;
    frame.origin.y = xl_y;
    self.frame = frame;
}

- (CGFloat)xl_y {
    return self.frame.origin.y;
}

- (void)setXl_w:(CGFloat)xl_w {
    CGRect frame = self.frame;
    frame.size.width = xl_w;
    self.frame = frame;
}

- (CGFloat)xl_w {
    return self.frame.size.width;
}

- (void)setXl_h:(CGFloat)xl_h {
    CGRect frame = self.frame;
    frame.size.height = xl_h;
    self.frame = frame;
}

- (CGFloat)xl_h {
    return self.frame.size.height;
}

- (void)setXl_size:(CGSize)xl_size {
    CGRect frame = self.frame;
    frame.size = xl_size;
    self.frame = frame;
}

- (CGSize)xl_size {
    return self.frame.size;
}

- (void)setXl_origin:(CGPoint)xl_origin {
    CGRect frame = self.frame;
    frame.origin = xl_origin;
    self.frame = frame;
}

- (CGPoint)xl_origin {
    return self.frame.origin;
}


- (void)setXl_center:(CGPoint)xl_center {
    self.center = xl_center;
}

- (CGPoint)xl_center {
    return self.center;
}

- (void)setXl_centerX:(CGFloat)xl_centerX {
    self.center = CGPointMake(xl_centerX, self.center.y);
}

- (CGFloat)xl_centerX {
    return self.center.x;
}


- (void)setXl_centerY:(CGFloat)xl_centerY {
    self.center = CGPointMake(self.center.x, xl_centerY);
}

- (CGFloat)xl_centerY {
    return self.center.y;
}

#pragma mark - 获得view所在的控制器
- (UIViewController *)parentController
{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

#pragma mark - 获得view所在的导航控制器
- (UINavigationController *)navigationController {
    return self.parentController.navigationController;
}

#pragma mark - 移除所有view
- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

#pragma mark - 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen {
    if (self == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;
}

- (UIView *)xl_getFirstResponder {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id activityIndicator = [keyWindow performSelector:NSSelectorFromString(@"firstResponder")];
#pragma clang diagnostic pop
    return activityIndicator;
}



@end
