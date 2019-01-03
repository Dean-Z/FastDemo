//
//  FDAnimationImageFactory.m
//  FastDemo
//
//  Created by Jason on 2019/1/3.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDAnimationImageFactory.h"
#import "UIView+FDUtils.h"

@interface FDAnimationImageFactory ()

@property (nonatomic, strong) UIView *screenView;
@property (nonatomic, strong) UIImageView *demoImageView;

@end

@implementation FDAnimationImageFactory

- (instancetype)init {
    self = [super init];
    [self setup];
    return self;
}

- (void)setup {
    self.screenView = [UIView new];
    self.screenView.backgroundColor = [UIColor whiteColor];
    self.demoImageView = [UIImageView new];
    self.demoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.demoImageView.fd_size = CGSizeMake(100, 100);
    [self.screenView addSubview:self.demoImageView];
}

- (void)render:(fd_block_object)complete {
    self.screenView.frame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.height);
    self.demoImageView.center = self.screenView.center;
    self.demoImageView.image = self.imageArray.firstObject;
    [self startMakeImages:complete];
}

- (void)startMakeImages:(fd_block_object)complete {
    NSMutableArray *dataArray = @[].mutableCopy;
    UIImage *firstFrame = [self.screenView fd_captureScaneView];
    if (!firstFrame) {
        NSLog(@"capture is nil!!");
        return;
    }
    [dataArray addObject:firstFrame];
    CGFloat oneAngle = M_PI/(self.freamCount * self.totalDuration/2.f);
    for (NSInteger i=0; i<self.freamCount * self.totalDuration; i++) {
        self.demoImageView.transform = CGAffineTransformRotate(self.demoImageView.transform, oneAngle);
        UIImage *otherFrame = [self.screenView fd_captureScaneView];
        if (otherFrame) {
            [dataArray addObject:otherFrame];
        } else {
            NSLog(@"There has one frame nil %ld",i);
        }
    }
    complete(dataArray);
}

@end
