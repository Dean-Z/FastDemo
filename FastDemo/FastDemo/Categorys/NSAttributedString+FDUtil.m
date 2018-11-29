//
//  NSAttributedString+FDUtil.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "NSAttributedString+FDUtil.h"

@implementation NSAttributedString (FDUtil)

- (CGSize)fd_sizeWithWidth:(CGFloat)width {
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:options
                                         context:nil];
    CGSize size = textRect.size;
    size.height = ceilf(size.height);
    size.width  = ceilf(size.width);
    return size;
}

@end
