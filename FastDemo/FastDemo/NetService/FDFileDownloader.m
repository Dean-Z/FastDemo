//
//  FDFileDownloader.m
//  FastDemo
//
//  Created by Jason on 2018/12/1.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDFileDownloader.h"
#import <AFNetworking/AFNetworking.h>

static FDFileDownloader *downloader = nil;

@interface FDFileDownloader()

@property (nonatomic, strong) AFURLSessionManager *URLSessionManager;
@property (nonatomic, strong) NSMutableArray *downloadingArray;

@end

@implementation FDFileDownloader

+ (FDFileDownloader *)shareDownloader {
    if (!downloader) {
        downloader = [[FDFileDownloader alloc] init];
    }
    return downloader;
}

- (void)downloadWithURL:(NSURL *)downloadURL
               filePath:(NSString *)filePath
               progress:(fd_block_float)progress
               complete:(void (^)(NSURL *path, NSError *error))complete {
    if ([self.downloadingArray containsObject:downloadURL] ||
        [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return;
    }
    [self.downloadingArray addObject:downloadURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    NSURLSessionDownloadTask *sessionDownloadTask =
    [self.URLSessionManager downloadTaskWithRequest:request
                                           progress:^(NSProgress * _Nonnull downloadProgress) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   progress ? progress(downloadProgress.fractionCompleted) : nil;
                                               });
                                           } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath,
                                                                           NSURLResponse * _Nonnull response) {
                                               return [NSURL fileURLWithPath:filePath];
                                           } completionHandler:^(NSURLResponse * _Nonnull response,
                                                                 NSURL * _Nullable filePath,
                                                                 NSError * _Nullable error) {
                                               if (!error) {
                                                   complete ? complete(filePath,nil) : nil;
                                               } else {
                                                   complete ? complete(nil,error) : nil;
                                               }
                                               [self.downloadingArray removeObject:downloadURL];
                                           }];
    [sessionDownloadTask resume];
}

- (AFURLSessionManager *)URLSessionManager {
    if (!_URLSessionManager) {
        _URLSessionManager = [[AFURLSessionManager alloc] init];
    }
    return _URLSessionManager;
}

- (NSMutableArray *)downloadingArray {
    if (!_downloadingArray) {
        _downloadingArray = @[].mutableCopy;
    }
    return _downloadingArray;
}

@end
