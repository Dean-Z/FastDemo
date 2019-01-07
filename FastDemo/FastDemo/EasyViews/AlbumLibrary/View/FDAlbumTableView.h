//
//  FDAlbumTableView.h
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDKit.h"

@class FDAlbumModel;

@interface FDAlbumTableView : UITableView

@property (nonatomic, strong) NSMutableArray<FDAlbumModel *> *assetCollectionList;

@property (nonatomic, copy) fd_block_object selectAction;

@end
