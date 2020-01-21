//
//  DrawingView.m
//  FastDemo
//
//  Created by Jason on 2020/1/21.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "DrawingView.h"

@interface FDBezierPath : UIBezierPath

@property (nonatomic, strong) UIColor *lineColor;

@end

@implementation FDBezierPath

@end

@interface DrawingView ()

@property (nonatomic, strong) NSMutableArray *paths;

@end

@implementation DrawingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.paths = @[].mutableCopy;
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point  = [[touches anyObject] locationInView:self];
    FDBezierPath *path = [[FDBezierPath alloc]init];
    path.lineWidth = arc4random()%9+1;
    path.lineColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1.0f];
    [path moveToPoint:point];
    [self.paths addObject:path];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    FDBezierPath *path = [self.paths lastObject];
    [path addLineToPoint:point];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [[UIColor clearColor] setFill];
    
    for (FDBezierPath *path in self.paths) {
        [path.lineColor set];
        [path stroke];
    }
}

- (void)undo {
    if (self.paths.count > 0) {
        [self.paths removeLastObject];
    }
    [self setNeedsDisplay];
}

@end
