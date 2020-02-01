//
//  FDPlayerManager.h
//  FastDemo
//
//  Created by Jason on 2020/1/31.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDMusicModel.h"

extern NSString *const kLastMusciModelJasonData;
extern NSString *const kMusicPlayerDidPlaying;
extern NSString *const kMusicPlayerDidPaused;

@protocol FDMusicPlayerManagerDelegate;

@interface FDMusicPlayerManager : NSObject

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) FDMusicModel *currentMusicModel;
@property (nonatomic, weak) id<FDMusicPlayerManagerDelegate> delegate;

+ (instancetype)sharePlayerManager;
- (void)playerWithMusicModel:(FDMusicModel *)musicModel;

- (void)play;
- (void)pause;

- (NSTimeInterval)duration;
- (void)seekTo:(CGFloat)progress;

+ (NSString *)musicPlistPath;
+ (NSArray *)musicList;

@end

@protocol FDMusicPlayerManagerDelegate <NSObject>

- (void)updateMusicPlayerProgress:(CGFloat)progress currentTime:(NSTimeInterval)currentTime;
- (void)musicDidPlayEnd:(FDMusicModel *)musicModel;

@end
