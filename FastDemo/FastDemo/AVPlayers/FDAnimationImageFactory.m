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
    self.demoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.demoImageView.clipsToBounds = YES;
    self.demoImageView.fd_size = CGSizeMake(200, 200);
    
}

- (void)render:(fd_block_object)complete {
    self.screenView.frame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.height);
    self.demoImageView.center = self.screenView.center;
    [self.screenView addSubview:self.demoImageView];
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
    UIImage *result = [self imageWithImage:firstFrame scaledToSize:self.screenSize];
//    NSString *path = [NSString stringWithFormat:@"%@/_0.png",FDPathDocument];
//    [UIImagePNGRepresentation(result) writeToFile:path atomically:YES];
    [dataArray addObject:result];
    CGFloat oneAngle = M_PI/(self.freamCount * self.totalDuration/2.f);
    for (NSInteger i=0; i<self.freamCount * self.totalDuration; i++) {
        sleep(0.01f);
        self.demoImageView.transform = CGAffineTransformRotate(self.demoImageView.transform, oneAngle);
        UIImage *otherFrame = [self.screenView fd_captureScaneView];
        
        if (otherFrame) {
            UIImage *r = [self imageWithImage:otherFrame scaledToSize:self.screenSize];
//            [UIImagePNGRepresentation(r) writeToFile:[NSString stringWithFormat:@"%@/_%ld.png",FDPathDocument,i+1] atomically:YES];
            [dataArray addObject:r];
            NSLog(@"Finish Image idx %ld",i + 1);
        } else {
            NSLog(@"There has one frame nil %ld",i);
        }
    }
    complete(dataArray);
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
