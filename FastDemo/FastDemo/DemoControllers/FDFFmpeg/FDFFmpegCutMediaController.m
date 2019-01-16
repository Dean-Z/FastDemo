//
//  FDFFmpegCutMediaController.m
//  FastDemo
//
//  Created by Jason on 2019/1/10.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "FDFFmpegCutMediaController.h"
#import "FDFilesListController.h"
#import "FFmpegCmdManager.h"
#import "FDPlayerManager.h"
#import "SVProgressHUD.h"
#import "FDKit.h"

@interface FDFFmpegCutMediaController ()

@property (nonatomic, strong) UILabel *fileDesc;
@property (nonatomic, strong) UILabel *startTime;
@property (nonatomic, strong) UILabel *durationTime;
@property (nonatomic, strong) UILabel *subFileName;

@property (nonatomic, strong) UITextField *startField;
@property (nonatomic, strong) UITextField *endField;
@property (nonatomic, strong) UITextField *subFileNameField;

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *startFieldText;
@property (nonatomic, strong) NSString *endFieldText;
@property (nonatomic, strong) NSString *subFileNameFieldText;

@property (nonatomic, assign) NSInteger totalDuration;
@property (nonatomic, strong) NSThread *cutThread;

@end

@implementation FDFFmpegCutMediaController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    [self addsubview];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(threadWillExit)
                                                name:NSThreadWillExitNotification
                                              object:nil];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.title = @"Cut Media";
    self.navigationBar.parts = FDNavigationBarPartBack | FDNavigationBarPartFiles;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.navigationBar.onClickFileAction = ^{
        FDFilesListController *fileList = [FDFilesListController new];
        fileList.type = FDFileChooseVideo;
        fileList.chooseFinishBlock = ^(id path) {
            weakSelf.filePath = path;
            [weakSelf fillDesc];
        };
        [weakSelf.navigationController pushViewController:fileList animated:YES];
    };
}

- (void)addsubview {
    [self.view addSubview:self.fileDesc];
    [self.view addSubview:self.startTime];
    [self.view addSubview:self.durationTime];
    [self.view addSubview:self.subFileName];
    [self.view addSubview:self.startField];
    [self.view addSubview:self.endField];
    [self.view addSubview:self.subFileNameField];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.playButton];
    
    [self.fileDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
    }];
    [self.startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileDesc.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(20);
    }];
    [self.durationTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startTime.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(20);
    }];
    [self.subFileName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.durationTime.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(20);
    }];
    [self.startField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startTime);
        make.left.equalTo(self.startTime.mas_right).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@30);
    }];
    [self.endField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.durationTime);
        make.left.equalTo(self.durationTime.mas_right).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@30);
    }];
    [self.subFileNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.subFileName);
        make.left.equalTo(self.subFileName.mas_right).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@30);
    }];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subFileNameField.mas_bottom).offset(50);
        make.height.equalTo(@40);
        make.width.equalTo(@120);
        make.centerX.equalTo(self.view);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startButton.mas_bottom).offset(20);
        make.height.equalTo(@40);
        make.width.equalTo(@120);
        make.centerX.equalTo(self.view);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.durationTime resignFirstResponder];
    [self.startField resignFirstResponder];
    [self.subFileNameField resignFirstResponder];
}

- (void)fillDesc {
    AVAsset *aset = [AVAsset assetWithURL:[NSURL fileURLWithPath:self.filePath]];
    CMTimeValue aduration = aset.duration.value / aset.duration.timescale;
    self.totalDuration = (NSInteger)aduration;
    self.fileDesc.text = [NSString stringWithFormat:@"%@  Duration: %llds ",self.filePath.lastPathComponent, aduration];
    
}

- (void)startAction {
    if (self.endField.text.integerValue == 0 || self.endField.text.integerValue > self.totalDuration) {
        [SVProgressHUD showErrorWithStatus:@"End time error!"];
        return;
    }
    if (EMPLYSTRING(self.subFileNameField.text)) {
        [SVProgressHUD showErrorWithStatus:@"Please set a name for new file!"];
        return;
    }
    [self.durationTime resignFirstResponder];
    [self.startField resignFirstResponder];
    [self.subFileNameField resignFirstResponder];
    
    NSString *oFileName = self.filePath.lastPathComponent;
    if ([oFileName containsString:@"."]) {
        NSArray *cp = [oFileName componentsSeparatedByString:@"."];
        self.subFileNameFieldText = [NSString stringWithFormat:@"%@/%@.%@",FDPathDocument,self.subFileNameField.text,cp.lastObject];
        self.startFieldText = self.startField.text;
        self.endFieldText = self.endField.text;
        [SVProgressHUD show];
        [self.cutThread start];
    }
}

