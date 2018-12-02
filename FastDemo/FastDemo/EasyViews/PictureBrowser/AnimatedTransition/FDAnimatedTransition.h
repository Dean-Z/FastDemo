//
//  FDAnimatedTransition.h
//  FastDemo
//
//  Created by Jason on 2018/12/2.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FDAlbumBrowserController;

@interface FDAnimatedTransition : NSObject <UIViewControllerTransitioningDelegate>

#pragma mark - Present

- (void)setPresentFromWithView:(UIImageView *)view;

#pragma mark - Dismiss

- (void)setPictureImageViewsFrame:(NSArray *)frames;

#pragma mark - Interactive

- (void)setViewController:(FDAlbumBrowserController *)toViewController fromWindow:(UIView *)fromView;

@end
