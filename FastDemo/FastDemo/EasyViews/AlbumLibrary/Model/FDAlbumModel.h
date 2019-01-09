//
//  FDAlbumModel.h
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "FDKit.h"

@interface FDPictureModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *highDefinitionImage;
@property (nonatomic, copy) fd_block_object getPictureAction;

@end

@interface FDAlbumModel : NSObject

@property (nonatomic, strong) PHAssetCollection *collection;

@property (nonatomic, strong) PHAsset *firstAsset;

@property (nonatomic, strong) PHFetchResult<PHAsset *> *assets;

@property (nonatomic, copy) NSString *collectionTitle;

@property (nonatomic, copy) NSString *collectionNumber;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectRows;

@end
