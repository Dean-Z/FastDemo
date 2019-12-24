//
//  FDAVPlayerControlle.m
//  FastDemo
//
//  Created by Jason on 2019/1/16.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDAVPlayerController.h"
#import "FDKit.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface FDAVPlayerController ()

@property (strong, nonatomic)AVPlayer *player;
@property (strong, nonatomic)AVPlayerItem *item;
@property (strong, nonatomic)AVPlayerLayer *playerLayer;

@property (assign, nonatomic)BOOL isReadToPlay;
@property (assign, nonatomic)FDAVStatus status;

@property (nonatomic, strong) id mTimeObserver;
@property (nonatomic, assign) BOOL timerEnabled;

@property (strong, nonatomic)UIView *controlBar;
@property (strong, nonatomic)UIButton *playButton;
@property (strong, nonatomic)UILabel *currentTimeLabel;
@property (strong, nonatomic)UILabel *residueTimeLabel;
@property (strong, nonatomic)UISlider *sliderView;

@end

static NSString * formatTimeInterval(CGFloat seconds, BOOL isLeft) {
    seconds = MAX(0, seconds);
    
    NSInteger s = seconds;
    NSInteger m = s / 60;
    NSInteger h = m / 60;
    
    s = s % 60;
    m = m % 60;
    
    NSMutableString *format = [(isLeft && seconds >= 0.5 ? @"-" : @"") mutableCopy];
    if (h != 0) [format appendFormat:@"%ld:%0.2ld", (long)h, (long)m];
    else        [format appendFormat:@"%ld", (long)m];
    [format appendFormat:@":%0.2ld", (long)s];
    
    return format;
}

@implementation FDAVPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.playerLayer];
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.timerEnabled = YES;
    [self addTimePeriodicTimerObserverToPlayerIfEnabled];
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationBar.parts = FDNavigationBarPartBack;
    self.navigationBar.title = self.url.lastPathComponent;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            weakSelf.player = nil;
            weakSelf.item = nil;
        }];
    };
    [self.view addSubview:self.controlBar];
    [self.controlBar addSubview:self.playButton];
    [self.controlBar addSubview:self.currentTimeLabel];
    [self.controlBar addSubview:self.residueTimeLabel];
    [self.controlBar addSubview:self.sliderView];
    [self.controlBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(SafeAreaBottomHeight));
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.controlBar).offset(5);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.top.equalTo(@2);
    }];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).offset(10);
        make.centerY.equalTo(self.playButton);
    }];
    [self.residueTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.controlBar).offset(-20);
        make.centerY.equalTo(self.playButton);
    }];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(10);
        make.centerY.equalTo(self.currentTimeLabel);
        make.right.equalTo(self.residueTimeLabel.mas_left).offset(-10);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"Item Failed");
                self.isReadToPlay = NO;
                self.status = FDFail;
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"Ready To Play");
                self.isReadToPlay = YES;
                self.status = FDReadToPlay;
                self.residueTimeLabel.text = formatTimeInterval(CMTimeGetSeconds([self playerItemDuration]), YES);
                [self addTimePeriodicTimerObserverToPlayerIfEnabled];
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"Item Unknown");
                self.isReadToPlay = NO;
                self.status = FDFail;
                break;
            default:
                break;
        }
    }
    [object removeObserver:self forKeyPath:@"status"];
}

- (void)playAction:(UIButton *)button {
    if (self.status == FDReadToPlay ||
        self.status == FDPaused) {
        [self.player play];
        [button setSelected:YES];
        self.status = FDPaused;
    } else {
        [self.player pause];
        [button setSelected:NO];
        self.status = FDPlay;
    }
}

- (void)addTimePeriodicTimerObserverToPlayerIfEnabled {
    if (self.timerEnabled == NO) {
        return;
    }
    if (self.mTimeObserver) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.mTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                                                   queue:NULL
                                                              usingBlock:^(CMTime time)
                          {
                              [weakSelf updateCurrentPlayedTime];
                          }];
}

- (void)updateCurrentPlayedTime {
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_VALID(playerDuration)) {
        self.residueTimeLabel.text = formatTimeInterval(CMTimeGetSeconds(playerDuration) - [self currentPlaybackTime], YES);
    }
    self.currentTimeLabel.text = formatTimeInterval([self currentPlaybackTime], NO);
    self.sliderView.value = (CGFloat)[self currentPlaybackTime]/CMTimeGetSeconds(playerDuration);
}

- (CMTime)playerItemDuration {
    AVPlayerItem *playerItem = [self.player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}

- (NSTimeInterval)currentPlaybackTime {
    return CMTimeGetSeconds([self.player currentTime]);
}

#pragma mark - Setter

- (void)setUrl:(NSString *)url {
    _url = url;
    NSURL *fileUrl;
    if ([url containsString:@"http"]) {
        fileUrl = [NSURL URLWithString:self.url];
    } else {
        fileUrl = [NSURL fileURLWithPath:url];
    }
    self.item = [AVPlayerItem playerItemWithURL:fileUrl];
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player replaceCurrentItemWithPlayerItem:self.item];
}

#pragma mark - Getter

- (FDAVStatus)status {
    if (self.isReadToPlay) {
        _status = FDReadToPlay;
        if (self.player.rate == 0.0) {
            _status = FDPaused;
        }else if (self.player.rate > 0.0 ){
            _status = FDPlay;
        }
    } else {
        _status = FDFail;
    }
    return _status;
}

- (AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:self.item];
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    }
    return _playerLayer;
}

- (UIView *)controlBar {
    if (!_controlBar) {
        _controlBar = [UIView new];
        _controlBar.backgroundColor = [UIColor whiteColor];
    }
    return _controlBar;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton new];
        [_playButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [UILabel new];
        _currentTimeLabel.textColor = HEXCOLOR(0x666666);
        _currentTimeLabel.font = [UIFont systemFontOfSize:12];
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UILabel *)residueTimeLabel {
    if (!_residueTimeLabel) {
        _residueTimeLabel = [UILabel new];
        _residueTimeLabel.textColor = HEXCOLOR(0x666666);
        _residueTimeLabel.font = [UIFont systemFontOfSize:12];
        _residueTimeLabel.text = @"00:00";
    }
    return _residueTimeLabel;
}

- (UISlider *)sliderView {
    if (!_sliderView) {
        _sliderView = [UISlider new];
        _sliderView.maximumValue = 1.0f;
        _sliderView.maximumTrackTintColor = HEXCOLOR(0x666666);
        _sliderView.minimumTrackTintColor = HEXCOLOR(0x666666);
        _sliderView.thumbTintColor = HEXCOLOR(0x666666);
        [_sliderView setThumbImage:[UIImage imageNamed:@"ml_bar_slider_gray"] forState:UIControlStateNormal];
    }
    return _sliderView;
}

@end
