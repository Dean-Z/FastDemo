//
//  UIView+FDSeparatorView.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "UIView+FDSeparatorView.h"
#import "UIScreen+FDUtils.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "FDFuncations.h"

static const void * FDSeparatorTopViewKey = &FDSeparatorTopViewKey;
static const void * FDSeparatorLeftViewKey = &FDSeparatorLeftViewKey;
static const void * FDSeparatorBottomViewKey = &FDSeparatorBottomViewKey;
static const void * FDSeparatorRightViewKey = &FDSeparatorRightViewKey;

static NSString * const FDSeparatorTopViewPath = @"separatorTopView";
static NSString * const FDSeparatorLeftViewPath = @"separatorLeftView";
static NSString * const FDSeparatorBottomViewPath = @"separatorBottomView";
static NSString * const FDSeparatorRightViewPath = @"separatorRightView";

@interface UIView ()

@property (nonatomic, strong) UIView *separatorTopView;
@property (nonatomic, strong) UIView *separatorLeftView;
@property (nonatomic, strong) UIView *separatorBottomView;
@property (nonatomic, strong) UIView *separatorRightView;

@end

@implementation UIView (FDSeparatorView)

- (void)fd_addSeparatorWithPosition:(FDSeparatorViewPosition)position {
    if ((position & FDSeparatorViewPositionTop)) {
        [self addSeparatorTopView];
    } else {
        self.separatorTopView.hidden = YES;
        [self.separatorTopView removeFromSuperview];
        self.separatorTopView = nil;
    }
    
    if ((position & FDSeparatorViewPositionLeft)) {
        [self addSeparatorLeftView];
    } else {
        self.separatorLeftView.hidden = YES;
        [self.separatorLeftView removeFromSuperview];
        self.separatorLeftView = nil;
    }
    
    if ((position & FDSeparatorViewPositionBottom)) {
        [self addSeparatorBottomView];
    } else {
        self.separatorBottomView.hidden = YES;
        [self.separatorBottomView removeFromSuperview];
        self.separatorBottomView = nil;
    }
    
    if ((position & FDSeparatorViewPositionRight)) {
        [self addSeparatorRightView];
    } else {
        self.separatorRightView.hidden = YES;
        [self.separatorRightView removeFromSuperview];
        self.separatorRightView = nil;
    }
}

#pragma mark - Getter


- (UIView *)separatorTopView {
    return objc_getAssociatedObject(self, FDSeparatorTopViewKey);
}

- (UIView *)separatorLeftView {
    return objc_getAssociatedObject(self, FDSeparatorLeftViewKey);
}

- (UIView *)separatorBottomView {
    return objc_getAssociatedObject(self, FDSeparatorBottomViewKey);
}

- (UIView *)separatorRightView {
    return objc_getAssociatedObject(self, FDSeparatorRightViewKey);
}

- (UIView *)separatorView {
    UIView *separatorView = [UIView new];
    separatorView.backgroundColor = HEXCOLOR(0xf1f1f1);
    [self addSubview:separatorView];
    return separatorView;
}

- (UIView *)addSeparatorTopView {
    UIView *separatorTopView = self.separatorTopView;
    if (!separatorTopView) {
        separatorTopView = [self separatorView];
        [separatorTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([UIScreen onePixel]));
            make.top.left.right.equalTo(self);
        }];
        self.separatorTopView = separatorTopView;
    }
    return separatorTopView;
}

- (UIView *)addSeparatorLeftView {
    UIView *separatorLeftView = self.separatorLeftView;
    if (!separatorLeftView) {
        separatorLeftView = [self separatorView];
        [separatorLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen onePixel]));
            make.top.left.bottom.equalTo(self);
        }];
        self.separatorLeftView = separatorLeftView;
    }
    return separatorLeftView;
}

- (UIView *)addSeparatorBottomView {
    UIView *separatorBottomView = self.separatorBottomView;
    if (!separatorBottomView) {
        separatorBottomView = [self separatorView];
        [separatorBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([UIScreen onePixel]));
            make.left.bottom.right.equalTo(self);
        }];
        self.separatorBottomView = separatorBottomView;
    }
    return separatorBottomView;
}

- (UIView *)addSeparatorRightView {
    UIView *separatorRightView = self.separatorRightView;
    if (!separatorRightView) {
        separatorRightView = [self separatorView];
        [separatorRightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen onePixel]));
            make.top.bottom.right.equalTo(self);
        }];
        self.separatorRightView = separatorRightView;
    }
    return separatorRightView;
}

#pragma mark - Setter

- (void)setSeparatorTopView:(UIView *)separatorTopView {
    [self willChangeValueForKey:FDSeparatorTopViewPath];
    objc_setAssociatedObject(self, FDSeparatorTopViewKey, separatorTopView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:FDSeparatorTopViewPath];
}

- (void)setSeparatorLeftView:(UIView *)separatorLeftView {
    [self willChangeValueForKey:FDSeparatorLeftViewPath];
    objc_setAssociatedObject(self, FDSeparatorLeftViewKey, separatorLeftView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:FDSeparatorLeftViewPath];
}

- (void)setSeparatorBottomView:(UIView *)separatorBottomView {
    [self willChangeValueForKey:FDSeparatorBottomViewPath];
    objc_setAssociatedObject(self, FDSeparatorBottomViewKey, separatorBottomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:FDSeparatorBottomViewPath];
}

- (void)setSeparatorRightView:(UIView *)separatorRightView {
    [self willChangeValueForKey:FDSeparatorRightViewPath];
    objc_setAssociatedObject(self, FDSeparatorRightViewKey, separatorRightView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:FDSeparatorRightViewPath];
}


@end
