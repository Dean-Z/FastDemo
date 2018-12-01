//
//  UIView+FDUtils.m
//  FastDemo
//
//  Created by Jason on 2018/12/1.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "UIView+FDUtils.h"
#import <objc/runtime.h>
#import "FDKit.h"

@implementation UIView (FDUtils)

- (void)fd_removeAllSubviews
{
    NSArray *subviews = self.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
}

- (void)fd_setOrigX:(CGFloat)origX
{
    CGRect frame = self.frame;
    frame.origin.x = origX;
    self.frame = frame;
}

- (void)fd_setOrigY:(CGFloat)origY
{
    CGRect frame = self.frame;
    frame.origin.y = origY;
    self.frame = frame;
}

- (void)fd_setOrig:(CGPoint)orig
{
    CGRect frame = self.frame;
    frame.origin = orig;
    self.frame = frame;
}

- (void)fd_setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)fd_setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)fd_setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)fd_setOrigY:(CGFloat)origY width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.origin.y = origY;
    frame.size.width = width;
    self.frame = frame;
}

- (void)fd_setByDeltaOfX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.origin.x += x;
    frame.origin.y += y;
    frame.size.width += width;
    frame.size.height += height;
    self.frame = frame;
}

+ (CGFloat)fd_screenPortraitWidth
{
    return MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

+ (CGFloat)fd_screenPortraitHeight
{
    return MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}


- (void)fd_scaleAspectByWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.height = ceilf(frame.size.height * width / frame.size.width);
    frame.size.width = width;
    self.frame = frame;
}

- (void)fd_setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)fd_setCornerRadius:(CGFloat)cornerRadius topLeft:(BOOL)TL topRight:(BOOL)TR bottomLeft:(BOOL)BL bottomRight:(BOOL)BR {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:(TL == YES ? UIRectCornerTopLeft : 0) |
                              (TR == YES ? UIRectCornerTopRight : 0) |
                              (BL == YES ? UIRectCornerBottomLeft : 0) |
                              (BR == YES ? UIRectCornerBottomRight : 0)
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)fd_markRoundCorner
{
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
}


- (CGFloat)fd_x
{
    return self.frame.origin.x;
}

- (CGFloat)fd_y
{
    return self.frame.origin.y;
}

- (void)fd_forceLayout
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGRect)fd_viewFrame1
{
    NSString *rectStr = objc_getAssociatedObject(self, "apputil.viewFrame1");
    return rectStr ? CGRectFromString(rectStr) : CGRectZero;
}

- (void)fd_setViewFrame1:(CGRect)frame
{
    objc_setAssociatedObject(self, "apputil.viewFrame1", NSStringFromCGRect(frame), OBJC_ASSOCIATION_RETAIN);
}

- (UITableView *)tableViewInViewHierarchy
{
    UIView *superView = self.superview;
    while (superView != nil && ![superView isKindOfClass:[UITableView class]] ) {
        superView = superView.superview;
    }
    return [superView isKindOfClass:[UITableView class]] ? (id)superView : nil;
}

- (UIView *)viewInSuperViewsOfClass:(Class)clazz
{
    UIView *superView = self.superview;
    while (superView != nil && ![superView isKindOfClass:clazz] ) {
        superView = superView.superview;
    }
    return [superView isKindOfClass:clazz] ? superView : nil;
}

- (void)drawHorizontalLineFromOrigY:(CGFloat)origY
                          lineWidth:(CGFloat)lineWidth
                              color:(UIColor *)color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetShouldAntialias(context, false);
    CGContextSetStrokeColorWithColor(context,color.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context, 0, origY); //start at this point
    CGContextAddLineToPoint(context, self.bounds.size.width, origY); //draw to this point
    CGContextStrokePath(context);           // and now draw the Path!
    
    CGContextRestoreGState(context);
}

