//
//  FDFFmpegMuxMediaController.m
//  FastDemo
//
//  Created by Jason on 2019/1/13.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "FDFFmpegMuxMediaController.h"
#import "FDFilesListController.h"
#import "KxMovieViewController.h"
#import "FFmpegCmdManager.h"
#import "SVProgressHUD.h"
#import "FDKit.h"

@interface FDFFmpegMuxMediaController ()

@property (nonatomic, strong) UILabel *inputFileLabel1;
@property (nonatomic, strong) UILabel *inputFileLabel2;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UITextField *subFileNameField;

@property (nonatomic, strong) NSString *inputPath1;
@property (nonatomic, strong) NSString *inputPath2;

@property (nonatomic, assign) NSInteger videoDuration;
@property (nonatomic, assign) NSInteger audioDuration;

@property (nonatomic, strong) NSString *tmpAudioPath;
@property (nonatomic, strong) NSString *subFileNameFieldText;

@property (nonatomic, strong) NSThread *cutAudioThread;
@property (nonatomic, strong) NSThread *concatThread;

@end

@implementation FDFFmpegMuxMediaController

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
    self.navigationBar.title = @"Mixture Media";
    self.navigationBar.parts = FDNavigationBarPartBack;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void)addsubview {
    [self.view addSubview:self.inputFileLabel1];
    [self.view addSubview:self.inputFileLabel2];
    [self.view addSubview:self.subFileNameField];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.playButton];
    
    [self.inputFileLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(30);
    }];
    
    [self.inputFileLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(self.inputFileLabel1.mas_bottom).offset(30);
    }];
    
    [self.subFileNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(self.inputFileLabel2.mas_bottom).offset(30);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@40);
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

- (void)handleInputLabel1 {
    WEAKSELF
    FDFilesListController *fileList = [FDFilesListController new];
    fileList.type = FDFileChooseVideo;
    fileList.chooseFinishBlock = ^(id path) {
        weakSelf.inputPath1 = path;
        AVAsset *aset = [AVAsset assetWithURL:[NSURL fileURLWithPath:weakSelf.inputPath1]];
        CMTimeValue aduration = aset.duration.value / aset.duration.timescale;
        weakSelf.videoDuration = (NSInteger)aduration;
        weakSelf.inputFileLabel1.text = [NSString stringWithFormat:@"Input video: %@ Duration: %llds", weakSelf.inputPath1.lastPathComponent,aduration];
    };
    [self.navigationController pushViewController:fileList animated:YES];
}

- (void)handleInputLabel2 {
    WEAKSELF
    FDFilesListController *fileList = [FDFilesListController new];
    fileList.type = FDFileChooseAudio;
    fileList.chooseFinishBlock = ^(id path) {
        weakSelf.inputPath2 = path;
        AVAsset *aset = [AVAsset assetWithURL:[NSURL fileURLWithPath:weakSelf.inputPath2]];
        CMTimeValue aduration = aset.duration.value / aset.duration.timescale;
        weakSelf.audioDuration = (NSInteger)aduration;
        weakSelf.inputFileLabel2.text = [NSString stringWithFormat:@"Input Audio: %@ Duration: %llds", weakSelf.inputPath2.lastPathComponent,aduration];
    };
    [self.navigationController pushViewController:fileList animated:YES];
}

- (void)startAction {
    [self.subFileNameField resignFirstResponder];
    
    if (EMPLYSTRING(self.subFileNameField.text)) {
        [SVProgressHUD showErrorWithStatus:@"Please set a name for new file!"];
        return;
    }
    [self.subFileNameField resignFirstResponder];
    if (self.audioDuration > self.videoDuration) {
        NSString *tmp = [NSString stringWithFormat:@"%@/tmp.aac",FDPathTemp];
        if ([[NSFileManager defaultManager] fileExistsAtPath:tmp]) {
            [[NSFileManager defaultManager] removeItemAtPath:tmp error:nil];
        }
        self.tmpAudioPath = tmp;
    }
    NSString *oFileName = self.inputPath1.lastPathComponent;
    if ([oFileName containsString:@"."]) {
        NSArray *cp = [oFileName componentsSeparatedByString:@"."];
        self.subFileNameFieldText = [NSString stringWithFormat:@"%@/%@.%@",FDPathDocument,self.subFileNameField.text,cp.lastObject];
        [SVProgressHUD show];
        if (self.audioDuration > self.videoDuration) {
            [self.cutAudioThread start];
        } else {
            [self.concatThread start];
        }
    }
}

