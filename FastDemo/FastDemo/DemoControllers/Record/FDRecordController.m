//
//  FDRecordController.m
//  FastDemo
//
//  Created by Jason on 2020/4/30.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDRecordController.h"
#import "FDAudioRecord.h"
#import "FDKit.h"

@interface FDRecordController ()

@property (nonatomic, strong) FDAudioRecord *audioRecord;

@property (nonatomic, strong) UIButton *startRecord;
@property (nonatomic, strong) UIButton *pauseRecord;
@property (nonatomic, strong) UIButton *stopRecord;

@end

@implementation FDRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.title = @"Record";
    self.navigationBar.parts = FDNavigationBarPartBack;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
         [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.startRecord];
    [self.view addSubview:self.pauseRecord];
    [self.view addSubview:self.stopRecord];
    
    [self.pauseRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@100);
        make.top.equalTo(@200);
    }];
    
    [self.startRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pauseRecord.mas_left).offset(-10);
        make.width.height.equalTo(@100);
        make.top.equalTo(@200);
    }];
    
    [self.stopRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pauseRecord.mas_right).offset(100);
        make.width.height.equalTo(@100);
        make.top.equalTo(@200);
    }];
    
    [self.view addSubview:self.audioRecord.waver];
}

- (void)startRecordAction {
    if ([self.audioRecord canRecord]) {
        [self.audioRecord onStatrRecord];
    }
}

- (void)pauseRecordAction {
    [self.audioRecord stopRecord];
}

- (void)stopRecordAction {
    [self.audioRecord compoundAllAudios];
}

#pragma mark - Getter

- (UIButton *)startRecord {
    if (!_startRecord) {
        _startRecord = [UIButton new];
        [_startRecord setTitle:@"start" forState:UIControlStateNormal];
        [_startRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startRecord addTarget:self action:@selector(startRecordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startRecord;
}

- (UIButton *)pauseRecord {
    if (!_pauseRecord) {
        _pauseRecord = [UIButton new];
        [_pauseRecord setTitle:@"pause" forState:UIControlStateNormal];
        [_pauseRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_pauseRecord addTarget:self action:@selector(pauseRecordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseRecord;
}

- (UIButton *)stopRecord {
    if (!_stopRecord) {
        _stopRecord = [UIButton new];
        [_stopRecord setTitle:@"stop" forState:UIControlStateNormal];
        [_stopRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_stopRecord addTarget:self action:@selector(stopRecordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopRecord;
}

- (FDAudioRecord *)audioRecord {
    if (!_audioRecord) {
        _audioRecord = [[FDAudioRecord alloc] init];
    }
    return _audioRecord;
}

@end