- (void)fd_removeAllGestures
{
    for (id gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
}
- (void)fd_addSubviewInCenter:(UIView *)subview
{
    CGRect frame = self.frame;
    CGRect subviewFrame = subview.frame;
    [self addSubview:subview];
    
    subviewFrame.origin.x = ceilf((frame.size.width - subviewFrame.size.width) / 2);
    subviewFrame.origin.y = ceilf((frame.size.height - subviewFrame.size.height) / 2);
    subview.frame = subviewFrame;
}

+ (void)fd_setScrollViewDragging:(BOOL)dragging
{
    objc_setAssociatedObject(self, "apputil.fd_setScrollViewDragging", [NSNumber numberWithBool:dragging], OBJC_ASSOCIATION_RETAIN);
}

+ (BOOL)fd_isScrollViewDragging
{
    NSNumber *dragging = objc_getAssociatedObject(self, "apputil.fd_setScrollViewDragging");
    return dragging && dragging.boolValue;
}

- (void)fd_addMaskViewWithColor:(UIColor *)color
{
    UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
    maskView.backgroundColor = color;
    maskView.autoresizingMask = ~UIViewAutoresizingNone;
    [self fd_setMaskView:maskView];
}

- (void)fd_setMaskView:(UIView *)view
{
    const void *key = @selector(fd_maskView);
    UIView *existedMask = objc_getAssociatedObject(self, key);
    if (existedMask) {
        [existedMask removeFromSuperview];
    }
    objc_setAssociatedObject(self, key, view, OBJC_ASSOCIATION_RETAIN);
    [self addSubview:view];
    view.autoresizingMask = ~UIViewAutoresizingNone;
    view.frame = self.bounds;
}

- (void)fd_setMaskViewByImage:(NSString *)imageName
{
    UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self fd_setMaskView:v];
}

- (UIView *)fd_maskView
{
    const void *key = @selector(fd_maskView);
    return objc_getAssociatedObject(self, key);
}

- (BOOL)fd_isVisible
{
    return !self.hidden && self.superview && self.alpha > 0;
}

static const char *kRedIndicatorViewKey = "com.kibey.RedIndicator";
- (void)fd_addRedIndicatorByTopMargin:(CGFloat)top rightMargin:(CGFloat)right
{
    UIColor *color = HEXCOLOR(0xF78181);
    [self fd_addIndicatorByColor:color topMargin:top rightMargin:right edge:10];
}

- (void)fd_addRedIndicatorByTopMargin:(CGFloat)top rightMargin:(CGFloat)right edge:(CGFloat)edge
{
    UIColor *color = HEXCOLOR(0xF05353);
    [self fd_addIndicatorByColor:color topMargin:top rightMargin:right edge:edge];
}

- (void)fd_addGreenIndicatorByTopMargin:(CGFloat)top rightMargin:(CGFloat)right
{
    UIColor *color = HEXCOLOR(0x16A5AF);
    [self fd_addIndicatorByColor:color topMargin:top rightMargin:right edge:6];
}