- (void)startConcatThread {
    FFmpegCmdManager *manager = [FFmpegCmdManager new];
    if(!EMPLYSTRING(self.tmpAudioPath)) {
        [manager concatVideoPath:(char *)[self.inputPath1 UTF8String] audioPath:(char *)[self.tmpAudioPath UTF8String] outPutVideoPath:(char *)[self.subFileNameFieldText UTF8String]];
    } else {
        [manager concatVideoPath:(char *)[self.inputPath1 UTF8String] audioPath:(char *)[self.inputPath2 UTF8String] outPutVideoPath:(char *)[self.subFileNameFieldText UTF8String]];
    }
}

- (void)startCutThread {
    FFmpegCmdManager *manager = [FFmpegCmdManager new];
    [manager cutInputAudioPath:(char *)[self.inputPath2 UTF8String] outputAudioPath:(char *)[self.tmpAudioPath UTF8String] startTime:(char *)[@"0" UTF8String] duration:(char *)[@(self.videoDuration).stringValue UTF8String]];
}

- (void)playAction {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:self.subFileNameFieldText parameters:parameters];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)threadWillExit {
    WEAKSELF
    if ([NSThread currentThread] == self.concatThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.concatThread cancel];
            weakSelf.playButton.hidden = NO;
            [SVProgressHUD dismiss];
        });
    } else if([NSThread currentThread] == self.cutAudioThread){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.cutAudioThread cancel];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [weakSelf.concatThread start];
            });
        });
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.subFileNameField resignFirstResponder];
}

#pragma mark - Getter

- (UILabel *)inputFileLabel1 {
    if (!_inputFileLabel1) {
        _inputFileLabel1 = [UILabel new];
        _inputFileLabel1.textColor = HEXCOLOR(0x666666);
        _inputFileLabel1.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _inputFileLabel1.userInteractionEnabled = YES;
        [_inputFileLabel1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleInputLabel1)]];
        _inputFileLabel1.text = @"Tap here!! Choose video.";
    }
    return _inputFileLabel1;
}

- (UILabel *)inputFileLabel2 {
    if (!_inputFileLabel2) {
        _inputFileLabel2 = [UILabel new];
        _inputFileLabel2.textColor = HEXCOLOR(0x666666);
        _inputFileLabel2.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _inputFileLabel2.userInteractionEnabled = YES;
        [_inputFileLabel2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleInputLabel2)]];
        _inputFileLabel2.text = @"Tap here!! Choose audio.";
    }
    return _inputFileLabel2;
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

- (UITextField *)subFileNameField {
    if (!_subFileNameField) {
        _subFileNameField = [UITextField new];
        _subFileNameField.placeholder = @" Please input new file name";
        _subFileNameField.backgroundColor = HEXCOLOR(0xf1f1f1);
        _subFileNameField.textColor = HEXCOLOR(0x666666);
        _subFileNameField.font = [UIFont systemFontOfSize:13];
        _subFileNameField.textAlignment = NSTextAlignmentCenter;
    }
    return _subFileNameField;
}

- (NSThread *)concatThread {
    if (!_concatThread) {
        _concatThread = [[NSThread alloc]initWithTarget:self selector:@selector(startConcatThread) object:nil];
    }
    return _concatThread;
}

- (NSThread *)cutAudioThread {
    if (!_cutAudioThread) {
        _cutAudioThread = [[NSThread alloc]initWithTarget:self selector:@selector(startCutThread) object:nil];
    }
    return _cutAudioThread;
}

@end
