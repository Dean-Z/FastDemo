//
//  FDDismissAnimationTransition.h
//  FastDemo
//
//  Created by Jason on 2018/12/2.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FDDismissAnimationTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) NSArray *pictureFrames;

- (instancetype)initWithDuration:(NSTimeInterval)duration;


@end

