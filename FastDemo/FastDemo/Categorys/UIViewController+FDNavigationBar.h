//
//  UIViewController+FDNavigationBar.h
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FDNavigationBar)

@property (nullable, nonatomic, strong, readonly) FDNavigationBar *navigationBar;

@end

NS_ASSUME_NONNULL_END
