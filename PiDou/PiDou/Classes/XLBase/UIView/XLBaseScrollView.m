//
//  XLBaseScrollView.m
//  TG
//
//  Created by kevin on 1/11/17.
//  Copyright © 2017年 YIcai. All rights reserved.
//

#import "XLBaseScrollView.h"

@implementation XLBaseScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.panGestureRecognizer.delegate = self;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.panGestureRecognizer.delegate = self;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end
