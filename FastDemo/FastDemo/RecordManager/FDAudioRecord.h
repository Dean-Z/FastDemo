//
//  FDAudioRecord.h
//  FastDemo
//
//  Created by Jason on 2020/4/30.
//  Copyright © 2020 Jason. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "Waver.h"
#import "FDKit.h"

@interface FDAudioRecord : NSObject<AVAudioRecorderDelegate, AVAudioPlayerDelegate>

/**
 *  录音器
 */
@property (nonatomic, retain) AVAudioRecorder *audioRecorder;

/**
 *  录音播放器
 */
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic, copy) fd_block_int durationBlock;

@property (nonatomic, strong) Waver *waver;

/**
 *  将要录音
 *
 *  @return return value description
 */
- (BOOL)canRecord;

/**
 *  停止录音
 */
- (void)stopRecord;

/**
 *  开始录音
 */
- (void)onStatrRecord;

/**
 *  初始化音频检查
 */
-(void)initRecordSession;


/**
 *  初始化文件存储路径
 *
 *  @return return value description
 */
- (NSString *)audioRecordingPath;


- (void)compoundAllAudios;

@end
