//
//  FDAlbumTableViewCell.h
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDAlbumModel.h"

@interface FDAlbumTableViewCell : UITableViewCell

@property (nonatomic, strong) FDAlbumModel *albumModel;

@property (nonatomic, assign) NSInteger row;

-(void)loadImage:(NSIndexPath *)index;

@end
