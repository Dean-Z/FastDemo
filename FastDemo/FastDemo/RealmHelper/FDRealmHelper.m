//
//  FDRealmHelper.m
//  FastDemo
//
//  Created by Jason on 2018/12/6.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDRealmHelper.h"
#import "FDKit.h"

const NSInteger kRealmSchemaVersion = 2;

static FDRealmHelper *helper;

@implementation FDRealmHelper

+ (id)shareRealmHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [FDRealmHelper setDefaultRealmVersion];
        helper = [FDRealmHelper new];
    });
    return helper;
}


+ (void)setDefaultRealmVersion {
    NSString *path = [FDPathDocument stringByAppendingFormat:@"/demo.realm"];
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.fileURL = [NSURL fileURLWithPath:path];
    configuration.schemaVersion = kRealmSchemaVersion;
    configuration.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
    };
    [RLMRealmConfiguration setDefaultConfiguration:configuration];
    [RLMRealm defaultRealm];
}

@end
