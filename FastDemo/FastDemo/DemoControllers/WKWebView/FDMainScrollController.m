//
//  FDMainScrollController.m
//  FastDemo
//
//  Created by Jason on 2020/2/20.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDMainScrollController.h"
#import "FDImageTableCell.h"
#import <WebKit/WebKit.h>
#import "YYWebImage.h"
#import "FDKit.h"

static NSString *host = @"https://m.gufengmh8.com";

@interface FDMainScrollController ()<WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURL *currentUrl;

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSMutableArray *contentImageArray;
@property (nonatomic, strong) YYAnimatedImageView *lastImageView;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation FDMainScrollController

+ (instancetype)mainScrollViewControllerWithURL:(NSURL *)url {
    FDMainScrollController *main = [FDMainScrollController new];
    main.currentUrl = url;
    return main;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.navigationBar.title = @"WKWebView";
    self.navigationBar.parts = FDNavigationBarPartBack;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.navigationBar addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navigationBar.titleLabel);
        make.right.equalTo(@(-20));
        make.width.height.equalTo(@(40));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.height.equalTo(@(150));
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.currentUrl];
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
    if (self.indicatorView.animating == NO) {
        [self.indicatorView startAnimating];
    }
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf prepareHtml];
    });
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailNavigation");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
}

- (void)prepareHtml {
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id object, NSError * error) {
        self.navigationBar.title = object;
    }];
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    WEAKSELF
    [self.webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
//        NSLog(@"%@",HTMLsource);
        NSString *htmlSource = HTMLsource;
        
        NSInteger fromLocation = [htmlSource rangeOfString:@"<div id=\"images\""].location;
        if (fromLocation != NSNotFound) {
            NSInteger toPostion = [htmlSource rangeOfString:@"/mip/chapter-3.js"].location;
            NSString *srcString = [htmlSource substringWithRange:NSMakeRange(fromLocation, toPostion - fromLocation)];
            
            // 获取src
            NSRange srcRange = [srcString rangeOfString:@"src=\""];
            NSInteger index = 0;
//            NSLog(@"%@",srcString);
            for (NSInteger i=srcRange.location + srcRange.length; i<srcString.length; i++) {
                char c = [srcString characterAtIndex:i];
                if (c == '\"') {
                    index = i;
                    break;
                }
            }
            if (index != 0) {
                NSString *src = [srcString substringWithRange:NSMakeRange(srcRange.location + srcRange.length, index - srcRange.location - srcRange.length)];
                [weakSelf loadImage:src];
                NSLog(@"%@",src);
            }
            
            // 获取下一页地址
            NSRange nextPageRange = [srcString rangeOfString:@"href=\""];
            NSInteger nextPageindex = 0;
            for (NSInteger i=nextPageRange.location + nextPageRange.length; i<srcString.length; i++) {
                char c = [srcString characterAtIndex:i];
                if (c == '\"') {
                    nextPageindex = i;
                    break;
                }
            }
            if (nextPageindex != 0) {
                NSString *nextPage = [srcString substringWithRange:NSMakeRange(nextPageRange.location + nextPageRange.length, nextPageindex - nextPageRange.location - nextPageRange.length)];
                if ([nextPage isEqualToString:@"javascript:SinTheme.nextChapter();"]) {
                    weakSelf.currentUrl = nil;
                    [weakSelf.indicatorView stopAnimating];
                    weakSelf.indicatorView.hidden = YES;
                } else {
                    weakSelf.currentUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host,nextPage]];
                }
                NSLog(@"%@",self.currentUrl.absoluteURL);
            }
        }
    }];
}

- (void)loadImage:(NSString *)imageUrl {
    if (![self.imageUrlArray containsObject:imageUrl]) {
        [self.imageUrlArray addObject:imageUrl];
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        WEAKSELF
        [imageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:nil options:YYWebImageOptionUseNSURLCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (!error && image) {
                NSDictionary *dict = @{@"image":image,
                                       @"height":@(image.size.height / image.size.width * WindowSizeW)};
                [weakSelf.contentImageArray addObject:dict];
                [weakSelf.tableView reloadData];
                [weakSelf nextPage];
            }
        }];
        [self.view addSubview:imageView];
    }
}

- (void)nextPage {
    if (self.currentUrl) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.currentUrl];
        [self.webView loadRequest:request];
    }
}

- (void)nextChapter {
    self.indicatorView.hidden = NO;
    [self.contentImageArray removeAllObjects];
    [self.tableView reloadData];
    NSString *jsStr = @"javascript:SinTheme.nextChapter();";
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    }];
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentImageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FDImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FDImageTableCell class])];
    NSDictionary *dict = self.contentImageArray[indexPath.row];
    [cell renderWithImage:[dict objectForKey:@"image"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.contentImageArray[indexPath.row];
    return [[dict objectForKey:@"height"] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[FDImageTableCell class] forCellReuseIdentifier:NSStringFromClass([FDImageTableCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setTableFooterView:[self footView]];
    }
    return _tableView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [WKWebView new];
        _webView.navigationDelegate = self;
        _webView.hidden = YES;
    }
    return _webView;
}

- (NSMutableArray *)contentImageArray {
    if (!_contentImageArray) {
        _contentImageArray = @[].mutableCopy;
    }
    return _contentImageArray;
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = @[].mutableCopy;
    }
    return _imageUrlArray;
}

- (UIView *)footView {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, WindowSizeW, 60);
    view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton new];
    [btn setTitle:@"下一章" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [view addSubview:btn];
    [btn addTarget:self action:@selector(nextChapter) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    return view;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

@end
