//
//  FDFFmpegImageToVideoController.m
//  FastDemo
//
//  Created by Jason on 2019/1/15.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDFFmpegImageToVideoController.h"
#import "FDAnimationImageFactory.h"
#import "FDPlayerManager.h"
#import "FDAlbumLibraryManager.h"
#import "UIImage+FDUtils.h"
#import "FFmpegCmdManager.h"
#import "SVProgressHUD.h"
#import "FDKit.h"

@interface FDFFmpegImageToVideoController ()

@property (nonatomic, strong) UILabel *pictureCountLabel;
@property (nonatomic, strong) UITextField *maxImagesCountField;
@property (nonatomic, strong) UITextField *subFileNameField;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *makeVideo;

@property (nonatomic, strong) NSString *subFileNameFieldText;
@property (nonatomic, strong) NSString *imagesPath;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSThread *concatThread;
@property (nonatomic) NSInteger totalCount;

@end

@implementation FDFFmpegImageToVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self addsubview];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(threadWillExit)
                                                name:NSThreadWillExitNotification
                                              object:nil];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.title = @"Image to video";
    self.navigationBar.parts = FDNavigationBarPartBack | FDNavigationBarPartAdd;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.navigationBar.onClickAddAction = ^{
        [FDAlbumLibraryManager showPhotosManager:weakSelf withMaxImageCount:8 withAlbumArray:^(NSMutableArray<FDPictureModel *> *albumArray) {
            weakSelf.totalCount = albumArray.count;
            for (FDPictureModel *model in albumArray) {
                if (model.highDefinitionImage == nil) {
                    model.getPictureAction = ^(id result){
                        if (result) {
                            [weakSelf.dataArray addObject:result];
                            weakSelf.pictureCountLabel.text = [NSString stringWithFormat:@"Current choosed images count: %ld",(long)weakSelf.dataArray.count];
                        }
                    };
                } else {
                    [weakSelf.dataArray addObject:model.highDefinitionImage];
                    weakSelf.pictureCountLabel.text = [NSString stringWithFormat:@"Current choosed images count: %ld",(long)weakSelf.dataArray.count];
                }
            }
        }];
    };
}

- (void)addsubview {
    [self.view addSubview:self.pictureCountLabel];
//    [self.view addSubview:self.maxImagesCountField];
    [self.view addSubview:self.subFileNameField];
    [self.view addSubview:self.makeVideo];
    [self.view addSubview:self.playButton];
    
    [self.pictureCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(20);
    }];
    
//    [self.maxImagesCountField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@20);
//        make.top.equalTo(self.pictureCountLabel.mas_bottom).offset(20);
//        make.right.equalTo(self.view).offset(-20);
//        make.height.equalTo(@40);
//    }];
    
    [self.subFileNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(self.pictureCountLabel.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@40);
    }];
    
    [self.makeVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.subFileNameField.mas_bottom).offset(30);
        make.height.equalTo(@35);
        make.width.equalTo(@120);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.makeVideo.mas_bottom).offset(20);
        make.height.equalTo(@40);
        make.width.equalTo(@120);
        make.centerX.equalTo(self.view);
    }];
}

- (void)startMakeMovieAction {
    if (self.totalCount != self.dataArray.count) {
        return;
    }
    FDAnimationImageFactory *factory = [FDAnimationImageFactory new];
    factory.screenSize = CGSizeMake(512, 512);
    factory.freamCount = 20;
    factory.totalDuration = 5;
    factory.saveTmpPic = YES;
    NSMutableArray *cropImages = @[].mutableCopy;
    for (UIImage *image in self.dataArray) {
        [cropImages addObject:[image cropWithSize:factory.screenSize]];
    }
    factory.imageArray = cropImages;
    self.makeVideo.userInteractionEnabled = NO;
    WEAKSELF
    [SVProgressHUD show];
    [factory render:^(id images) {
        weakSelf.subFileNameFieldText = [NSString stringWithFormat:@"%@/%@.%@",FDPathDocument,self.subFileNameField.text,@"mp4"];
        weakSelf.imagesPath = [NSString stringWithFormat:@"%@/%@",images,@"%5d.jpg"];
        [weakSelf.concatThread start];
    }];
}

- (void)startConcatThread {
    FFmpegCmdManager *manager = [FFmpegCmdManager new];
    [manager concatImages:(char *)[self.imagesPath UTF8String] rate:(char *)[@(20).stringValue UTF8String] toVideo:(char *)[self.subFileNameFieldText UTF8String]];
}

- (void)threadWillExit {
    if ([NSThread currentThread] == self.concatThread) {
        WEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.playButton.hidden = NO;
            [SVProgressHUD dismiss];
        });
    }
}

- (void)playAction {
    [FDPlayerManager showPlayerChooser:self url:self.subFileNameFieldText];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.subFileNameField resignFirstResponder];
    [self.maxImagesCountField resignFirstResponder];
}

#pragma mark - Getter

- (UILabel *)pictureCountLabel {
    if (!_pictureCountLabel) {
        _pictureCountLabel = [UILabel new];
        _pictureCountLabel.textColor = HEXCOLOR(0x666666);
        _pictureCountLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _pictureCountLabel.text = @"Current choosed images count: 0";
    }
    return _pictureCountLabel;
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

- (UITextField *)subFileNameField {
    if (!_subFileNameField) {
        _subFileNameField = [UITextField new];
        _subFileNameField.placeholder = @" Please input new file name";
        _subFileNameField.backgroundColor = HEXCOLOR(0xf1f1f1);
        _subFileNameField.textColor = HEXCOLOR(0x666666);
        _subFileNameField.font = [UIFont systemFontOfSize:13];
        _subFileNameField.textAlignment = NSTextAlignmentCenter;
    }
    return _subFileNameField;
}

- (UITextField *)maxImagesCountField {
    if (!_maxImagesCountField) {
        _maxImagesCountField = [UITextField new];
        _maxImagesCountField.placeholder = @" Please input max imags count";
        _maxImagesCountField.backgroundColor = HEXCOLOR(0xf1f1f1);
        _maxImagesCountField.textColor = HEXCOLOR(0x666666);
        _maxImagesCountField.font = [UIFont systemFontOfSize:13];
        _maxImagesCountField.textAlignment = NSTextAlignmentCenter;
        _maxImagesCountField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _maxImagesCountField;
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (NSThread *)concatThread {
    if (!_concatThread) {
        _concatThread = [[NSThread alloc]initWithTarget:self selector:@selector(startConcatThread) object:nil];
    }
    return _concatThread;
}

@end
