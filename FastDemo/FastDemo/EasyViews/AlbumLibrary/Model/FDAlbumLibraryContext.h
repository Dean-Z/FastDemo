//
//  FDAlbumLibraryContext.h
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDKit.h"

@class FDPictureModel;

@interface FDAlbumLibraryContext : NSObject

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) int choiceCount;

@property (nonatomic, strong) NSMutableArray<FDPictureModel *> *photoModelList;

@property (nonatomic, copy) fd_block_int choiceCountChange;

+(FDAlbumLibraryContext*)standardAlbumLibraryContext;



@end


