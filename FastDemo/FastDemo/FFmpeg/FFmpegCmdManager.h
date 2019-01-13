//
//  FFmpegCmdManager.h
//  FastDemo
//
//  Created by Jason on 2019/1/10.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFmpegCmdManager : NSObject

- (void)cutInputVideoPath:(char*)inputPath
          outPutVideoPath:(char*)outputPath
                startTime:(char*)startTime
                 duration:(char*)duration;

- (void)concatInputFilePath:(NSString *)inputFilePath
            outPutVideoPath:(char*)outputPath;

@end
