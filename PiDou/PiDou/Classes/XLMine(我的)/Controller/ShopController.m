//
//  ShopController.m
//  PiDou
//
//  Created by 邓康大 on 2019/8/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "ShopController.h"
#import <WebKit/WebKit.h>

@interface ShopController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://47.100.220.44/mobile/index.html#/home"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (WKWebView *)webView {
    if (!_webView) {
        //以下代码适配大小
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('viewprot-fit', 'cover'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = wkUController;
        
        _webView = [[WKWebView alloc] initWithFrame:(self.view.bounds) configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        //  _webView.scrollView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _webView;
}



@end
