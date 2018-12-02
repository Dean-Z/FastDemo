//
//  FDPresentAnimationTransition.h
//  FastDemo
//
//  Created by Jason on 2018/12/2.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FDPresentAnimationTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) UIImageView *transitionView;

- (instancetype)initWithDuration:(NSTimeInterval)duration;


@end
