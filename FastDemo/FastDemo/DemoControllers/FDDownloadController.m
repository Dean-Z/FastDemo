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
}

- (void)addDownloadRequestView {
    FDDownloadRequestView *requestView = [FDDownloadRequestView new];
    [self.view addSubview:requestView];
    if (self.downloadRequestViews.count == 0) {
        [requestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.equalTo(@(50));
            make.top.equalTo(self.navigationBar.mas_bottom).offset(20);
        }];
    } else {
        UIView *lastView = self.downloadRequestViews.lastObject;
        [requestView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.equalTo(@(50));
            make.top.equalTo(lastView.mas_bottom);
        }];
    }
    [self.downloadRequestViews addObject:requestView];
}

#pragma mark - Getter

- (NSMutableArray *)downloadRequestViews {
    if (!_downloadRequestViews) {
        _downloadRequestViews = @[].mutableCopy;
    }
    return _downloadRequestViews;
}

@end
