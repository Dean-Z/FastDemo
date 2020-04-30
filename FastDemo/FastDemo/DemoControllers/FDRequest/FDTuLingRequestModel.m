//
//  FDTuLingRequestModel.m
//  FastDemo
//
//  Created by Jason on 2020/4/15.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDTuLingRequestModel.h"

@implementation FDUserInfo

- (NSString *)apiKey {
    return @"0eb678f123e24901ae8f788658732f0d";
}

- (NSString *)userId {
    return @"16666668";
}

@end

@implementation FDInputText

@end

@implementation FDPerceptionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"inputText":[FDInputText class],
             };
}

@end

@implementation FDTuLingRequestModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"perception":[FDPerceptionModel class],
             @"userInfo":[FDUserInfo class],
             };
}

- (instancetype)init {
    self = [super init];
    self.perception = [FDPerceptionModel new];
    self.perception.inputText = [FDInputText new];
    self.userInfo = [FDUserInfo new];
    return self;
}

@end
