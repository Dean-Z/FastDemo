//
//  FDWebViewController.m
//  FastDemo
//
//  Created by Jason on 2020/2/20.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDMainScrollController.h"
#import "FDWebViewController.h"
#import <WebKit/WebKit.h>
#import "FDKit.h"

@interface FDWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *currentRequestURLString;

@end

@implementation FDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.navigationBar.title = @"WKWebView";
    self.navigationBar.parts = FDNavigationBarPartBack;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        if (weakSelf.webView.canGoBack) {
            [weakSelf.webView goBack];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    
    UIButton *forword = [UIButton new];
    [forword setImage:[UIImage imageNamed:@"arrow_forward"] forState:UIControlStateNormal];
    [self.navigationBar addSubview:forword];
    [forword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigationBar.titleLabel);
        make.right.equalTo(@(-5));
        make.width.height.equalTo(@(40));
    }];
    [forword addTarget:self action:@selector(forwordAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
    self.currentRequestURLString = @"https://m.gufengmh8.com/";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.currentRequestURLString]];
    [self.webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"铺抓当前页面的请求URL=%@",navigationAction.request.URL);
    if (![self.currentRequestURLString isEqualToString:navigationAction.request.URL.absoluteString]) {
        self.currentRequestURLString = navigationAction.request.URL.absoluteString;
        if ([self.currentRequestURLString hasSuffix:@"html"]) {
            FDMainScrollController *main = [FDMainScrollController mainScrollViewControllerWithURL:navigationAction.request.URL];
            [self.navigationController pushViewController:main animated:YES];
            self.currentRequestURLString = nil;
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"如果页面没有刷新则点击确定刷新页面" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             NSURLRequest *request = [NSURLRequest requestWithURL:navigationAction.request.URL];
             [self.webView loadRequest:request];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.webView evaluateJavaScript:@"document.title" completionHandler:^(id object, NSError * error) {
            weakSelf.navigationBar.title = object;
        }];
    });
}

- (void)forwordAction {
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

#pragma mark - getter

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [WKWebView new];
        _webView.navigationDelegate = self;
    }
    return _webView;
}


@end
