//
//  FDMovieMaker.h
//  FastDemo
//
//  Created by Jason on 2019/1/3.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MovieMakerBlock)(float, BOOL);

@interface FDMovieMaker : NSObject

- (void)compressionSession:(NSArray *)imageArray filePath:(NSString *)moviePath FPS:(int32_t)FPS completion:(MovieMakerBlock)completion;

@end
