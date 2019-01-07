//
//  FDAlbumTableView.m
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDAlbumTableView.h"
#import "FDAlbumTableViewCell.h"

@interface FDAlbumTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation FDAlbumTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    [self registerClass:[FDAlbumTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FDAlbumTableViewCell class])];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.tableFooterView = [UIView new];
}

-(void)setAssetCollectionList:(NSMutableArray<FDAlbumModel *> *)assetCollectionList {
    _assetCollectionList = assetCollectionList;
    
    [self reloadData];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetCollectionList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FDAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FDAlbumTableViewCell class])];
    
    cell.row = indexPath.row;
    cell.albumModel = self.assetCollectionList[indexPath.row];
    [cell loadImage:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectAction) {
        self.selectAction(self.assetCollectionList[indexPath.row]);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}


@end
