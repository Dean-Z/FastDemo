//
//  UIImage+FDUtils.m
//  FastDemo
//
//  Created by Jason on 2019/1/9.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "UIImage+FDUtils.h"

@implementation UIImage (FDUtils)

- (UIImage *)cropWithSize:(CGSize)size {
    CGSize scaleSize;
    if (self.size.width > size.width &&
        self.size.height > size.height) {
        if (self.size.width - size.width > self.size.height - size.height) {
            scaleSize.height = size.height;
            scaleSize.width = size.height / self.size.height * self.size.width;
        } else {
            scaleSize.width = size.width;
            scaleSize.height = size.width / self.size.width * self.size.height;
        }
    } else {
        if (size.width - self.size.width  > size.height - self.size.height) {
            scaleSize.height = size.height;
            scaleSize.width = size.height / self.size.height * self.size.width;
        } else {
            scaleSize.width = size.width;
            scaleSize.height = size.width / self.size.width * self.size.height;
        }
    }
    UIImage *scaleImage = [self scaledToSize:scaleSize];
    UIGraphicsBeginImageContext(size);
    if (scaleSize.width == size.width) {
        [scaleImage drawAtPoint:CGPointMake(0, -(scaleSize.height - size.height)/2.f)];
    } else {
        [scaleImage drawAtPoint:CGPointMake(-(scaleSize.width - size.width)/2.f , 0)];
    }
    UIImage *cropImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cropImage;
}

-(UIImage*)scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImages = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImages;
}

@end
