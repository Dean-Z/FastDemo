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
#import "FDKit.h"

@interface FDMusicPlayerController ()

@property (nonatomic, strong) UIImageView *backgrounImageView;
@property (nonatomic, strong) FDMusicModel *musicModel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) AVAudioPlayer *player;

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
    
    [self addEffect];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player stop];
    self.player = nil;
}

- (void)setup {
    [self.view addSubview:self.backgrounImageView];
    [self.backgrounImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    
    self.navigationBar.title = self.musicModel.name;
    self.navigationBar.parts = FDNavigationBarPartBack;
    self.view.backgroundColor = [UIColor whiteColor];
    
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)loadData {
    NSString *filePath = [self.baseDir stringByAppendingString:self.musicModel.localPicPath];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    self.backgrounImageView.image = image;
    
    NSURL *url = [NSURL fileURLWithPath:[self.baseDir stringByAppendingString:self.musicModel.localAudioPath]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player prepareToPlay];
}

- (void)playAction {
    if (self.playButton.isSelected) {
        [self.player pause];
    } else {
        [self.player play];
    }
    [self.playButton setSelected:!self.playButton.isSelected];
    
    FDMusicPlayerManager *playerManager = [FDMusicPlayerManager sharePlayerManager];
    [playerManager playerWithMusicModel:self.musicModel];
}

#pragma mark  - Getter

- (NSString *)baseDir {
    if ([_baseDir hasSuffix:@"/"]) {
        return _baseDir;
    }
    return [_baseDir stringByAppendingString:@"/"];
}

- (UIImageView *)backgrounImageView {
    if (!_backgrounImageView) {
        _backgrounImageView = [UIImageView new];
        _backgrounImageView.clipsToBounds = YES;
        _backgrounImageView.contentMode = UIViewContentModeCenter;
    }
    return _backgrounImageView;
}

- (void)addEffect {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, WindowSizeW, WindowSizeH);
    [self.backgrounImageView addSubview:effectView];
    effectView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        effectView.alpha = 0.9f;
    }];
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton new];
        [_playButton setTitle:@"PLAY" forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playButton setTitle:@"PAUSE" forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        [_playButton.titleLabel setFont:[UIFont systemFontOfSize:35 weight:UIFontWeightBold]];
    }
    return _playButton;
}

@end
