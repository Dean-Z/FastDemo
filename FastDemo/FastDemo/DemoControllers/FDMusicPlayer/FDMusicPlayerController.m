//
//  FDMusicPlayerController.m
//  FastDemo
//
//  Created by Jason on 2019/12/24.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "FDMusicPlayerController.h"
#import "FDMusicPlayerManager.h"
#import "FDPlistFileController.h"
#import "FDKit.h"

static NSString * const KRecordIconButtonAnimationPath = @"transform.rotation.z";
static NSString * const KRecordIconButtonAnimationKey = @"KRecordIconButtonAnimationKey";

@interface FDMusicPlayerController ()<FDMusicPlayerManagerDelegate>

@property (nonatomic, strong) UIImageView *backgrounImageView;
@property (nonatomic, strong) FDMusicModel *musicModel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) FDMusicPlayerManager *playerManager;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) UIButton *listBtn;

@property (nonatomic, strong) UIImageView *diskImageView;
@property (nonatomic, strong) UIImageView *centerImageView;

@property (nonatomic, assign) BOOL isSeeking;

@end

@implementation FDMusicPlayerController

+ (instancetype)musicPlayerControllerWithMusicModel:(FDMusicModel *)musicModel {
    FDMusicPlayerController *music = [FDMusicPlayerController new];
    music.musicModel = musicModel;
    return music;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setup];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setup {
    [self.view addSubview:self.backgrounImageView];
    [self.backgrounImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    
    self.navigationBar.title = self.musicModel.name;
    self.navigationBar.parts = FDNavigationBarPartBack;
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.titleLabel.textColor = [UIColor whiteColor];
    self.navigationBar.hiddenBottomLine = YES;
    [self.navigationBar.backItem setImage:[UIImage imageNamed:@"arrow_back_w"] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.progressSlider];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.currentTimeLabel];
    [self.view addSubview:self.durationLabel];
    [self.view addSubview:self.preBtn];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.listBtn];
    [self.view addSubview:self.diskImageView];
    [self.view addSubview:self.centerImageView];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@80);
        make.bottom.equalTo(self.view).offset(-20);
    }];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(WindowSizeW - 80));
        make.bottom.equalTo(self.playButton.mas_top).offset(-50);
    }];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.progressSlider);
        make.top.equalTo(self.progressSlider.mas_bottom).offset(15);
    }];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.progressSlider);
        make.top.equalTo(self.progressSlider.mas_bottom).offset(15);
    }];
    [self.preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playButton.mas_left).offset(-30);
        make.centerY.equalTo(self.playButton);
        make.width.height.equalTo(@(34));
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).offset(30);
        make.centerY.equalTo(self.playButton);
        make.width.height.equalTo(@(34));
    }];
    
    [self.listBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nextBtn.mas_right).offset(20);
        make.centerY.equalTo(self.playButton);
        make.width.height.equalTo(@(34));
    }];
    [self.diskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(80);
        make.width.height.equalTo(@(280));
    }];
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.diskImageView);
        make.width.height.equalTo(@(160));
    }];
}

- (void)loadData {
    UIImage *image = [UIImage imageWithContentsOfFile:[self.musicModel fullLocalPicPath]];
    self.backgrounImageView.image = image;
    self.centerImageView.image = image;
    self.navigationBar.title = self.musicModel.name;
    if (![self.playerManager.currentMusicModel isEqual:self.musicModel]) {
        [self.playerManager playerWithMusicModel:self.musicModel];
    }
    self.playerManager.delegate = self;
    [self.playButton setSelected:self.playerManager.isPlaying];
    [self addEffect];
}

#pragma mark - action

- (void)playAction {
    if (self.playButton.isSelected) {
        [self.playerManager pause];
        [self playerDidPaused];
    } else {
        [self playerDidPlaying];
        [self.playerManager play];
    }
    [self.playButton setSelected:!self.playButton.isSelected];
}

- (void)preAction {
    NSArray *musicList = [FDMusicPlayerManager musicList];
    NSInteger indexCount = [musicList indexOfObject:self.playerManager.currentMusicModel];
    if (indexCount - 1 >= 0) {
        [self exchangeMusicModel:musicList[indexCount - 1]];
    } else {
        [self exchangeMusicModel:musicList.lastObject];
    }
}

- (void)nextAction {
    NSArray *musicList = [FDMusicPlayerManager musicList];
    NSInteger indexCount = [musicList indexOfObject:self.playerManager.currentMusicModel];
    if (indexCount + 1 < musicList.count) {
        [self exchangeMusicModel:musicList[indexCount + 1]];
    } else {
        [self exchangeMusicModel:musicList[0]];
    }
    
}

- (void)exchangeMusicModel:(FDMusicModel *)model {
    self.musicModel = model;
    [self loadData];
    [self.playerManager play];
    [self.playButton setSelected:self.playerManager.isPlaying];
    [self playerDidPlaying];
}

- (void)listAction {
    FDPlistFileController *plist = [FDPlistFileController new];
    plist.filePath = [FDMusicPlayerManager musicPlistPath];
    WEAKSELF
    plist.callBackAction = ^(FDMusicModel *model) {
        [weakSelf exchangeMusicModel:model];
    };
    [self.navigationController pushViewController:plist animated:YES];
}

- (void)progressSliderTouchBegan:(id)sender {
    self.isSeeking = YES;
}

- (void)progressSliderValueChanged:(id)sender {
    self.currentTimeLabel.text = [self timeStringWithTimeInterval:self.progressSlider.value * [self.playerManager duration]];
}

