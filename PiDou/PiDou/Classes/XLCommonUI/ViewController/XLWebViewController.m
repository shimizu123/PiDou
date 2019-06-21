//
//  XLWebViewController.m
//  PiDou
//
//  Created by ice on 2019/4/3.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLWebViewController.h"

@interface XLWebViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSMutableURLRequest * oriRequest;
@end

@implementation XLWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self initUI];
}

- (void)initUI {
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self loadWebPageFromURL:self.URL];
}


- (void)loadWebPageFromURL:(NSURL *)URL {
    //8.8.27添加缓存
    _oriRequest = [NSMutableURLRequest requestWithURL:URL];
    _oriRequest.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [_webView loadRequest:_oriRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
