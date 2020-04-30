//
//  FDAudioRecord.m
//  FastDemo
//
//  Created by Jason on 2020/4/30.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDAudioRecord.h"

@interface FDAudioRecord()

@property (nonatomic, strong) NSMutableArray *recordsArray;
@property (nonatomic, assign) NSInteger recordIndex;

@end

@implementation FDAudioRecord

- (instancetype)init {
    self = [super init];
    self.recordIndex = 0;
    return self;
}

/**
 *  设置录制的音频文件的位置
 *
 */
- (NSString *)audioRecordingPath {
    NSString *result = nil;
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsFolde = [folders objectAtIndex:0];
    result = [documentsFolde stringByAppendingPathComponent:[NSString stringWithFormat:@"record_%ld.aac",(long)self.recordIndex]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:result]) {
        [[NSFileManager defaultManager] removeItemAtPath:result error:nil];
    }
    self.recordIndex ++;
    return (result);
}

- (NSString *)audioCompoundPath {
    NSString *result = nil;
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsFolde = [folders objectAtIndex:0];
    result = [documentsFolde stringByAppendingPathComponent:@"result.aac"];
    return (result);
}

/**
 *  在初始化AVAudioRecord实例之前，需要进行基本的录音设置
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)audioRecordingSettings{
    
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              
                              [NSNumber numberWithFloat:44100.0],AVSampleRateKey ,    //采样率 8000/44100/96000
                              
                              [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,  //录音格式
                              
                              [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,   //线性采样位数  8、16、24、32
                              
                              [NSNumber numberWithInt:2],AVNumberOfChannelsKey,      //声道 1，2
                              
                              [NSNumber numberWithInt:AVAudioQualityLow],AVEncoderAudioQualityKey, //录音质量
                              
                              nil];
    return (settings);
}

/**
 *  停止音频的录制
 *
 *  @param recorder <#recorder description#>
 */
- (void)stopRecordingOnAudioRecorder:(AVAudioRecorder *)recorder{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];  //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [session setActive:YES error:nil];
    [recorder stop];
}

/**
 *  @param recorder <#recorder description#>
 *  @param flag     <#flag description#>
 */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag == YES) {
        NSLog(@"录音完成！");
        self.audioRecorder = nil;
        NSError *playbackError = nil;
        NSError *readingError = nil;
        NSData *fileData = [NSData dataWithContentsOfFile:self.recordsArray.firstObject options:NSDataReadingMapped error:&readingError];

        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithData:fileData
                                                                 error:&playbackError];

        self.audioPlayer = newPlayer;
        
        if (self.audioPlayer != nil) {
            self.audioPlayer.delegate = self;
            if ([self.audioPlayer prepareToPlay] == YES &&
                [self.audioPlayer play] == YES) {
                NSLog(@"开始播放音频！");
            } else {
                NSLog(@"不能播放音频！");
            }
        }else {
            NSLog(@"播放失败！");
        }
    } else {
        NSLog(@"录音过程意外终止！");
    }
}


/**
 *  初始化音频检查
 */
-(void)initRecordSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
}

/**
 *  开始录音
 */
- (void)onStatrRecord {
    
    /**
     *  检查权限
     */
    if (![self canRecord]) {
        NSLog(@"未开启麦克风权限");
//        [[[UIAlertView alloc] initWithTitle:nil
//                                    message:[NSString stringWithFormat:@"应用需要访问您的麦克风。请启用麦克风！"]
//                                   delegate:nil
//                          cancelButtonTitle:@"同意"
//                          otherButtonTitles:nil] show];
        return;
    }
    
    [self initRecordSession];
    
    NSError *error = nil;
    NSString *pathOfRecordingFile = [self audioRecordingPath];
    NSURL *audioRecordingUrl = [NSURL fileURLWithPath:pathOfRecordingFile];
    AVAudioRecorder *newRecorder = [[AVAudioRecorder alloc]
                                    initWithURL:audioRecordingUrl
                                    settings:[self audioRecordingSettings]
                                    error:&error];
    self.audioRecorder = newRecorder;
    [self.audioRecorder setMeteringEnabled:YES];
    if (self.audioRecorder != nil) {
        self.audioRecorder.delegate = self;
        if([self.audioRecorder prepareToRecord] == NO){
            return;
        }
        
        if ([self.audioRecorder record] == YES) {
            NSURL *url = [NSURL fileURLWithPath:pathOfRecordingFile];
            if (![self.recordsArray containsObject:url]) {
                [self.recordsArray addObject:url];
            }
            NSLog(@"录音开始！");
        } else {
            NSLog(@"录音失败！");
            self.audioRecorder =nil;
        }
    } else {
        NSLog(@"auioRecorder实例录音器失败！");
    }
}