- (void)progressSliderTouchEnded:(id)sender {
    self.currentTimeLabel.text = [self timeStringWithTimeInterval:self.progressSlider.value * [self.playerManager duration]];
    [self.playerManager seekTo:self.progressSlider.value];
    self.isSeeking = NO;
}

#pragma mark - FDMusicPlayerManagerDelegate

- (void)updateMusicPlayerProgress:(CGFloat)progress currentTime:(NSTimeInterval)currentTime {
    if (self.isSeeking) {
        return;
    }
    self.progressSlider.value = progress;
    self.currentTimeLabel.text = [self timeStringWithTimeInterval:currentTime];
    self.durationLabel.text = [self timeStringWithTimeInterval:[self.playerManager duration]];
}

- (void)musicDidPlayEnd:(FDMusicModel *)musicModel {
    [self nextAction];
}

#pragma mark - Effect

- (void)addEffect {
    UIView *tagView = [self.backgrounImageView viewWithTag:100];
    [tagView removeFromSuperview];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, WindowSizeW, WindowSizeH);
    effectView.tag = 100;
    [self.backgrounImageView addSubview:effectView];
    effectView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        effectView.alpha = 0.9f;
    }];
}

- (void)addAnaimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:KRecordIconButtonAnimationPath];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.duration = 10;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.removedOnCompletion = NO;
    [_centerImageView.layer addAnimation:rotationAnimation forKey:KRecordIconButtonAnimationKey];
    [self playerDidPaused];
}

- (void)playerDidPaused {
    [_centerImageView stopAnimating];
    if (_centerImageView.layer.speed != 0) {
        CFTimeInterval pauseTime = [_centerImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        _centerImageView.layer.speed = 0;
        _centerImageView.layer.timeOffset = pauseTime;
    }
}

- (void)playerDidPlaying {
    if (self.centerImageView.layer.speed != 1) {
        CFTimeInterval pauseTime = self.centerImageView.layer.timeOffset;
        self.centerImageView.layer.speed = 1;
        self.centerImageView.layer.timeOffset = 0;
        self.centerImageView.layer.beginTime = 0;
        CFTimeInterval timeSincePause = [self.centerImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
        self.centerImageView.layer.beginTime = timeSincePause;
    }
    [self.centerImageView startAnimating];
}

#pragma mark  - Getter

- (UIImageView *)backgrounImageView {
    if (!_backgrounImageView) {
        _backgrounImageView = [UIImageView new];
        _backgrounImageView.clipsToBounds = YES;
        _backgrounImageView.contentMode = UIViewContentModeCenter;
    }
    return _backgrounImageView;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton new];
        [_playButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        [_playButton.titleLabel setFont:[UIFont systemFontOfSize:35 weight:UIFontWeightBold]];
    }
    return _playButton;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        [_nextBtn setImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIButton *)preBtn {
    if (!_preBtn) {
        _preBtn = [UIButton new];
        [_preBtn setImage:[UIImage imageNamed:@"btn_pre"] forState:UIControlStateNormal];
        [_preBtn addTarget:self action:@selector(preAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preBtn;
}

- (UIButton *)listBtn {
    if (!_listBtn) {
        _listBtn = [UIButton new];
        [_listBtn setImage:[UIImage imageNamed:@"icn_list"] forState:UIControlStateNormal];
        [_listBtn addTarget:self action:@selector(listAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listBtn;
}

- (FDMusicPlayerManager *)playerManager {
    return [FDMusicPlayerManager sharePlayerManager];
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [UILabel new];
        [_currentTimeLabel setFont:[UIFont systemFontOfSize:12]];
        [_currentTimeLabel setTextColor:[UIColor whiteColor]];
    }
    return _currentTimeLabel;
}
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel new];
        [_durationLabel setFont:[UIFont systemFontOfSize:12]];
        [_durationLabel setTextColor:[UIColor whiteColor]];
    }
    return _durationLabel;
}

- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        _progressSlider.minimumTrackTintColor = HEXCOLOR(0xF4F4F4);
        _progressSlider.maximumTrackTintColor = [UIColor colorWithWhite:1.0f alpha:0.5];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"slider_bar"] forState:UIControlStateNormal];
        _progressSlider.minimumValue = 0.;
        _progressSlider.maximumValue = 1.;
        
        [_progressSlider addTarget:self
                        action:@selector(progressSliderTouchBegan:)
              forControlEvents:UIControlEventTouchDown];
        [_progressSlider addTarget:self
                    action:@selector(progressSliderValueChanged:)
          forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self
                    action:@selector(progressSliderTouchEnded:)
          forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    }
    return _progressSlider;
}


- (UIImageView *)diskImageView {
    if (!_diskImageView) {
        _diskImageView = [UIImageView new];
        _diskImageView.image = [UIImage imageNamed:@"cover_program"];
    }
    return _diskImageView;
}

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [UIImageView new];
        _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _centerImageView.layer.cornerRadius = 80.f;
        _centerImageView.layer.masksToBounds = YES;
        [self addAnaimation];
    }
    return _centerImageView;
}

- (NSString *)timeStringWithTimeInterval:(NSTimeInterval)time {
    NSString *min;
    if (time/60 >= 10) {
        min = [NSString stringWithFormat:@"%ld",(NSInteger)time/60];
    } else {
        min = [NSString stringWithFormat:@"0%ld",(NSInteger)time/60];
    }
    NSString *sec;
    if ((NSInteger)time%60 >= 10) {
        sec = [NSString stringWithFormat:@"%ld",(NSInteger)time%60];
    } else {
        sec = [NSString stringWithFormat:@"0%ld",(NSInteger)time%60];
    }
    return [NSString stringWithFormat:@"%@:%@",min, sec];
}
@end
