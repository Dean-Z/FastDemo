//
//  FDDownloadController.m
//  FastDemo
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDDownloadController.h"
#import "FDDownloadRequestView.h"
#import "FDFilesListController.h"
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
    self.navigationBar.parts = FDNavigationBarPartBack | FDNavigationBarPartAdd | FDNavigationBarPartFiles;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.navigationBar.onClickAddAction = ^{
        [weakSelf addDownloadRequestView];
    };
    
    self.navigationBar.onClickFileAction = ^{
        FDFilesListController *vc = [FDFilesListController new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
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
            make.top.equalTo(self.navigationBar.mas_bottom).offset(0);
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
    requestView1.inputTextField.text = @"http://dean.mudao88.com/audio.mp3";
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
