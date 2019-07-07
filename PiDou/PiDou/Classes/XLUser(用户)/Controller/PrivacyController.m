//
//  PrivacyController.m
//  PiDou
//
//  Created by 邓康大 on 2019/6/27.
//  Copyright © 2019年 ice. All rights reserved.
//

#import "PrivacyController.h"
#import <WebKit/WebKit.h>

@interface PrivacyController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *string;

@end

@implementation PrivacyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:_string];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
}

- (void)setIsPDCoin:(BOOL)isPDCoin {
    _isPDCoin = isPDCoin;
    if (_isPDCoin) {
        _string = @"http://www.pidoutv.com/dark_convention/Strategy.html";
    }
}

- (void)setIsRecharge:(BOOL)isRecharge {
    _isRecharge = isRecharge;
    if (_isRecharge) {
        _string = @"http://www.pidoutv.com/dark_convention/Recharge.html";
    } else {
        _string = @"https://www.pidoutv.com/user_services.html";
    }
}

- (void)setAid:(NSString *)aid {
    _aid = aid;
    switch ([_aid intValue]) {
        case 1106:
            _string = @"http://www.pidoutv.com/dark_convention/Convention.html";
            break;
        case 1105:
            _string = @"http://www.pidoutv.com/dark_convention/DavVerify.html";
            break;
        case 1104:
            _string = @"http://www.pidoutv.com/dark_convention/BehaviorRule.html";
            break;
        case 1102:
            _string = @"http://www.pidoutv.com/dark_convention/dark.html";
            break;
    }
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
    //    if (webView.isLoading) {
    //        return;
    //    }
    //    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    //        CGFloat documentHeight = [result doubleValue];
    //        CGRect webFrame = webView.frame;
    //        webFrame.size.height = documentHeight;
    //        webView.frame = webFrame;
    //    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    XLLog(@"内存消耗巨大");
}

- (WKWebView *)webView {
    if (!_webView) {
        //以下代码适配大小
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
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
