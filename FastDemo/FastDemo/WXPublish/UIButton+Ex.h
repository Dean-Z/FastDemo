//
//  UIButton+Ex.h
//  FastDemo
//
//  Created by Jason on 2020/4/30.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TYButtonEdgeInsetsStyle) {
    TYButtonEdgeInsetsStyleTop, // image在上，label在下
    TYButtonEdgeInsetsStyleLeft, // image在左，label在右
    TYButtonEdgeInsetsStyleBottom, // image在下，label在上
    TYButtonEdgeInsetsStyleRight // image在右，label在左
};


@interface UIButton (Ex)
/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(TYButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;
@end
