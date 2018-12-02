//
//  FDInteractiveTransition.h
//  FastDemo
//
//  Created by Jason on 2018/12/2.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDAlbumBrowserController.h"

@interface FDInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, weak) FDAlbumBrowserController *toViewController;
@property (nonatomic, strong) UIView *fromView;
@property (nonatomic) BOOL interacting;

@end
