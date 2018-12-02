//
//  FDAlbumBrowserController.h
//  FastDemo
//
//  Created by Jason on 2018/12/2.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDAlbumBrowserController : UIViewController

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSArray *albumSouce;
@property (nonatomic, strong) NSArray *imageViewFrames;
@property (nonatomic, weak) UIImageView *currentImageView;
@property (nonatomic) CGAffineTransform currentTransform;
@property (nonatomic) CGRect currentFrame;
@property (nonatomic) NSUInteger currentIndex;

@end
