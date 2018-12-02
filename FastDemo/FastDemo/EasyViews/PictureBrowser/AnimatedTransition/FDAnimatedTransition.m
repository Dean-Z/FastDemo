//
//  FDAnimatedTransition.m
//  FastDemo
//
//  Created by Jason on 2018/12/2.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDAnimatedTransition.h"
#import "FDInteractiveTransition.h"
#import "FDDismissAnimationTransition.h"
#import "FDPresentAnimationTransition.h"

static CGFloat const duration = 0.5;
@interface FDAnimatedTransition ()

@property (nonatomic, strong) FDPresentAnimationTransition *presentAnimationTransition;
@property (nonatomic, strong) FDDismissAnimationTransition *dismissAnimationTransition;
@property (nonatomic, strong) FDInteractiveTransition *interactiveTransition;

@end

@implementation FDAnimatedTransition


#pragma mark - Present

- (void)setPresentFromWithView:(UIImageView *)view {
    self.presentAnimationTransition.transitionView = view;
}

#pragma mark - Dismiss

- (void)setPictureImageViewsFrame:(NSArray *)frames {
    self.dismissAnimationTransition.pictureFrames = frames;
}

#pragma mark - Interactive

- (void)setViewController:(FDAlbumBrowserController *)toViewController fromWindow:(UIView *)fromView {
    self.interactiveTransition.toViewController = toViewController;
    self.interactiveTransition.fromView = fromView;
}


#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.presentAnimationTransition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissAnimationTransition;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

#pragma mark - Setter and getter

- (FDPresentAnimationTransition *)presentAnimationTransition {
    if (!_presentAnimationTransition) {
        _presentAnimationTransition = [[FDPresentAnimationTransition alloc] initWithDuration:duration];
    }
    return _presentAnimationTransition;
}

- (FDDismissAnimationTransition *)dismissAnimationTransition {
    if (!_dismissAnimationTransition) {
        _dismissAnimationTransition = [[FDDismissAnimationTransition alloc] initWithDuration:duration];
    }
    return _dismissAnimationTransition;
}

- (FDInteractiveTransition *)interactiveTransition {
    if (!_interactiveTransition) {
        _interactiveTransition = [FDInteractiveTransition new];
    }
    return _interactiveTransition;
}

@end