- (void)playAction {
    [FDPlayerManager showPlayerChooser:self url:self.subFileNameFieldText];
}

- (void)startCutThread {
    FFmpegCmdManager *manager = [FFmpegCmdManager new];
    [manager cutInputVideoPath:(char*)[self.filePath UTF8String] outPutVideoPath:(char*)[self.subFileNameFieldText UTF8String] startTime:(char*)[self.startFieldText UTF8String] duration:(char*)[self.endFieldText UTF8String]];
}

- (void)threadWillExit {
    if ([NSThread currentThread] == self.cutThread) {
        WEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.playButton.hidden = NO;
            [SVProgressHUD dismiss];
        });
    }
}

#pragma mark - Getter

- (UILabel *)fileDesc {
    if (!_fileDesc) {
        _fileDesc = [UILabel new];
        _fileDesc.textColor = HEXCOLOR(0x666666);
        _fileDesc.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _fileDesc.text = @"Please choose file first!";
    }
    return _fileDesc;
}

- (UILabel *)startTime {
    if (!_startTime) {
        _startTime = [UILabel new];
        _startTime.textColor = HEXCOLOR(0x888888);
        _startTime.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _startTime.text = @"Start time:";
    }
    return _startTime;
}

- (UILabel *)durationTime {
    if (!_durationTime) {
        _durationTime = [UILabel new];
        _durationTime.textColor = HEXCOLOR(0x888888);
        _durationTime.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _durationTime.text = @"Dutation: ";
    }
    return _durationTime;
}

- (UILabel *)subFileName {
    if (!_subFileName) {
        _subFileName = [UILabel new];
        _subFileName.textColor = HEXCOLOR(0x888888);
        _subFileName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _subFileName.text = @"New name:";
    }
    return _subFileName;
}

- (UITextField *)startField {
    if (!_startField) {
        _startField = [UITextField new];
        _startField.placeholder = @" Please input start time with second";
        _startField.backgroundColor = HEXCOLOR(0xf1f1f1);
        _startField.textColor = HEXCOLOR(0x666666);
        _startField.font = [UIFont systemFontOfSize:13];
        _startField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _startField;
}

- (UITextField *)endField {
    if (!_endField) {
        _endField = [UITextField new];
        _endField.placeholder = @" Please input duration with second";
        _endField.backgroundColor = HEXCOLOR(0xf1f1f1);
        _endField.textColor = HEXCOLOR(0x666666);
        _endField.font = [UIFont systemFontOfSize:13];
        _endField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _endField;
}

- (UITextField *)subFileNameField {
    if (!_subFileNameField) {
        _subFileNameField = [UITextField new];
        _subFileNameField.placeholder = @" Please input new file name";
        _subFileNameField.backgroundColor = HEXCOLOR(0xf1f1f1);
        _subFileNameField.textColor = HEXCOLOR(0x666666);
        _subFileNameField.font = [UIFont systemFontOfSize:13];
    }
    return _subFileNameField;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton new];
        [_startButton setTitle:@"Start" forState:UIControlStateNormal];
        [_startButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_startButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
        [_startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
        _startButton.backgroundColor = HEXCOLOR(0x6ed56c);
        _startButton.layer.cornerRadius = 5.f;
        _startButton.layer.masksToBounds = YES;
    }
    return _startButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton new];
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
        [_playButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_playButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
        [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        _playButton.hidden = YES;
        _playButton.backgroundColor = HEXCOLOR(0xF05353);
        _playButton.layer.cornerRadius = 5.f;
        _playButton.layer.masksToBounds = YES;
    }
    return _playButton;
}

- (NSThread *)cutThread {
    if (!_cutThread) {
        _cutThread = [[NSThread alloc]initWithTarget:self selector:@selector(startCutThread) object:nil];
    }
    return _cutThread;
}

@end
