//
//  FDPlayerManager.m
//  FastDemo
//
//  Created by Jason on 2020/1/31.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "FDMusicPlayerManager.h"
#import "YYModel.h"
#import "FDKit.h"

NSString *const kLastMusciModelJasonData = @"kLastMusciModelJasonData";

/* NSNotificationName */
NSString *const kMusicPlayerDidPlaying = @"kMusicPlayerDidPlaying";
NSString *const kMusicPlayerDidPaused = @"kMusicPlayerDidPaused";

static FDMusicPlayerManager *manager;

@interface FDMusicPlayerManager ()

@property (nonatomic, strong) NSString *baseDir;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) NSTimer *progressTimer;

@end

@implementation FDMusicPlayerManager

+ (instancetype)sharePlayerManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[FDMusicPlayerManager alloc]init];
        }
    });
    return manager;
}

- (void)playerWithMusicModel:(FDMusicModel *)musicModel {
    NSString *jsonString = [musicModel yy_modelToJSONString];
    FDSetUserDefaults(jsonString, kLastMusciModelJasonData);
    self.currentMusicModel = musicModel;
    if (self.player) {
        [self.player pause];
        self.player = nil;
    }
    self.playerItem = nil;
    if (self.progressTimer) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
    NSURL *url = [NSURL fileURLWithPath:[self.currentMusicModel fullLocalAudioPath]];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    WEAKSELF
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        if ([weakSelf.delegate respondsToSelector:@selector(updateMusicPlayerProgress:currentTime:)]) {
            if ([weakSelf duration] == 0) {
                return;
            }
            CGFloat progress = [weakSelf currentPlaybackTime]/ [weakSelf duration];
            [weakSelf.delegate updateMusicPlayerProgress:progress currentTime:[weakSelf currentPlaybackTime]];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}

- (NSTimeInterval)currentPlaybackTime {
    return CMTimeGetSeconds([self.player currentTime]);
}

- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [self.player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        return([playerItem duration]);
    }
    
    return(kCMTimeInvalid);
}

- (NSTimeInterval)duration {
    return CMTimeGetSeconds([self playerItemDuration]);
}

- (void)play {
    if (self.player && !self.isPlaying) {
        [self.player play];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMusicPlayerDidPlaying object:nil];
    }
}

- (void)pause {
    if (self.player && self.isPlaying) {
        [self.player pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMusicPlayerDidPaused object:nil];
    }
}

- (void)seekTo:(CGFloat)progress {
     if (self.player.error) {
        return;
    }
    if (self.player.status == AVPlayerStatusReadyToPlay &&
        self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
           CMTime t = CMTimeMake(progress * [self duration], 1);
            [self.player seekToTime:t completionHandler:^(BOOL finished) {
            }];
    }
}

- (void)itemDidPlayToEndTimeNotification:(NSNotification *)notification {
    if ([self.delegate respondsToSelector:@selector(musicDidPlayEnd:)]) {
        [self.delegate musicDidPlayEnd:self.currentMusicModel];
    }
}

#pragma mark - Getter

- (NSString *)baseDir {
    return [FDPathDocument stringByAppendingPathComponent:@"musics"];
}

- (BOOL)isPlaying {
    return self.player.rate != 0.0 && self.player.error == nil;
}

+ (NSString *)musicPlistPath {
    NSString *dir = [FDPathDocument stringByAppendingPathComponent:@"musics"];
    NSString *plistPath = [dir stringByAppendingPathComponent:@"musics.plist"];
    return plistPath;
}

+ (NSArray *)musicList {
    NSArray *data = [NSArray arrayWithContentsOfFile:[self musicPlistPath]];
    NSArray *musics = [NSArray yy_modelArrayWithClass:[FDMusicModel class] json:data].mutableCopy;
    return musics;
}

@end