- (void)fd_addIndicatorByColor:(UIColor *)color topMargin:(CGFloat)top rightMargin:(CGFloat)right edge:(CGFloat)edge
{
    [self fd_removeDotIndicator];
    CGRect rect = CGRectMake(0, 0, edge, edge);
    rect.origin.y = top;
    rect.origin.x = floor(self.frame.size.width - rect.size.width - right);
    UIView *v = [[UIView alloc] initWithFrame:rect];
    v.backgroundColor = color;
    v.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    v.layer.masksToBounds = YES;
    v.layer.cornerRadius = edge / 2;
    [self addSubview:v];
    objc_setAssociatedObject(self, kRedIndicatorViewKey, v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fd_removeDotIndicator
{
    UIView *view = objc_getAssociatedObject(self, kRedIndicatorViewKey);
    BOOL removed = view != nil;
    [view removeFromSuperview];
    objc_setAssociatedObject(self, kRedIndicatorViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return removed;
}

- (BOOL)fd_hasDotIndicator
{
    UIView *view = objc_getAssociatedObject(self, kRedIndicatorViewKey);
    return view != nil;
}

- (void)fd_addBadge:(int)num topMargin:(CGFloat)top leftMargin:(CGFloat)left
{
    [self fd_addBadge:num bgColor:nil needMinWidth:YES topMargin:top leftMargin:left];
}

static const char *fdadgeNumberKey = "com.kibey.echo.badge_number";
- (void)fd_addBadge:(int)num bgColor:(UIColor *)color needMinWidth:(BOOL)needMinWidth topMargin:(CGFloat)top leftMargin:(CGFloat)left
{
    [self fd_removeBadge];
    
    if (num == 0) {
        return;
    }
    
    if (!color) {
        color = HEXCOLOR(0x16A5AF);
    }
    
    CGFloat minWidth = 0.f;
    if (needMinWidth) {
        minWidth = 22.f;
    }
    
    CGFloat height = 14.0f;
    CGFloat radius = height / 2;
    CGFloat paddingEdge = 8;
    CGRect rect = CGRectMake(0, 0, 100, height);
    UILabel *bageLabel = [[UILabel alloc] initWithFrame:rect];
    bageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    bageLabel.textColor = [UIColor whiteColor];
    bageLabel.textAlignment = NSTextAlignmentCenter;
    bageLabel.text = [@(num) stringValue];
    
    CGSize fitSize = [bageLabel sizeThatFits:rect.size];
    if (fitSize.width + paddingEdge > minWidth) {
        rect.size.width = fitSize.width + paddingEdge;
    } else {
        rect.size.width = minWidth;
    }
    rect.origin.y = top;
    rect.origin.x = left;
    bageLabel.frame = rect;
    
    bageLabel.backgroundColor = color;
    bageLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    bageLabel.layer.masksToBounds = YES;
    bageLabel.layer.cornerRadius = radius;
    [self addSubview:bageLabel];
    objc_setAssociatedObject(self, fdadgeNumberKey, bageLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)fd_addBadge:(int)num width:(CGFloat)width font:(CGFloat )font bgColor:(UIColor *)color topMargin:(CGFloat)top rightMargin:(CGFloat)right
{
    [self fd_removeBadge];
    
    if (num == 0)
    return;
    
    NSString *numText = num > 99 ? @"99+" : [NSString stringWithFormat:@"%d",num];
    
    CGFloat defaultWidth = 16.0f;
    
    if (width)
    defaultWidth = width;
    
    CGSize size = [numText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName,nil]];
    CGRect rect;
    if (num < 10) {
        rect = CGRectMake(0, 0, defaultWidth, defaultWidth);
    } else {
        rect = CGRectMake(0, 0, size.width + defaultWidth * 3 / 4, defaultWidth);
    }
    
    UILabel *badgeLabel = [[UILabel alloc] initWithFrame:rect];
    badgeLabel.backgroundColor = color;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.layer.cornerRadius = badgeLabel.fd_height / 2;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.text = numText;
    badgeLabel.font = [UIFont systemFontOfSize:font];
    
    [badgeLabel fd_setOrigY:top];
    [badgeLabel fd_setOrigX:(self.fd_width - badgeLabel.fd_width - right)];
    
    [self addSubview:badgeLabel];
    
    objc_setAssociatedObject(self, fdadgeNumberKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)fd_addBadge:(int)num width:(CGFloat)width font:(CGFloat )font bgColor:(UIColor *)color topMargin:(CGFloat)top leftMargin:(CGFloat)left
{
    [self fd_removeBadge];
    
    if (num == 0)
    return;
    
    NSString *numText = num > 99 ? @"99+" : [NSString stringWithFormat:@"%d",num];
    
    CGFloat defaultWidth = 16.0f;
    
    if (width)
    defaultWidth = width;
    
    CGSize size = [numText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName,nil]];
    CGRect rect;
    if (num < 10) {
        rect = CGRectMake(0, 0, defaultWidth, defaultWidth);
    } else {
        rect = CGRectMake(0, 0, size.width + defaultWidth * 3 / 4, defaultWidth);
    }
    
    UILabel *badgeLabel = [[UILabel alloc] initWithFrame:rect];
    badgeLabel.backgroundColor = color;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.layer.cornerRadius = badgeLabel.fd_height / 2;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.text = numText;
    badgeLabel.font = [UIFont systemFontOfSize:font];
    
    [badgeLabel fd_setOrigY:top];
    [badgeLabel fd_setOrigX:left];
    
    [self addSubview:badgeLabel];
    
    objc_setAssociatedObject(self, fdadgeNumberKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


- (void)fd_addBadgeWithDigit:(NSNumber *)num badgeColor:(UIColor *)color borderColor:(UIColor *)borderColor topMargin:(CGFloat)top rightMargin:(CGFloat)right border:(CGFloat)border
{
    [self fd_removeBadge];
    
    if (num.intValue == 0) {
        return;
    }
    
    NSString *text = num.intValue > 99 ? @"99+" : num.stringValue;
    CGFloat height = 16.0f;
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, nil]];
    CGRect rect;
    if (num.integerValue < 10) {
        rect = CGRectMake(border, border, height, height);
    } else {
        rect = CGRectMake(border, border, size.width + 10.5, height);
    }
    UILabel *bageLabel = [[UILabel alloc] initWithFrame:rect];
    bageLabel.backgroundColor = color;
    bageLabel.textAlignment = NSTextAlignmentCenter;
    bageLabel.textColor = [UIColor whiteColor];
    bageLabel.layer.cornerRadius = bageLabel.fd_height / 2;
    bageLabel.layer.masksToBounds = YES;
    bageLabel.text = text;
    bageLabel.font = [UIFont systemFontOfSize:10.0f];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(self.fd_width - bageLabel.fd_width - right, top, bageLabel.fd_width + 2 * border, bageLabel.fd_height + 2 * border)];
    bgView.backgroundColor = borderColor;
    bgView.layer.cornerRadius = bgView.fd_height / 2.;
    bgView.layer.masksToBounds = YES;
    [bgView addSubview:bageLabel];
    
    [self addSubview:bgView];
    
    objc_setAssociatedObject(self, fdadgeNumberKey, bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)fd_hasBadge
{
    UIView *view = objc_getAssociatedObject(self, fdadgeNumberKey);
    return view != nil;
}

- (BOOL)fd_removeBadge
{
    UIView *view = objc_getAssociatedObject(self, fdadgeNumberKey);
    BOOL removed =  (view != nil);
    [view removeFromSuperview];
    objc_setAssociatedObject(self, fdadgeNumberKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return removed;
}

- (UIView *)fd_addOnePXBottomBorderWithColor:(UIColor *)color left:(CGFloat)left right:(CGFloat)right
{
    CGFloat heightOf1Px = 1.0f / [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(left, self.bounds.size.height - heightOf1Px, self.bounds.size.width - left -right, heightOf1Px);
    UIView *bottomBorder = [[UIView alloc] initWithFrame:rect];
    bottomBorder.backgroundColor = color;
    bottomBorder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:bottomBorder];
    return bottomBorder;
}

- (UIView *)fd_addOnePXTopBorderWithColor:(UIColor *)color left:(CGFloat)left right:(CGFloat)right
{
    CGRect rect = CGRectMake(left, 0, self.bounds.size.width - left -right, 1.0f / [UIScreen mainScreen].scale);
    UIView *lineView = [[UIView alloc] initWithFrame:rect];
    lineView.backgroundColor = color;
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:lineView];
    return lineView;
}

- (UIView *)fd_addOnePXRightBorderWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(self.frame.size.width - 1, 0, 1.0f / [UIScreen mainScreen].scale, self.frame.size.height);
    UIView *lineView = [[UIView alloc] initWithFrame:rect];
    lineView.backgroundColor = color;
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [self addSubview:lineView];
    return lineView;
}

- (UIView *)fd_addOnePXLineWithColor:(UIColor *)color
                             originY:(CGFloat)originX
                                left:(CGFloat)left
                               right:(CGFloat)right
{
    CGRect rect = CGRectMake(left, originX, self.bounds.size.width - left -right, 1.0f / [UIScreen mainScreen].scale);
    UIView *lineView = [[UIView alloc] initWithFrame:rect];
    lineView.backgroundColor = color;
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:lineView];
    return lineView;
}

static const char *kScrollToTopViewKey = "com.kibey.echo.tap_to_scroll_top";
- (void)fd_topTapToScrollTopAreaWithTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    tapView.userInteractionEnabled = YES;
    [tapView addGestureRecognizer:tap];
    [self addSubview:tapView];
    tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    objc_setAssociatedObject(self, kScrollToTopViewKey, tapView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)fd_removeTapToScrollTopArea
{
    UIView *view = objc_getAssociatedObject(self, kScrollToTopViewKey);
    [view removeFromSuperview];
    objc_setAssociatedObject(self, kScrollToTopViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)fd_StringTag
{
    const void *key = @selector(fd_StringTag);
    return objc_getAssociatedObject(self, key);
}

- (void)fd_setStringTag:(NSString *)tag
{
    const void *key = @selector(fd_StringTag);
    objc_setAssociatedObject(self, key, tag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)fd_snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,YES,0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (BOOL)fd_isViewFullyVisibleInWindow
{
    if (!self.window) {
        return NO;
    }
    CGRect currentRectInWindow = [self convertRect:self.bounds toView:self.window];
    BOOL result = CGRectContainsRect(self.window.bounds, currentRectInWindow);
    return result;
}

- (void)fd_setAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint oldOrigin = self.frame.origin;
    self.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = self.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    self.center = CGPointMake (self.center.x - transition.x, self.center.y - transition.y);
}

- (void)fd_addRoundCornerWithOffset:(CGFloat)offset
{
    CGRect rect = CGRectInset(self.bounds, offset, offset);
    CGFloat radius = rect.size.width / 2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:radius startAngle:0 endAngle:M_PI*2 clockwise:NO];
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = path.CGPath;
    self.layer.mask = mask;
}

- (BOOL)fd_isShowingInWindow
{
    if (!self.window) {
        return NO;
    }
    
    CGRect currentRectInWindow = [self convertRect:self.bounds toView:self.window];
    BOOL result = CGRectIntersectsRect(self.window.bounds, currentRectInWindow);
    return result;
}

- (void)fd_addSublviewLayout:(UIView *)subView {
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:subView];
    NSArray *consH = [NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:0 metrics:nil views:@{@"view":subView}];
    [self addConstraints:consH];
    
    NSArray *consW = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view" : subView}];
    [self addConstraints:consW];
}
- (void)fd_clearSubviews {
    NSArray *subviews = [NSArray arrayWithArray:self.subviews];
    if ([subviews count] > 0) {
        for (UIView *v in subviews) {
            [v removeFromSuperview];
        }
    }
}

