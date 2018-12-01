//
//  UIView+FDUtils.h
//  FastDemo
//
//  Created by Jason on 2018/12/1.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FDUtil)
- (void)fd_removeAllSubviews;
- (void)fd_setOrigX:(CGFloat)origX;
- (void)fd_setOrigY:(CGFloat)origY;
- (void)fd_setOrig:(CGPoint)orig;
- (void)fd_setWidth:(CGFloat)width;
- (void)fd_setHeight:(CGFloat)height;
- (void)fd_setSize:(CGSize)size;
- (void)fd_setOrigY:(CGFloat)origY width:(CGFloat)width;
- (void)fd_setByDeltaOfX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
+ (CGFloat)fd_screenPortraitWidth;
+ (CGFloat)fd_screenPortraitHeight;

- (void)fd_scaleAspectByWidth:(CGFloat)width;

- (void)fd_setCornerRadius:(CGFloat)cornerRadius;
- (void)fd_setCornerRadius:(CGFloat)cornerRadius topLeft:(BOOL)TL topRight:(BOOL)TR bottomLeft:(BOOL)BL bottomRight:(BOOL)BR;
- (void)fd_markRoundCorner;

- (CGFloat)fd_x;
- (CGFloat)fd_y;
- (void)fd_forceLayout;

- (CGRect)fd_viewFrame1;
- (void)fd_setViewFrame1:(CGRect)frame;

- (UITableView *)tableViewInViewHierarchy;
- (UIView *)viewInSuperViewsOfClass:(Class)clazz;

- (void)drawHorizontalLineFromOrigY:(CGFloat)origY
                          lineWidth:(CGFloat)lineWidth
                              color:(UIColor *)color;

- (void)fd_removeAllGestures;
- (void)fd_addSubviewInCenter:(UIView *)subview;

+ (void)fd_setScrollViewDragging:(BOOL)dragging;
+ (BOOL)fd_isScrollViewDragging;

- (void)fd_addMaskViewWithColor:(UIColor *)color;
- (void)fd_setMaskView:(UIView *)view;
- (void)fd_setMaskViewByImage:(NSString *)imageName;
- (UIView *)fd_maskView;

- (BOOL)fd_isVisible;

- (void)fd_addRedIndicatorByTopMargin:(CGFloat)top rightMargin:(CGFloat)right edge:(CGFloat)edge;
- (void)fd_addRedIndicatorByTopMargin:(CGFloat)top rightMargin:(CGFloat)right;
- (void)fd_addGreenIndicatorByTopMargin:(CGFloat)top rightMargin:(CGFloat)right;
- (BOOL)fd_removeDotIndicator;
- (BOOL)fd_hasDotIndicator;

- (void)fd_addBadge:(int)num
          topMargin:(CGFloat)top
         leftMargin:(CGFloat)left;

- (void)fd_addBadge:(int)num
            bgColor:(UIColor *)color
       needMinWidth:(BOOL)needMinWidth
          topMargin:(CGFloat)top
         leftMargin:(CGFloat)left;

- (void)fd_addBadgeWithDigit:(NSNumber *)num
                  badgeColor:(UIColor *)color
                 borderColor:(UIColor *)borderColor
                   topMargin:(CGFloat)top
                 rightMargin:(CGFloat)right
                      border:(CGFloat)border;

- (void)fd_addBadge:(int)num
              width:(CGFloat)width
               font:(CGFloat)font
            bgColor:(UIColor *)color
          topMargin:(CGFloat)top
        rightMargin:(CGFloat)right;

- (void)fd_addBadge:(int)num
              width:(CGFloat)width
               font:(CGFloat )font
            bgColor:(UIColor *)color
          topMargin:(CGFloat)top
         leftMargin:(CGFloat)left;

- (BOOL)fd_hasBadge;

- (BOOL)fd_removeBadge;

- (UIView *)fd_addOnePXBottomBorderWithColor:(UIColor *)color left:(CGFloat)left right:(CGFloat)right;
- (UIView *)fd_addOnePXTopBorderWithColor:(UIColor *)color left:(CGFloat)left right:(CGFloat)right;
- (UIView *)fd_addOnePXRightBorderWithColor:(UIColor *)color;
- (UIView *)fd_addOnePXLineWithColor:(UIColor *)color originY:(CGFloat)originX left:(CGFloat)left right:(CGFloat)right;

- (void)fd_topTapToScrollTopAreaWithTarget:(id)target action:(SEL)action;
- (void)fd_removeTapToScrollTopArea;

- (NSString *)fd_StringTag;
- (void)fd_setStringTag:(NSString *)tag;

- (UIImage *)fd_snapshot;
- (BOOL)fd_isViewFullyVisibleInWindow;

//if you want to use this. turn off autolayout
- (void)fd_setAnchorPoint:(CGPoint)anchorPoint;

- (void)fd_addRoundCornerWithOffset:(CGFloat)offset;

- (BOOL)fd_isShowingInWindow;

/**
 利用layout方式、将一个subView addsubView到 superView中，同父view同等大小
 */
- (void)fd_addSublviewLayout:(UIView *)subView;
/**
 清理view的子view
 */
- (void)fd_clearSubviews;
- (void)fd_bringSelfToFront;
- (void)fd_sendSelfToBack;
//给view指定的角添加圆角
- (void)addSpecialCornerRadius:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
@end

@interface UIView (FDFrame)

@property (nonatomic) CGFloat fd_left;
@property (nonatomic) CGFloat fd_top;
@property (nonatomic) CGFloat fd_right;
@property (nonatomic) CGFloat fd_bottom;
@property (nonatomic) CGFloat fd_width;
@property (nonatomic) CGFloat fd_height;
@property (nonatomic) CGFloat fd_centerX;
@property (nonatomic) CGFloat fd_centerY;
@property (nonatomic) CGPoint fd_origin;
@property (nonatomic) CGSize  fd_size;

@property (nonatomic, weak, readonly) UIViewController *viewController;

@end

@interface CALayer (FDFrame)

@property (nonatomic) CGFloat fd_left;
@property (nonatomic) CGFloat fd_top;
@property (nonatomic) CGFloat fd_right;
@property (nonatomic) CGFloat fd_bottom;
@property (nonatomic) CGFloat fd_width;
@property (nonatomic) CGFloat fd_height;
@property (nonatomic) CGFloat fd_positionX;
@property (nonatomic) CGFloat fd_positionY;
@property (nonatomic) CGPoint fd_origin;
@property (nonatomic) CGSize  fd_size;

@end


@interface UIScrollView (FDContent)

@property (nonatomic) CGFloat fd_insetTop;
@property (nonatomic) CGFloat fd_insetLeft;
@property (nonatomic) CGFloat fd_insetBottom;
@property (nonatomic) CGFloat fd_insetRight;

@property (nonatomic) CGFloat fd_offsetX;
@property (nonatomic) CGFloat fd_offsetY;

@property (nonatomic) CGFloat fd_contentWidth;
@property (nonatomic) CGFloat fd_contentHeight;

- (NSInteger)fd_totalDataCount;

@end
