//
//  FDNetService.h
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDKit.h"

@interface FDNetService : NSObject

+ (instancetype)sharedInstance;

- (void)getRequestWithURL:(NSString *)requestURL
               parameters:(NSDictionary *)params
                 complete:(fd_block_object)complete
                   failed:(fd_block_object)failed;

- (void)postRequestWithURL:(NSString *)requestURL
                parameters:(NSDictionary *)params
                  complete:(fd_block_object)complete
                    failed:(fd_block_object)failed;

- (void)postJsonToServer:(NSString *)jsonString
                complete:(fd_block_object_object)complete;

@end
