//
//  XLFocusButton.m
//  PiDou
//
//  Created by ice on 2019/4/5.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLFocusButton.h"

@implementation XLFocusButton

- (void)setIsAdd:(BOOL)isAdd {
    _isAdd = isAdd;
    if (_isAdd) {
        [self xl_setTitle:@"已关注" color:XL_COLOR_BLACK size:11.f];
        XLViewBorderRadius(self, 14 * kWidthRatio6s, 1, CGCOLOR(0xe6e6e6));
        self.backgroundColor = [UIColor whiteColor];
    } else {
        [self xl_setTitle:@"关注" color:[UIColor whiteColor] size:14.f];
        XLViewBorderRadius(self, 14 * kWidthRatio6s, 0, XL_COLOR_RED.CGColor);
        self.backgroundColor = XL_COLOR_RED;
    }
}

- (void)setIsLook:(BOOL)isLook {
    _isLook = isLook;
    if (_isLook) {
        [self xl_setTitle:@"查看" color:XL_COLOR_BLACK size:14.f];
        XLViewBorderRadius(self, 14 * kWidthRatio6s, 1, XL_COLOR_BLACK.CGColor);
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
