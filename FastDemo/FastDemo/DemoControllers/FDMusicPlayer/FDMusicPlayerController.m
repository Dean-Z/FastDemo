//
//  FDMusicPlayerController.m
//  FastDemo
//
//  Created by Jason on 2019/12/24.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDMusicPlayerController.h"
#import "FDKit.h"

@interface FDMusicPlayerController ()

@property (nonatomic, strong) UIImageView *backgrounImageView;
@property (nonatomic, strong) FDMusicModel *musicModel;

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
}

- (void)loadData {
    NSString *filePath = [self.baseDir stringByAppendingString:self.musicModel.localPicPath];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    self.backgrounImageView.image = image;
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

@end
