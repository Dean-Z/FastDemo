//
//  FDTuLingManager.m
//  FastDemo
//
//  Created by Jason on 2020/4/16.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDTuLingResponseModel.h"
#import "FDTuLingManager.h"
#import "AFNetworking.h"

static NSString *const kTLRobotName = @"@03 ";
static NSString *const kTLRobotOpenActionName = @"好啊";
static NSString *const kTLRobotCloseActionName = @"不聊了";

@implementation FDTuLingManager

@dynamic manager;

+ (instancetype)manager {
    static FDTuLingManager *m;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[FDTuLingManager alloc] init];
    });
    return m;
}

- (BOOL)callRobot:(NSString *)content {
    return [content hasPrefix:kTLRobotName];
}

- (BOOL)openRobot:(NSString *)content {
    return [content isEqualToString:kTLRobotOpenActionName];
}

- (BOOL)closeRobot:(NSString *)content {
    return [content isEqualToString:[NSString stringWithFormat:@"%@%@",kTLRobotName,kTLRobotCloseActionName]];;
}

- (void)maybeTakeWithRobot:(NSString *)content complete:(fd_block_object)complete {
    // 开始监听后 下一条消息是否是打开指令
    if (self.robotState == FDTLRobotStateLinsening) {
        if ([self openRobot:content]) {
            self.robotState = FDTLRobotStateOpened;
        } else {
            self.robotState = FDTLRobotStateColsed;
        }
    }
    
    // 如果收到关闭指令 则直接退出
    if (self.robotState == FDTLRobotStateOpened) {
        if ([self closeRobot:content]) {
            self.robotState = FDTLRobotStateColsed;
            return;
        }
    }
    
    // 如果直接@机器人
    if ([self callRobot:content]) {
        content = [content substringFromIndex:kTLRobotName.length];
        // 只打了@机器人 没说其他的
        if (content.length == 0) {
            return;
        }
        [self postJsonToServer:content complete:^(id resp, id error) {
            if (!error) {
                FDTuLingResponseModel *response = [FDTuLingResponseModel yy_modelWithJSON:resp];
                if (complete) {
                    complete(response.values.text);
                }
            } else {
                // 机器人接口报错了~
            }
        }];
    }
}

- (void)postJsonToServer:(NSString *)jsonString complete:(fd_block_object_object)complete {

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://openapi.tuling123.com/openapi/api/v2" parameters:nil error:nil];

    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];

    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (complete) {
            complete(responseObject,error);
        }
    }] resume];

}

+ (NSString *)robotName {
    return kTLRobotName;
}

@end
