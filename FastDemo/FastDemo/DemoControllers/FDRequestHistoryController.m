//
//  FDRequestHistoryController.m
//  FastDemo
//
//  Created by Jason on 2018/12/7.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDRequestHistoryController.h"
#import "FDRequestParamsModel.h"
#import "FDKit.h"

@interface FDRequestHistoryController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableview;
@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation FDRequestHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.parts = FDNavigationBarPartBack;
    self.navigationBar.title = @"Request History";
    
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
    self.dataArray = [FDRequestParamsModel allRequests];
    [self.tableview reloadData];
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        FDRequestParamsModel *model = self.dataArray[indexPath.row];
        cell.textLabel.text = model.requestUrl;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Getter

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [UITableView new];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

@end
