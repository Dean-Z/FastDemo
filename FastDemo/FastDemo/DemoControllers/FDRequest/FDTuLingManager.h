//
//  FDTuLingManager.h
//  FastDemo
//
//  Created by Jason on 2020/4/16.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDKit.h"

typedef enum : NSUInteger {
    FDTLRobotStateColsed,
    FDTLRobotStateLinsening,
    FDTLRobotStateOpened,
} FDTLRobotState;

@interface FDTuLingManager : NSObject

@property (nonatomic, strong, class) FDTuLingManager *manager;
@property (nonatomic, assign) FDTLRobotState robotState;

- (void)maybeTakeWithRobot:(NSString *)content complete:(fd_block_object)complete;

@end
