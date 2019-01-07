//
//  FDAlbumView.h
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDKit.h"

@class FDAlbumModel;

@interface FDAlbumView : UIView

@property (nonatomic, copy) fd_block_object selectAction;
@property (nonatomic, strong) NSMutableArray<FDAlbumModel *> *assetCollectionList;

- (void)showInView:(UIView *)view originY:(CGFloat)originY;
-(void)endAnimate;

@end
