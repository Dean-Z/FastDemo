//
//  FDAlbumLibraryManager.h
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDAlbumModel.h"

@interface FDAlbumLibraryManager : NSObject

+(void)showPhotosManager:(UIViewController *)viewController withMaxImageCount:(NSInteger)maxCount withAlbumArray:(void(^)(NSMutableArray<FDPictureModel *> *albumArray))albumArray;

@end