- (void)fd_bringSelfToFront
{
    [self.superview bringSubviewToFront:self];
}

- (void)fd_sendSelfToBack
{
    [self.superview sendSubviewToBack:self];
}

- (void)addSpecialCornerRadius:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end


@implementation UIView (FDFrame)

#pragma mark - Getter

- (CGFloat)fd_left {
    return self.frame.origin.x;
}

- (CGFloat)fd_top {
    return self.frame.origin.y;
}

- (CGFloat)fd_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)fd_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)fd_width {
    return self.frame.size.width;
}

- (CGFloat)fd_height {
    return self.frame.size.height;
}

- (CGFloat)fd_centerX {
    return self.center.x;
}

- (CGFloat)fd_centerY {
    return self.center.y;
}

- (CGPoint)fd_origin {
    return self.frame.origin;
}

- (CGSize)fd_size {
    return self.frame.size;
}

- (UIViewController *)viewController {
    UIViewController *viewController = nil;
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    }
    return viewController;
}

#pragma mark - Setter

- (void)setFd_left:(CGFloat)fd_left {
    CGRect frame = self.frame;
    frame.origin.x = fd_left;
    self.frame = frame;
}

- (void)setFd_top:(CGFloat)fd_top {
    CGRect frame = self.frame;
    frame.origin.y = fd_top;
    self.frame = frame;
}

