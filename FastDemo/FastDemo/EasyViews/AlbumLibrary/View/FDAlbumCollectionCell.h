//
//  FDAlbumCollectionCell.h
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "FDKit.h"

@interface FDAlbumCollectionCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, copy) fd_block_object selectPhotoAction;

@property (nonatomic, assign) BOOL isSelect;

-(void)loadImage:(NSIndexPath *)indexPath;

@end

