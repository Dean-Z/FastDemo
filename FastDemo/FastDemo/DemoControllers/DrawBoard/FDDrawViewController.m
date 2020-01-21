//
//  FDDrawViewController.m
//  FastDemo
//
//  Created by Jason on 2020/1/21.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDDrawViewController.h"
#import "DrawingView.h"
#import "FDKit.h"

@interface FDDrawViewController ()

@property (nonatomic, strong) DrawingView *drawView;

@end

@implementation FDDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.drawView = [[DrawingView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.drawView];
    
    self.navigationBar.title = @"Drawing";
    self.navigationBar.parts = FDNavigationBarPartBack;
    self.view.backgroundColor = [UIColor whiteColor];
    
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    UIButton *undoBtn = [UIButton new];
    [undoBtn setTitle:@"Undo" forState:UIControlStateNormal];
    [self.navigationBar addSubview:undoBtn];
    [undoBtn addTarget:self action:@selector(undoAction) forControlEvents:UIControlEventTouchUpInside];
    [undoBtn setTitleColor:HEXCOLOR(0x777777) forState:UIControlStateNormal];
    [undoBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [undoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationBar.mas_right).offset(-10);
        make.centerY.equalTo(self.navigationBar.titleLabel);
    }];
}

- (void)undoAction {
    [self.drawView undo];
}


@end