- (void)setFd_right:(CGFloat)fd_right {
    CGRect frame = self.frame;
    frame.origin.x = fd_right - frame.size.width;
    self.frame = frame;
}

- (void)setFd_bottom:(CGFloat)fd_bottom {
    CGRect frame = self.frame;
    frame.origin.y = fd_bottom - frame.size.height;
    self.frame = frame;
}

- (void)setFd_width:(CGFloat)fd_width {
    CGRect frame = self.frame;
    frame.size.width = fd_width;
    self.frame = frame;
}

- (void)setFd_height:(CGFloat)fd_height {
    CGRect frame = self.frame;
    frame.size.height = fd_height;
    self.frame = frame;
}

- (void)setFd_centerX:(CGFloat)fd_centerX {
    self.center = CGPointMake(fd_centerX, self.center.y);
}

- (void)setFd_centerY:(CGFloat)fd_centerY {
    self.center = CGPointMake(self.center.x, fd_centerY);
}

- (void)setFd_origin:(CGPoint)fd_origin {
    CGRect frame = self.frame;
    frame.origin = fd_origin;
    self.frame = frame;
}

- (void)setFd_size:(CGSize)fd_size {
    CGRect frame = self.frame;
    frame.size = fd_size;
    self.frame = frame;
}

@end


@implementation CALayer (FDFrame)

#pragma mark - Getter

