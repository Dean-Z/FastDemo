//
//  UIScreen+FDUtils.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "UIScreen+FDUtils.h"

@implementation UIScreen (FDUtils)

+ (CGFloat)onePixel {
    return 1.0 / [self mainScreen].scale;
}

@end
