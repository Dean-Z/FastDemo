//
//  FDPlistFileController.m
//  FastDemo
//
//  Created by Jason on 2019/12/24.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDPlistFileController.h"
#import "FDMusicPlayerController.h"
#import "FDFilesCell.h"
#import "FDMusicModel.h"
#import "YYModel.h"
#import "FDKit.h"

@interface FDPlistFileController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FDPlistFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *data = [NSArray arrayWithContentsOfFile:self.filePath];
    self.dataArray = [NSArray yy_modelArrayWithClass:[FDMusicModel class] json:data].mutableCopy;
    [self setup];
}

- (void)setup {
    self.navigationBar.title = self.filePath.lastPathComponent;
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

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FDFilesCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FDFilesCell class])];
    FDMusicModel *model = self.dataArray[indexPath.row];
    [cell renderWithMusic:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FDMusicModel *model = self.dataArray[indexPath.row];
    if (self.callBackAction) {
        self.callBackAction(model);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        FDMusicPlayerController *player = [FDMusicPlayerController musicPlayerControllerWithMusicModel:model];
        [self.navigationController pushViewController:player animated:YES];
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorColor = HEXCOLOR(0xf1f1f1);
        [_tableView registerClass:[FDFilesCell class] forCellReuseIdentifier:NSStringFromClass([FDFilesCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[UIView new]];
    }
    return _tableView;
}

@end
