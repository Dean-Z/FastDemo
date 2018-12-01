//
//  FDDownloadController.m
//  FastDemo
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDDownloadController.h"
#import "FDDownloadRequestView.h"
#import "FDKit.h"

@interface FDDownloadController ()

@property (nonatomic, strong) NSMutableArray *downloadRequestViews;
@property (nonatomic, strong) UIButton *requestButton;
@property (nonatomic, strong) UIButton *mockButton;

@end

@implementation FDDownloadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.title = @"Download Files";
    self.navigationBar.parts = FDNavigationBarPartBack | FDNavigationBarPartAdd;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.navigationBar.onClickAddAction = ^{
        [weakSelf addDownloadRequestView];
    };
    
    [self.view addSubview:self.requestButton];
    [self.view addSubview:self.mockButton];
    [self.requestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(100));
    }];
    [self.mockButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.height.equalTo(@(40));
        make.width.equalTo(@(100));
        make.top.equalTo(self.navigationBar.mas_bottom).offset(20);
    }];
}

- (void)addDownloadRequestView {
    FDDownloadRequestView *requestView = [FDDownloadRequestView new];
    [self.view addSubview:requestView];
    if (self.downloadRequestViews.count == 0) {
        [requestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.height.equalTo(@(50));
            make.top.equalTo(self.navigationBar.mas_bottom).offset(20);
        }];
    } else {
        UIView *lastView = self.downloadRequestViews.lastObject;
        [requestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view).offset(0);
            make.height.equalTo(@(50));
            make.top.equalTo(lastView.mas_bottom);
        }];
    }
    [self.downloadRequestViews addObject:requestView];
    
    [self.requestButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(requestView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(100));
    }];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.mockButton.hidden = YES;
}

- (void)downloadAction {
    if (self.downloadRequestViews.count > 0) {
        for (FDDownloadRequestView *requestView in self.downloadRequestViews) {
            [requestView download];
        }
    }
}

- (void)mockAction {
    [self addDownloadRequestView];
    FDDownloadRequestView *requestView1 = self.downloadRequestViews.lastObject;
    requestView1.inputTextField.text = @"http://dean.mudao88.com/%E5%93%88%E5%88%A9%E6%B3%A2%E7%89%B9%287%29%E5%93%88%E5%88%A9%E6%B3%A2%E7%89%B9%E4%B8%8E%E6%AD%BB%E4%BA%A1%E5%9C%A3%E5%99%A8.zip";
    [self addDownloadRequestView];
    FDDownloadRequestView *requestView2 = self.downloadRequestViews.lastObject;
    requestView2.inputTextField.text = @"http://dean.mudao88.com/%E5%93%88%E5%88%A9%E6%B3%A2%E7%89%B9%285%29%E5%93%88%E5%88%A9%E6%B3%A2%E7%89%B9%E4%B8%8E%E5%87%A4%E5%87%B0%E7%A4%BE.zip";
    [self addDownloadRequestView];
    FDDownloadRequestView *requestView3 = self.downloadRequestViews.lastObject;
    requestView3.inputTextField.text = @"http://dean.mudao88.com/%E5%86%B0%E4%B8%8E%E7%81%AB%E4%B9%8B%E6%AD%8C%282%29-%E5%88%97%E7%8E%8B%E7%9A%84%E7%BA%B7%E4%BA%89.zip";
    [self addDownloadRequestView];
    FDDownloadRequestView *requestView4 = self.downloadRequestViews.lastObject;
    requestView4.inputTextField.text = @"http://dean.mudao88.com/%E5%86%B0%E4%B8%8E%E7%81%AB%E4%B9%8B%E6%AD%8C%283%29-%E5%86%B0%E9%9B%A8%E7%9A%84%E9%A3%8E%E6%9A%B4.zip";
    [self addDownloadRequestView];
    FDDownloadRequestView *requestView5 = self.downloadRequestViews.lastObject;
    requestView5.inputTextField.text = @"http://dean.mudao88.com/fgyfyufghkjhl534.jpg";
    [self addDownloadRequestView];
    FDDownloadRequestView *requestView6 = self.downloadRequestViews.lastObject;
    requestView6.inputTextField.text = @"http://dean.mudao88.com/Amar%20Lindsay.jpeg";
}

#pragma mark - Getter

- (NSMutableArray *)downloadRequestViews {
    if (!_downloadRequestViews) {
        _downloadRequestViews = @[].mutableCopy;
    }
    return _downloadRequestViews;
}

- (UIButton *)requestButton {
    if (!_requestButton) {
        _requestButton = [UIButton new];
        _requestButton.backgroundColor = HEXCOLOR(0x6ed56c);
        [_requestButton setTitle:@"Start" forState:UIControlStateNormal];
        [_requestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_requestButton addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
        _requestButton.layer.cornerRadius = 5.f;
        _requestButton.layer.masksToBounds = YES;
    }
    return _requestButton;
}

- (UIButton *)mockButton {
    if (!_mockButton) {
        _mockButton = [UIButton new];
        _mockButton.backgroundColor = HEXCOLOR(0x666666);
        [_mockButton setTitle:@"Mock" forState:UIControlStateNormal];
        [_mockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mockButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_mockButton addTarget:self action:@selector(mockAction) forControlEvents:UIControlEventTouchUpInside];
        _mockButton.layer.cornerRadius = 5.f;
        _mockButton.layer.masksToBounds = YES;
    }
    return _mockButton;
}

@end
