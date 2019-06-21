//
//  XLMineShenController.m
//  PiDou
//
//  Created by ice on 2019/4/13.
//  Copyright © 2019 ice. All rights reserved.
//

#import "XLMineShenController.h"
#import "CALayer+XLExtension.h"
#import "XLShenApplyController.h"
#import "XLMineHandle.h"
#import <WebKit/WebKit.h>

#define LOGIN_BUTTON_HEIGHT 44 * kWidthRatio6s

@interface XLMineShenController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIButton *commitButton;
//@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) UIImageView *bgImgV;

@property (nonatomic, copy) NSString *content;

@end

@implementation XLMineShenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"神评鉴定";
    
    [self initUI];
    
    [self initData];
}

- (void)initData {
    kDefineWeakSelf;
    [XLMineHandle applyAppraiserPageWithSuccess:^(id  _Nonnull responseObject) {
        [WeakSelf.webView loadHTMLString:responseObject baseURL:nil];
    } failure:^(id  _Nonnull result) {
        
    }];
}

- (void)initUI {
    [self.view addSubview:self.webView];
    self.webView.backgroundColor = XL_COLOR_BG;
//    self.scrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - XL_NAVIBAR_H))];
//    self.scrollView.bounces = YES;
//    self.scrollView.showsVerticalScrollIndicator = NO;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.scrollEnabled = YES;
//    [self.view addSubview:self.scrollView];
//    if (@available(iOS 11.0, *)) {
//        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//
//    self.bgImgV = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 20))];
//    [self.scrollView addSubview:self.bgImgV];
//    self.bgImgV.backgroundColor = XLRandomColor;
//
    self.commitButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.view addSubview:self.commitButton];
    [self.commitButton xl_setTitle:@"立即申请" color:[UIColor whiteColor] size:18.f target:self action:@selector(commitAction:)];
    self.commitButton.backgroundColor = XL_COLOR_RED;
    [self.commitButton.layer setLayerShadow:XL_COLOR_RED offset:(CGSizeMake(0, 2)) radius:8 cornerRadius:LOGIN_BUTTON_HEIGHT * 0.5];

    
    
    [self initLayout];
}



- (void)initLayout {
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(32 * kWidthRatio6s);
        make.right.equalTo(self.view).mas_offset(-32 * kWidthRatio6s);
        make.bottom.equalTo(self.view.mas_bottom).mas_offset(-21 * kWidthRatio6s - XL_HOME_INDICATOR_H);
        make.height.mas_offset(LOGIN_BUTTON_HEIGHT);
    }];

}

- (void)commitAction:(UIButton *)button {
    XLShenApplyController *applyVC = [[XLShenApplyController alloc] init];
    applyVC.userInfo = self.userInfo;
    [self.navigationController pushViewController:applyVC animated:YES];
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


#pragma mark - lazy load
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