/**
 *  停止录音
 */
- (void)stopRecord {
    if (self.audioRecorder != nil) {
        if ([self.audioRecorder isRecording] == YES) {
            [self.audioRecorder stop];
        }
        self.audioRecorder = nil;
    }
    if (self.audioPlayer != nil) {
        if ([self.audioPlayer isPlaying] == YES) {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
    }
}


- (void)compoundAllAudios {
    [self dlsyntheticPath:self.recordsArray composeToURL:[self audioCompoundPath] completed:^(NSError *error) {
    }];
}

/** 合成音频文件
 *  @param sourceURLs  需要合并的多个音频文件
 *  @param toURL       合并后音频文件的存放地址
 */
-(void)dlsyntheticPath:(NSArray *)sourceURLs composeToURL:(NSString *)toURL completed:(void (^)(NSError *error))completed {
        //  合并所有的录音文件
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
        //  音频插入的开始时间
    CMTime beginTime = kCMTimeZero;
        //  获取音频合并音轨
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        //  用于记录错误的对象
    NSError *error = nil;
    for (NSURL *sourceURL in sourceURLs) {
        //  音频文件资源
        AVURLAsset  *audioAsset = [[AVURLAsset alloc]initWithURL:sourceURL options:nil];
        //  需要合并的音频文件的区间
        CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
        //  参数说明:
        //  insertTimeRange:源录音文件的的区间
        //  ofTrack:插入音频的内容
        //  atTime:源音频插入到目标文件开始时间
        //  error: 插入失败记录错误
        //  返回:YES表示插入成功,`NO`表示插入失败
        BOOL success = [compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:beginTime error:&error];
        //  如果插入失败,打印插入失败信息
        if (!success) {
            NSLog(@"插入音频失败: %@",error);
        }
        //  记录开始时间
        beginTime = CMTimeAdd(beginTime, audioAsset.duration);
    }
        //  创建一个导入M4A格式的音频的导出对象
    AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    //  文档路径
    NSString *transitPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory , NSUserDomainMask , YES ).firstObject stringByAppendingPathComponent:@"shenmikeaudio.m4a"];
    //  如果目标文件已经存在删除目标文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:transitPath]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:transitPath error:&error];
        if (!success) {
            NSLog(@"删除文件失败:%@",error);
        }else{
            NSLog(@"删除文件:%@成功",transitPath);
        }
    }
        //  导入音视频的URL
    assetExport.outputURL = [NSURL fileURLWithPath:transitPath];
        //  导出音视频的文件格式
    assetExport.outputFileType = @"com.apple.m4a-audio";
        //  导入出
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        //  分发到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 文件管理者
            NSFileManager * manager = [NSFileManager defaultManager];
            if ([manager moveItemAtPath:transitPath toPath:toURL error:nil]) {
                NSLog(@"移动成功");
            }else{
                NSLog(@"移动失败");
            }
            completed(assetExport.error);
            
        });
    }];
 
}

/**
 *  将要录音
 *
 *  @return <#return value description#>
 */
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                
                if (granted) {
                    
                    bCanRecord = YES;
                    
                } else {
                    
                    bCanRecord = NO;
                    
                }
                
            }];
            
        }
    }
    return bCanRecord;
}

- (BOOL)isRecording {
    return [self.audioRecorder isRecording];
}

- (NSMutableArray *)recordsArray {
    if (!_recordsArray) {
        _recordsArray = @[].mutableCopy;
    }
    return _recordsArray;
}

- (Waver *)waver {
    if (!_waver) {
        _waver = [[Waver alloc] initWithFrame:CGRectMake(0, 400, WindowSizeW, 100.0)];
        _waver.backgroundColor = [UIColor whiteColor];
        _waver.waveColor = HEXCOLOR(0x28292E);
        WEAKSELF
        self.waver.waverLevelCallback = ^(Waver * waver) {
            if (weakSelf.isRecording) {
                [weakSelf.audioRecorder updateMeters];
                CGFloat normalizedValue = pow (10, [weakSelf.audioRecorder averagePowerForChannel:0] / 40);
                waver.level = normalizedValue;
            }
        };
    }
    return _waver;
}

@end
