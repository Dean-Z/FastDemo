//
//  FDFilesListController.m
//  FastDemo
//
//  Created by Jason on 2018/12/1.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDAlbumBrowserController.h"
#import "KxMovieViewController.h"
#import "FDFilesListController.h"
#import "FDAnimatedTransition.h"
#import "FDFilesCell.h"

@interface FDFilesListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) FDAnimatedTransition *animatedTransition;

@end

@implementation FDFilesListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self loadData];
}

- (void)setup {
    self.navigationBar.title = @"Document Files";
    self.navigationBar.parts = FDNavigationBarPartBack;
    self.view.backgroundColor = [UIColor whiteColor];
    
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
}

- (void)loadData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    self.dataArray = [fileManager contentsOfDirectoryAtPath:FDPathDocument error:&error].mutableCopy;
    if ([self.dataArray containsObject:@".DS_Store"]) {
        [self.dataArray removeObject:@".DS_Store"];
    }
    NSMutableArray *tmpArray = @[].mutableCopy;
    for (NSString *path in self.dataArray) {
        if ([self ieLegelFilePath:path]) {
            [tmpArray addObject:path];
        }
    }
    self.dataArray = tmpArray;
    if (!error) {
        [self.tableView reloadData];
        [self.tableView setTableFooterView:[UIView new]];
    }
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FDFilesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FDFilesCell class])];
    [cell renderWithFileName:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSInteger row = [indexPath row];
         [self.dataArray removeObjectAtIndex:row];
         [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fileName = self.dataArray[indexPath.row];
    if (self.chooseFinishBlock) {
        self.chooseFinishBlock([NSString stringWithFormat:@"%@/%@",FDPathDocument,fileName]);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([self isImagePath:fileName]) {
        FDAlbumBrowserController *browser = [FDAlbumBrowserController new];
        UIView *fromView = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:NO];
        browser.albumSouce = [self albumSource];
        browser.currentIndex = 0;
        browser.backgroundView = fromView;
        browser.imageViewFrames = nil;
        browser.transitioningDelegate = self.animatedTransition;
        [self presentViewController:browser animated:YES completion:nil];
        [self.animatedTransition setPresentFromWithView:(UIImageView *)self.view];
        [self.animatedTransition setPictureImageViewsFrame:nil];
        [self.animatedTransition setViewController:browser fromWindow:fromView];
    } else if ([self isVideoPath:fileName]) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
        KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:[NSString stringWithFormat:@"%@/%@",FDPathDocument,fileName]
                                                                                   parameters:parameters];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (NSArray *)albumSource {
    NSMutableArray *source = @[].mutableCopy;
    for (NSString *name in self.dataArray) {
        if ([self isImagePath:name]) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",FDPathDocument,name]];
            if (image) {
                [source addObject:image];
            }
        }
    }
    return source;
}

- (BOOL)isAudioPath:(NSString *)filePath {
    return ([filePath hasSuffix:@".mp3"] ||
            [filePath hasSuffix:@".aac"]);
}

- (BOOL)isVideoPath:(NSString *)filePath {
    return ([filePath hasSuffix:@".mov"] ||
            [filePath hasSuffix:@".mp4"] ||
            [filePath hasSuffix:@".flv"]);
}

- (BOOL)isImagePath:(NSString *)filePath {
    return ([filePath hasSuffix:@".jpg"] ||
            [filePath hasSuffix:@".jpeg"] ||
            [filePath hasSuffix:@".png"]);
}

- (BOOL)isCommonPath:(NSString *)filePath {
    return (![filePath containsString:@"realm"]);
}

- (BOOL)ieLegelFilePath:(NSString *)filePath {
    if (self.type == FDFileChoosePicture) {
        return [self isImagePath:filePath];
    } else if(self.type == FDFileChooseVideo) {
        return [self isVideoPath:filePath];
    } else if(self.type == FDFileChooseAudio) {
        return [self isAudioPath:filePath];
    } else if(self.type == FDFileChooseAll) {
       return [self isCommonPath:filePath];
    }
    return NO;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorColor = HEXCOLOR(0xf1f1f1);
        [_tableView registerClass:[FDFilesCell class] forCellReuseIdentifier:NSStringFromClass([FDFilesCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
