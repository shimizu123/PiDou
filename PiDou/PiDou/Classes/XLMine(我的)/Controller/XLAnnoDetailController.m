//
//  XLAnnoDetailController.m
//  PiDou
//
//  Created by ice on 2019/5/12.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLAnnoDetailController.h"
#import <WebKit/WebKit.h>
#import "XLMineHandle.h"
#import "XLAnnouncement.h"

@interface XLAnnoDetailController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation XLAnnoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"公告列表";
    
    [self initUI];
    
    [self initData];
}

- (void)initUI {
    [self.view addSubview:self.webView];
    
}

- (void)initData {
    kDefineWeakSelf;
    [XLMineHandle announcementDetailWithAid:self.aid success:^(XLAnnouncement *responseObject) {
        if (!XLStringIsEmpty(responseObject.content)) {
            [WeakSelf.webView loadHTMLString:responseObject.content baseURL:nil];
        }
    } failure:^(id  _Nonnull result) {
        
    }];
}

#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
     decisionHandler(WKNavigationActionPolicyAllow);
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (webView.isLoading) {
        return;
    }
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    XLLog(@"内存消耗巨大");
}


#pragma mark - lazy load
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        
        _webView = [[WKWebView alloc] initWithFrame:(self.view.bounds) configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _webView;
}

@end
