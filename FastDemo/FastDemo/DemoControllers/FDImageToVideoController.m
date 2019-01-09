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
#import "FDMovieMaker.h"
#import "FDKit.h"

@interface FDImageToVideoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *demoImageView;
@property (nonatomic, strong) UIButton *showAnimation;
@property (nonatomic, strong) UIButton *makeVideo;
@property (nonatomic, strong) UILabel *makeVideoProgress;

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
//        UIImagePickerControllerSourceType sourceType;
//        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        if ([UIImagePickerController isSourceTypeAvailable: sourceType]) {
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            picker.delegate = weakSelf;
//            picker.sourceType = sourceType;
//            picker.allowsEditing = NO;
//            [weakSelf presentViewController:picker animated:YES completion:nil];
//        }
        
        [FDAlbumLibraryManager showPhotosManager:weakSelf withMaxImageCount:10 withAlbumArray:^(NSMutableArray<FDPictureModel *> *albumArray) {
            weakSelf.totalCount = albumArray.count;
            for (FDPictureModel *model in albumArray) {
                if (model.highDefinitionImage == nil) {
                    model.getPictureAction = ^(id result){
                        [weakSelf.dataArray addObject:result];
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
    if (self.totalCount != self.dataArray.count) {
        return;
    } else {
        
    }
    FDAnimationImageFactory *factory = [FDAnimationImageFactory new];
    factory.screenSize = CGSizeMake(512, 512);
    factory.freamCount = 20;
    factory.totalDuration = 5;
    NSMutableArray *cropImages = @[].mutableCopy;
    for (UIImage *image in self.dataArray) {
        [cropImages addObject:[self imageWithImage:image scaledToSize:factory.screenSize]];
    }
    factory.imageArray = cropImages;
    WEAKSELF
    [factory render:^(id imageArray) {
       FDMovieMaker *maker = [FDMovieMaker new];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",FDPathDocument,@"test2.mov"];
        [maker compressionSession:imageArray filePath:filePath FPS:10 completion:^(float progress, BOOL success) {
            weakSelf.makeVideoProgress.text = [NSString stringWithFormat:@"%.2f",progress];
            if (success) {
                weakSelf.makeVideoProgress.text = @"Succeed!";
                [imageArray removeAllObjects];
            }
        }];
    }];
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

@end
