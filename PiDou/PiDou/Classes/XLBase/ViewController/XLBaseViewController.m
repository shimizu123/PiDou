//
//  XLBaseViewController.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLBaseViewController.h"

@interface XLBaseViewController ()

@end

@implementation XLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (BOOL)isShowingOnKeyWindow:(UIViewController *)viewController {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 把这个view在它的父控件中的frame(即默认的frame)转换成在window的frame
    
    CGRect convertFrame = [viewController.view.superview convertRect:viewController.view.frame toView: keyWindow];
    
    CGRect windowBounds = keyWindow.bounds;
    
    // 判断这个控件是否在主窗口上（即该控件和keyWindow有没有交叉）
    
    BOOL isOnWindow = CGRectIntersectsRect(convertFrame, windowBounds);
    
    // 再判断这个控件是否真正显示在窗口范围内（是否在窗口上，是否为隐藏，是否透明）
    
    BOOL isShowingOnWindow = (viewController.view.window == keyWindow) && !viewController.view.isHidden && (self.view.alpha > 0.01) && isOnWindow;
    
    return isShowingOnWindow;
    
}

- (void)xl_hiddenleftBarButtonItem {
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setTranslucent:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
