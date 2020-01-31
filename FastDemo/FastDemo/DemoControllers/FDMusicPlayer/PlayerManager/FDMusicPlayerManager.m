//
//  FDPlayerManager.m
//  FastDemo
//
//  Created by Jason on 2020/1/31.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDMusicPlayerManager.h"
#import "YYModel.h"
#import "FDKit.h"

NSString *const kLastMusciModelJasonData = @"kLastMusciModelJasonData";

static FDMusicPlayerManager *manager;

@implementation FDMusicPlayerManager

+ (instancetype)sharePlayerManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[FDMusicPlayerManager alloc]init];
        }
    });
    return manager;
}

- (void)playerWithMusicModel:(FDMusicModel *)musicModel {
    NSString *jsonString = [musicModel yy_modelToJSONString];
    FDSetUserDefaults(jsonString, kLastMusciModelJasonData);
    
}

#pragma mark - Setter


@end
