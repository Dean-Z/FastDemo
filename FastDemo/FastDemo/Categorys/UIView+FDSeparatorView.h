//
//  UIView+FDSeparatorView.h
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, FDSeparatorViewPosition) {
    FDSeparatorViewPositionNone   = 0,
    FDSeparatorViewPositionTop    = 1 << 0,
    FDSeparatorViewPositionLeft   = 1 << 1,
    FDSeparatorViewPositionRight  = 1 << 2,
    FDSeparatorViewPositionBottom = 1 << 3
};

@interface UIView (FDSeparatorView)

@property (nonatomic, strong, readonly) UIView *separatorTopView;
@property (nonatomic, strong, readonly) UIView *separatorLeftView;
@property (nonatomic, strong, readonly) UIView *separatorBottomView;
@property (nonatomic, strong, readonly) UIView *separatorRightView;

- (void)fd_addSeparatorWithPosition:(FDSeparatorViewPosition)position;

@end

