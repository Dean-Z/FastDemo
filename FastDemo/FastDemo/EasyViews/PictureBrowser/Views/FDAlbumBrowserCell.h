//
//  FDAlbumBrowserCell.h
//  FastDemo
//
//  Created by Jason on 2018/12/2.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDBrowserImageView.h"

@interface FDAlbumBrowserCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

- (void)setImageViewDelegate:(id <FDBrowserImageViewTransformDelegate>)delegate;
- (void)setImageViewTag:(NSUInteger)tag;
- (void)showWithSource:(id)source;

@end
