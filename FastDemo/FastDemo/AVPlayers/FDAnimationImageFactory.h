//
//  FDAnimationImageFactory.h
//  FastDemo
//
//  Created by Jason on 2019/1/3.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FDKit.h"

@interface FDAnimationImageFactory : NSObject

@property (nonatomic) CGSize screenSize;
@property (nonatomic) NSInteger freamCount;  // 每秒多少帧
@property (nonatomic) CGFloat totalDuration; // 持续时长
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic) BOOL saveTmpPic;

- (void)render:(fd_block_object)complete;

@end
