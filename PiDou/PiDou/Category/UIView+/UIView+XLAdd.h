//
//  UIView+XLAdd.h
//  PiDou
//
//  Created by ice on 2019/4/4.
//  Copyright © 2019 ice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XLAdd)

@property (nonatomic, assign) CGFloat xl_x;
@property (nonatomic, assign) CGFloat xl_y;
@property (nonatomic, assign) CGFloat xl_w;
@property (nonatomic, assign) CGFloat xl_h;
@property (nonatomic, assign) CGSize  xl_size;
@property (nonatomic, assign) CGPoint xl_origin;
@property (nonatomic, assign) CGFloat xl_centerX;
@property (nonatomic, assign) CGFloat xl_centerY;
@property (nonatomic, assign) CGPoint xl_center;
/**移除所有view*/
- (void)removeAllSubviews;
/**判断View是否显示在屏幕上*/
- (BOOL)isDisplayedInScreen;
/**获得view所在的控制器*/
- (UIViewController *)parentController;
/**获得view所在的导航控制器*/
- (UINavigationController *)navigationController;

- (UIView *)xl_getFirstResponder;

@end

NS_ASSUME_NONNULL_END
