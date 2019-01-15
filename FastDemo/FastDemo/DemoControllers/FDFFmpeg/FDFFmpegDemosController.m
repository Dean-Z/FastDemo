//
//  FDFFmpegDemosController.m
//  FastDemo
//
//  Created by Jason on 2019/1/1.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDFFmpegDemosController.h"
#import "KxMovieViewController.h"
#import "FDFFmpegCutMediaController.h"
#import "FDFFmpegConcatController.h"
#import "FDFFmpegMuxMediaController.h"
#import "FDFFmpegImageToVideoController.h"
#import "FDKit.h"

@interface FDFFmpegDemosController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemsArray;

@end

@implementation FDFFmpegDemosController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.title = @"FFmpeg";
    self.navigationBar.parts = FDNavigationBarPartBack;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.itemsArray = @[@"Pictures to video",@"Cut Media",@"Concat Media", @"Mixture Video & Audio"];
    
    [self.view addSubview:self.tableView];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
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
        FDFFmpegImageToVideoController *imageToVideo = [FDFFmpegImageToVideoController new];
        [self.navigationController pushViewController:imageToVideo animated:YES];
    } else if (indexPath.row == 1) {
        FDFFmpegCutMediaController *cut = [FDFFmpegCutMediaController new];
        [self.navigationController pushViewController:cut animated:YES];
    } else if(indexPath.row == 2) {
        FDFFmpegConcatController *concat = [FDFFmpegConcatController new];
        [self.navigationController pushViewController:concat animated:YES];
    } else  if(indexPath.row == 3) {
        FDFFmpegMuxMediaController *mux = [FDFFmpegMuxMediaController new];
        [self.navigationController pushViewController:mux animated:YES];
    }
}

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

@end
