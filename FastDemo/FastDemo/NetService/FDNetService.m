//
//  FDNetService.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDNetService.h"
#import "AFNetworking.h"

@interface FDNetService ()
@property (nonatomic, strong) AFURLSessionManager *URLSessionManager;
@property (nonatomic, strong) AFHTTPSessionManager *HTTPSessionManager;
@property (nonatomic, strong) NSURLSessionDownloadTask *sessionDownloadTask;
@end

@implementation FDNetService

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static FDNetService *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (AFURLSessionManager *)URLSessionManager {
    if(_URLSessionManager == nil) {
        _URLSessionManager = [[AFURLSessionManager alloc] init];
    }
    return _URLSessionManager;
}

- (AFHTTPSessionManager *)HTTPSessionManager {
    if(!_HTTPSessionManager) {
        _HTTPSessionManager = [AFHTTPSessionManager manager];
    }
    return _HTTPSessionManager;
}

- (void)setupRequestSerializerForSessionManager:(AFHTTPSessionManager *)sessionManager {
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content"];
    requestSerializer.allowsCellularAccess = YES;
    requestSerializer.HTTPShouldHandleCookies = YES;
    sessionManager.requestSerializer = requestSerializer;
}

- (void)getRequestWithURL:(NSString *)requestURL
            parameters:(NSDictionary *)params
              complete:(fd_block_object)complete
                failed:(fd_block_object)failed {
    [self setupRequestSerializerForSessionManager:self.HTTPSessionManager];
    [self.HTTPSessionManager GET:requestURL
                      parameters:params
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             if (complete) {
                                 complete(responseObject);
                             }
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             if (failed) {
                                 failed(error);
                             }
                         }];
}

- (void)postRequestWithURL:(NSString *)requestURL
               parameters:(NSDictionary *)params
                 complete:(fd_block_object)complete
                   failed:(fd_block_object)failed {
    [self setupRequestSerializerForSessionManager:self.HTTPSessionManager];
    [self.HTTPSessionManager POST:requestURL
                      parameters:params
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             if (complete) {
                                 complete(responseObject);
                             }
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             if (failed) {
                                 failed(error);
                             }
                         }];
}

@end