- (CGFloat)fd_left {
    return self.frame.origin.x;
}

- (CGFloat)fd_top {
    return self.frame.origin.y;
}

- (CGFloat)fd_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)fd_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)fd_width {
    return self.frame.size.width;
}

- (CGFloat)fd_height {
    return self.frame.size.height;
}

- (CGFloat)fd_positionX {
    return self.position.x;
}

- (CGFloat)fd_positionY {
    return self.position.y;
}

- (CGPoint)fd_origin {
    return self.frame.origin;
}

- (CGSize)fd_size {
    return self.frame.size;
}

#pragma mark - Setter

- (void)setFd_left:(CGFloat)fd_left {
    CGRect frame = self.frame;
    frame.origin.x = fd_left;
    self.frame = frame;
}

- (void)setFd_top:(CGFloat)fd_top {
    CGRect frame = self.frame;
    frame.origin.y = fd_top;
    self.frame = frame;
}

- (void)setFd_right:(CGFloat)fd_right {
    CGRect frame = self.frame;
    frame.origin.x = fd_right - frame.size.width;
    self.frame = frame;
}

- (void)setFd_bottom:(CGFloat)fd_bottom {
    CGRect frame = self.frame;
    frame.origin.y = fd_bottom - frame.size.height;
    self.frame = frame;
}

- (void)setFd_width:(CGFloat)fd_width {
    CGRect frame = self.frame;
    frame.size.width = fd_width;
    self.frame = frame;
}

- (void)setFd_height:(CGFloat)fd_height {
    CGRect frame = self.frame;
    frame.size.height = fd_height;
    self.frame = frame;
}

- (void)setFd_positionX:(CGFloat)fd_positionX {
    self.position = CGPointMake(fd_positionX, self.position.y);
}

- (void)setFd_positionY:(CGFloat)fd_positionY {
    self.position = CGPointMake(self.position.x, fd_positionY);
}

- (void)setFd_origin:(CGPoint)fd_origin {
    CGRect frame = self.frame;
    frame.origin = fd_origin;
    self.frame = frame;
}

- (void)setFd_size:(CGSize)fd_size {
    CGRect frame = self.frame;
    frame.size = fd_size;
    self.frame = frame;
}

@end

@implementation UIScrollView (FDContent)

#pragma mark - Getter

- (CGFloat)fd_insetTop {
    return self.contentInset.top;
}

- (CGFloat)fd_insetLeft {
    return self.contentInset.left;
}

- (CGFloat)fd_insetBottom {
    return self.contentInset.bottom;
}

- (CGFloat)fd_insetRight {
    return self.contentInset.right;
}

- (CGFloat)fd_offsetX {
    return self.contentOffset.x;
}

- (CGFloat)fd_offsetY {
    return self.contentOffset.y;
}

- (CGFloat)fd_contentWidth {
    return self.contentSize.width;
}

- (CGFloat)fd_contentHeight {
    return self.contentSize.height;
}

#pragma mark - Setter

- (void)setFd_insetTop:(CGFloat)fd_insetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = fd_insetTop;
    self.contentInset = inset;
}

- (void)setFd_insetLeft:(CGFloat)fd_insetLeft {
    UIEdgeInsets inset = self.contentInset;
    inset.left = fd_insetLeft;
    self.contentInset = inset;
}

- (void)setFd_insetBottom:(CGFloat)fd_insetBottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = fd_insetBottom;
    self.contentInset = inset;
}

- (void)setFd_insetRight:(CGFloat)fd_insetRight {
    UIEdgeInsets inset = self.contentInset;
    inset.right = fd_insetRight;
    self.contentInset = inset;
}

- (void)setFd_offsetX:(CGFloat)fd_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = fd_offsetX;
    self.contentOffset = offset;
}

- (void)setFd_offsetY:(CGFloat)fd_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = fd_offsetY;
    self.contentOffset = offset;
}

- (void)setFd_contentWidth:(CGFloat)fd_contentWidth {
    CGSize size = self.contentSize;
    size.width = fd_contentWidth;
    self.contentSize = size;
}

- (void)setFd_contentHeight:(CGFloat)fd_contentHeight {
    CGSize size = self.contentSize;
    size.height = fd_contentHeight;
    self.contentSize = size;
}

- (NSInteger)fd_totalDataCount {
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}
@end
