//
//  FDFilesListController.m
//  FastDemo
//
//  Created by Jason on 2018/12/1.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDFilesListController.h"
#import "FDFilesCell.h"
#import "FDKit.h"

@interface FDFilesListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

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
    if (!error) {
        [self.tableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
