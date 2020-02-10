//
//  ViewController.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "ViewController.h"
#import "Funcations/FDFuncations.h"
#import "UIViewController+FDNavigationBar.h"
#import "FDMusicPlayerManager.h"
#import "Masonry.h"
#import "YYModel.h"

#import "FDRequestController.h"
#import "FDDownloadController.h"
#import "FDFilesListController.h"

#import "FDFFmpegDemosController.h"
#import "FDAVFoundationDeomController.h"

#import "FDDrawViewController.h"
#import "FDMusicPlayerController.h"

#import "FDMapViewController.h"

static NSString * const KRecordIconButtonAnimationPath = @"transform.rotation.z";
static NSString * const KRecordIconButtonAnimationKey = @"KRecordIconButtonAnimationKey";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) UIButton *recordBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlaying) name:kMusicPlayerDidPlaying object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPaused) name:kMusicPlayerDidPaused object:nil];
}

- (void)setup {
    self.navigationBar.title = @"FastDemo";
    [self.view addSubview:self.tableView];
    self.itemsArray = @[@"AFNetworking / Request URL",
                        @"AFNetworking / Download Files",
                        @"NSFileManager / Document Files",
                        @"FFmpeg",
                        @"AVFoundation",
                        @"CALayer / DrawBoard",
                        @"MapKit"];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self prepareRecordBtn];
}

- (void)prepareRecordBtn {
    [self.navigationBar addSubview:self.recordBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.centerY.equalTo(self.navigationBar.titleLabel);
        make.width.height.equalTo(@(40));
    }];
    [self playerDidPaused];
}

- (void)applicationWillEnterForeground {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    FDMusicModel *model = [FDMusicModel yy_modelWithJSON:board.string];
    if (model.url) {
        FDDownloadController *downloadVC = [FDDownloadController new];
        downloadVC.downloadMusicModel = model;
        [self.navigationController pushViewController:downloadVC animated:YES];
        board.string = @"";
    }
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commonCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.itemsArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        FDRequestController *requestVC = [FDRequestController new];
        [self.navigationController pushViewController:requestVC animated:YES];
    } else if (indexPath.row == 1) {
        FDDownloadController *downloadVC = [FDDownloadController new];
        [self.navigationController pushViewController:downloadVC animated:YES];
    } else if (indexPath.row == 2) {
        FDFilesListController *fileListVC = [FDFilesListController new];
        [self.navigationController pushViewController:fileListVC animated:YES];
    } else if (indexPath.row == 3) {
        FDFFmpegDemosController *ffmpeg = [FDFFmpegDemosController new];
        [self.navigationController pushViewController:ffmpeg animated:YES];
    } else if (indexPath.row == 4) {
        FDAVFoundationDeomController *avfoundation = [FDAVFoundationDeomController new];
        [self.navigationController pushViewController:avfoundation animated:YES];
    } else if (indexPath.row == 5) {
        FDDrawViewController *draw = [FDDrawViewController new];
        [self.navigationController pushViewController:draw animated:YES];
    } else if (indexPath.row == 6) {
        FDMapViewController *map = [FDMapViewController new];
        [self.navigationController pushViewController:map animated:YES];
    }
}

#pragma mark Action

- (void)recordAction {
    if (FDGetUserDefaults(kLastMusciModelJasonData)) {
        FDMusicModel *model = [FDMusicModel yy_modelWithJSON:FDGetUserDefaults(kLastMusciModelJasonData)];
        if (model) {
            FDMusicPlayerController *music = [FDMusicPlayerController musicPlayerControllerWithMusicModel:model];
            [self.navigationController pushViewController:music animated:YES];
        }
    }
}

- (void)playerDidPaused {
    [self.recordBtn.imageView stopAnimating];
    if (self.recordBtn.layer.speed != 0) {
        CFTimeInterval pauseTime = [self.recordBtn.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.recordBtn.layer.speed = 0;
        self.recordBtn.layer.timeOffset = pauseTime;
    }
}

- (void)playerDidPlaying {
    if (self.recordBtn.layer.speed != 1) {
        CFTimeInterval pauseTime = self.recordBtn.layer.timeOffset;
        self.recordBtn.layer.speed = 1;
        self.recordBtn.layer.timeOffset = 0;
        self.recordBtn.layer.beginTime = 0;
        CFTimeInterval timeSincePause = [self.recordBtn.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
        self.recordBtn.layer.beginTime = timeSincePause;
    }
    [self.recordBtn.imageView startAnimating];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorColor = HEXCOLOR(0xf1f1f1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton new];
        [_recordBtn setImage:[UIImage imageNamed:@"disk"] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_recordBtn.layer removeAnimationForKey:KRecordIconButtonAnimationPath];
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:KRecordIconButtonAnimationPath];
        rotationAnimation.fromValue = @(0);
        rotationAnimation.toValue = @(M_PI * 2);
        rotationAnimation.duration = 5;
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.removedOnCompletion = NO;
        [_recordBtn.layer addAnimation:rotationAnimation forKey:KRecordIconButtonAnimationKey];
    }
    return _recordBtn;
}

@end
