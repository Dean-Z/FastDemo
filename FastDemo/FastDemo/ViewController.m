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
#import "Masonry.h"

#import "FDRequestController.h"
#import "FDDownloadController.h"
#import "FDFilesListController.h"

#import <libavformat/avformat.h>
#import <libavcodec/avcodec.h>
#import <libswscale/swscale.h>
#import <libavutil/avutil.h>
#import <libswresample/swresample.h>
#import <libavdevice/avdevice.h>
#import <libavfilter/avfilter.h>
#import <VideoToolbox/VideoToolbox.h>


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *itemsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
//    av_register_all();
//    avcodec_register_all();
//    avformat_network_init();
//    AVFormatContext *avFormatContext = avformat_alloc_context();
//
//    NSString *url = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
//    if (avformat_open_input(&avFormatContext, [url UTF8String], NULL, NULL) != 0) {
//        av_log(NULL, AV_LOG_ERROR, "Couldn't open file");
//    }
//
//    if (avformat_find_stream_info(avFormatContext, NULL) < 0) {
//        av_log(NULL, AV_LOG_ERROR, "Couldn't find stream information");
//    } else {
//        av_dump_format(avFormatContext, 0, [url cStringUsingEncoding:NSUTF8StringEncoding], NO);
//    }

}

- (void)setup {
    self.navigationBar.title = @"FastDemo";
    [self.view addSubview:self.tableView];
    self.itemsArray = @[@"AFNetworking / Request URL", @"AFNetworking / Download Files", @"NSFileManager / Document Files"];
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
        FDRequestController *requestVC = [FDRequestController new];
        [self.navigationController pushViewController:requestVC animated:YES];
    } else if (indexPath.row == 1) {
        FDDownloadController *downloadVC = [FDDownloadController new];
        [self.navigationController pushViewController:downloadVC animated:YES];
    } else if (indexPath.row == 2) {
        FDFilesListController *fileListVC = [FDFilesListController new];
        [self.navigationController pushViewController:fileListVC animated:YES];
    }
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

@end
