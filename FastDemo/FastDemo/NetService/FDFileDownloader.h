//
//  FDFileDownloader.h
//  FastDemo
//
//  Created by Jason on 2018/12/1.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDKit.h"

@interface FDFileDownloader : NSObject

+ (FDFileDownloader *)shareDownloader;

- (void)downloadWithURL:(NSURL *)downloadURL
               filePath:(NSString *)filePath
               progress:(fd_block_float)progress
               complete:(void (^)(NSURL *path, NSError *error))complete;

@end
