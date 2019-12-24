//
//  FDImageToVideoController.m
//  FastDemo
//
//  Created by Jason on 2019/1/2.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDImageToVideoController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FDAnimationImageFactory.h"
#import "FDAlbumLibraryManager.h"
#import "FDPlayerManager.h"
#import "FDMovieMaker.h"
#import "UIImage+FDUtils.h"
#import "FDKit.h"

@interface FDImageToVideoController ()

@property (nonatomic, strong) UIImageView *demoImageView;
@property (nonatomic, strong) UIButton *showAnimation;
@property (nonatomic, strong) UIButton *makeVideo;
@property (nonatomic, strong) UILabel *makeVideoProgress;
@property (nonatomic, strong) UILabel *makeingFramesTips;
@property (nonatomic, strong) UILabel *makeingVideoTips;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) NSInteger totalCount;

@end

@implementation FDImageToVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.title = @"Image To Video";
    self.navigationBar.parts = FDNavigationBarPartBack | FDNavigationBarPartAdd;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.navigationBar.onClickAddAction = ^{
        [FDAlbumLibraryManager showPhotosManager:weakSelf withMaxImageCount:10 withAlbumArray:^(NSMutableArray<FDPictureModel *> *albumArray) {
            weakSelf.totalCount = albumArray.count;
            for (FDPictureModel *model in albumArray) {
                if (model.highDefinitionImage == nil) {
                    model.getPictureAction = ^(id result){
                        if (result) {
                            [weakSelf.dataArray addObject:result];
                        }
                    };
                } else {
                    [weakSelf.dataArray addObject:model.highDefinitionImage];
                }
            }
        }];
    };
    [self addsubview];
}

- (void)addsubview {
//    [self.view addSubview:self.demoImageView];
//    [self.demoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.width.height.equalTo(@200);
//    }];
//    [self.view addSubview:self.showAnimation];
//    [self.showAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(20);
//        make.bottom.equalTo(self.view).offset(-20);
//        make.height.equalTo(@35);
//        make.width.equalTo(@120);
//    }];
    
    [self.view addSubview:self.makeVideoProgress];
    [self.view addSubview:self.makeingFramesTips];
    [self.makeingFramesTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(20);
    }];
    [self.makeVideoProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(self.makeingFramesTips.mas_bottom).offset(20);
    }];
    
    [self.view addSubview:self.makeVideo];
    [self.view addSubview:self.playButton];
    [self.makeVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.makeVideoProgress.mas_bottom).offset(30);
        make.height.equalTo(@35);
        make.width.equalTo(@120);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.makeVideo.mas_bottom).offset(20);
        make.height.equalTo(@35);
        make.width.equalTo(@120);
    }];
    
}

#pragma mark - Action

- (void)showAnimationAction {
    [UIView animateWithDuration:3.f animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        [self.demoImageView setTransform:transform];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3.f animations:^{
            [self.demoImageView setTransform:CGAffineTransformRotate(self.demoImageView.transform, M_PI)];
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)startMakeMovieAction {
    if (self.totalCount != self.dataArray.count) {
        return;
    }
    self.makeingFramesTips.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FDAnimationImageFactory *factory = [FDAnimationImageFactory new];
        factory.screenSize = CGSizeMake(512, 512);
        factory.freamCount = 20;
        factory.totalDuration = 5;
        NSMutableArray *cropImages = @[].mutableCopy;
        for (UIImage *image in self.dataArray) {
            [cropImages addObject:[image cropWithSize:factory.screenSize]];
        }
        factory.imageArray = cropImages;
        WEAKSELF
        [factory render:^(id imageArray) {
            weakSelf.makeingFramesTips.text = @"Frames completed!";
            weakSelf.makeVideoProgress.hidden = NO;
            FDMovieMaker *maker = [FDMovieMaker new];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",FDPathDocument,@"test2.mp4"];
            [maker compressionSession:imageArray filePath:filePath FPS:10 completion:^(float progress, BOOL success) {
                weakSelf.makeVideoProgress.text = [NSString stringWithFormat:@"Makeing video: %d%@",(int)(progress * 100),@"%"];
                if (success) {
                    weakSelf.makeVideoProgress.text = @"Makeing video: 100%";
                    [imageArray removeAllObjects];
                    [weakSelf.playButton setHidden:NO];
                }
            }];
        }];
    });
    
}

- (void)playAction {
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",FDPathDocument,@"test2.mp4"];
    [FDPlayerManager showPlayerChooser:self url:filePath];
}

#pragma mark Getter

- (UIImageView *)demoImageView {
    if (!_demoImageView) {
        _demoImageView = [UIImageView new];
        _demoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _demoImageView.clipsToBounds = YES;
    }
    return _demoImageView;
}

- (UIButton *)showAnimation {
    if (!_showAnimation) {
        _showAnimation = [UIButton new];
        [_showAnimation setTitle:@"Show Animation" forState:UIControlStateNormal];
        [_showAnimation setBackgroundColor:HEXCOLOR(0x6ed56c)];
        [_showAnimation setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_showAnimation.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_showAnimation addTarget:self action:@selector(showAnimationAction) forControlEvents:UIControlEventTouchUpInside];
        _showAnimation.layer.cornerRadius = 5.f;
        _showAnimation.layer.masksToBounds = YES;
    }
    return _showAnimation;
}

- (UIButton *)makeVideo {
    if (!_makeVideo) {
        _makeVideo = [UIButton new];
        [_makeVideo setTitle:@"Make Video" forState:UIControlStateNormal];
        [_makeVideo setBackgroundColor:HEXCOLOR(0x6ed56c)];
        [_makeVideo setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_makeVideo.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_makeVideo addTarget:self action:@selector(startMakeMovieAction) forControlEvents:UIControlEventTouchUpInside];
        _makeVideo.layer.cornerRadius = 5.f;
        _makeVideo.layer.masksToBounds = YES;
    }
    return _makeVideo;
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

- (UILabel *)makeVideoProgress {
    if (!_makeVideoProgress) {
        _makeVideoProgress = [UILabel new];
        _makeVideoProgress.textColor = HEXCOLOR(0x999999);
        _makeVideoProgress.font = [UIFont systemFontOfSize:14];
        _makeVideoProgress.text = @"Makeing video: 0%";
        _makeVideoProgress.hidden = YES;
    }
    return _makeVideoProgress;
}

- (UILabel *)makeingFramesTips {
    if (!_makeingFramesTips) {
        _makeingFramesTips = [UILabel new];
        _makeingFramesTips.textColor = HEXCOLOR(0x999999);
        _makeingFramesTips.font = [UIFont systemFontOfSize:14];
        _makeingFramesTips.text = @"Makeing frames...";
        _makeingFramesTips.hidden = YES;
    }
    return _makeingFramesTips;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

@end
