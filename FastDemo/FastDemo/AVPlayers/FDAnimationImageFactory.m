//
//  FDAnimationImageFactory.m
//  FastDemo
//
//  Created by Jason on 2019/1/3.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDAnimationImageFactory.h"
#import "UIView+FDUtils.h"

#define KTmpImageFinder  @"tmp"

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
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@%@",FDPathTemp,KTmpImageFinder];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        if (isDir) {
            [fileManager removeItemAtPath:path error:nil];
        }
    }
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)render:(fd_block_object)complete {
    self.screenView.frame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.height);
    [self.screenView addSubview:self.demoImageView];
    self.demoImageView.image = self.imageArray.firstObject;
    [self startMakeImages:complete];
}

- (void)startMakeImages:(fd_block_object)complete {
    if (self.imageArray.count == 1) {
        [self rotateAnimation:complete];
    } else if(self.imageArray.count > 1) {
        [self moveAndDismiss:complete];
    }
}

- (void)moveAndDismiss:(fd_block_object)complete {
    self.demoImageView.frame = self.screenView.bounds;
    NSMutableArray *dataArray = @[].mutableCopy;
    NSInteger tmpIndex = 1;
    // 动画持续时长
    CGFloat duration = 1;
    for (NSInteger index=0; index<self.imageArray.count - 1; index++) {
        if (self.framesBlock) {
            self.framesBlock((int)tmpIndex);
        }
        //开始移动
        UIImageView *fontImageView = [UIImageView new];
        fontImageView.contentMode = UIViewContentModeScaleAspectFill;
        fontImageView.clipsToBounds = YES;
        fontImageView.frame = self.screenView.bounds;
        [self.screenView insertSubview:fontImageView belowSubview:self.demoImageView];
        fontImageView.image = self.imageArray[index + 1];
        
        for (NSInteger j=0; j<self.freamCount * duration; j++) {
            self.demoImageView.frame = CGRectMake(-(j / (CGFloat)self.freamCount * duration)*self.screenSize.width, 0, self.screenSize.width, self.screenSize.height);
            if (j > self.freamCount * duration * 0.4) {
                self.demoImageView.alpha = (self.freamCount * duration - j)/(self.freamCount * duration * 0.4);
            }
            UIImage *otherFrame = [self.screenView fd_captureScaneView];
            if (otherFrame) {
                UIImage *r = [self imageWithImage:otherFrame scaledToSize:self.screenSize];
                [dataArray addObject:r];
                [self ifSaveTmpPic:r index:tmpIndex];
                tmpIndex ++;
                if (j == 0) {
                    for (NSInteger index = 0; index < self.freamCount - 1; index ++) {
                        [dataArray addObject:r];
                        [self ifSaveTmpPic:r index:tmpIndex];
                        tmpIndex ++;
                    }
                }
                NSLog(@"Finish Image idx %ld",j + 1);
            } else {
                NSLog(@"There has one frame nil %ld",j);
            }
            sleep(0.01f);
        }
        [self.demoImageView removeFromSuperview];
        self.demoImageView = fontImageView;
    }
    if (self.saveTmpPic) {
        complete([NSString stringWithFormat:@"%@%@",FDPathTemp,KTmpImageFinder]);
    } else {
        complete(dataArray);
    }
}

- (void)ifSaveTmpPic:(UIImage *)pic index:(NSInteger)index {
    if (self.saveTmpPic) {
        NSString *zeroString = @"00000";
        if (index < 10) {
            zeroString = [zeroString substringToIndex:zeroString.length - 1];
        } else if (index >= 10 && index < 100) {
            zeroString = [zeroString substringToIndex:zeroString.length - 2];
        } else if (index >= 100 && index < 1000) {
            zeroString = [zeroString substringToIndex:zeroString.length - 3];
        } else if (index >= 1000 && index < 10000) {
            zeroString = [zeroString substringToIndex:zeroString.length - 4];
        }
        [UIImageJPEGRepresentation(pic, 0.5) writeToFile:[NSString stringWithFormat:@"%@%@/%@%ld.jpg",FDPathTemp,KTmpImageFinder,zeroString,index] atomically:YES];
    }
}

- (void)rotateAnimation:(fd_block_object)complete {
    self.demoImageView.fd_size = CGSizeMake(200, 200);
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
