//
//  FDAlbumModel.m
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDAlbumModel.h"

@implementation FDPictureModel

-(void)setAsset:(PHAsset *)asset {
    _asset = asset;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        /// 当选择后获取原图
        [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.highDefinitionImage = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.getPictureAction) {
                    self.getPictureAction(self.highDefinitionImage);
                }
            });
        }];
    });
}

@end

@implementation FDAlbumModel

-(void)setCollection:(PHAssetCollection *)collection {
    _collection = collection;
    
    self.collectionTitle = collection.localizedTitle;
    
    self.assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    
    if (self.assets.count > 0) {
        self.firstAsset = self.assets[0];
    }
    self.collectionNumber = [NSString stringWithFormat:@"%ld", self.assets.count];
}

#pragma mark - Getter
-(NSMutableArray<NSNumber *> *)selectRows {
    if (!_selectRows) {
        _selectRows = [NSMutableArray array];
    }
    
    return _selectRows;
}

@end
