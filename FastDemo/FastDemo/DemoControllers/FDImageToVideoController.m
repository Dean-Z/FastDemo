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
#import "FDMovieMaker.h"
#import "FDKit.h"

@interface FDImageToVideoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *demoImageView;
@property (nonatomic, strong) UIButton *showAnimation;
@property (nonatomic, strong) UIButton *makeVideo;
@property (nonatomic, strong) UILabel *makeVideoProgress;

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
        UIImagePickerControllerSourceType sourceType;
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController isSourceTypeAvailable: sourceType]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = weakSelf;
            picker.sourceType = sourceType;
            picker.allowsEditing = NO;
            [weakSelf presentViewController:picker animated:YES completion:nil];
        }
    };
    [self addsubview];
}

- (void)addsubview {
    [self.view addSubview:self.demoImageView];
    [self.demoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(@200);
    }];
    [self.view addSubview:self.showAnimation];
    [self.showAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view).offset(-20);
        make.height.equalTo(@35);
        make.width.equalTo(@120);
    }];
    
    [self.view addSubview:self.makeVideo];
    [self.makeVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.height.equalTo(@35);
        make.width.equalTo(@120);
    }];
    
    [self.view addSubview:self.makeVideoProgress];
    [self.makeVideoProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.makeVideo.mas_centerY);
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
    FDAnimationImageFactory *factory = [FDAnimationImageFactory new];
    factory.screenSize = CGSizeMake(320, 480);
    factory.freamCount = 20;
    factory.totalDuration = 5;
    factory.imageArray = @[self.demoImageView.image];
    WEAKSELF
    [factory render:^(id imageArray) {
       FDMovieMaker *maker = [FDMovieMaker new];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",FDPathDocument,@"test.mov"];
        [maker compressionSession:imageArray filePath:filePath FPS:20 completion:^(float progress, BOOL success) {
            weakSelf.makeVideoProgress.text = [NSString stringWithFormat:@"%.2f",progress];
            if (success) {
                weakSelf.makeVideoProgress.text = @"Succeed!";
            }
        }];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickerImage = info[UIImagePickerControllerOriginalImage];
    self.demoImageView.image = pickerImage;
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
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

- (UILabel *)makeVideoProgress {
    if (!_makeVideoProgress) {
        _makeVideoProgress = [UILabel new];
        _makeVideoProgress.textColor = HEXCOLOR(0x999999);
        _makeVideoProgress.font = [UIFont systemFontOfSize:13];
    }
    return _makeVideoProgress;
}

@end
