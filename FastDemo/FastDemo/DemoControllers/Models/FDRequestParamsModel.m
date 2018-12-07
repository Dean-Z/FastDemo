//
//  FDRequestParamsModel.m
//  FastDemo
//
//  Created by Jason on 2018/12/6.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDRequestParamsModel.h"
#import <Realm/Realm.h>

@implementation FDRequestParamsModel

+ (NSArray *)allRequests {
    RLMResults *results = [FDRequestParamsModel allObjects];
    NSMutableArray *array = @[].mutableCopy;
    for (FDRequestParamsModel *model in results) {
        [array addObject:model];
    }
    return array;
}

@end
