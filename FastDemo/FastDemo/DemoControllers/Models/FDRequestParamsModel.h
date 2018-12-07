//
//  FDRequestParamsModel.h
//  FastDemo
//
//  Created by Jason on 2018/12/6.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "RLMObject.h"

@interface FDRequestParamsModel : RLMObject

@property (nonatomic) NSString *requestUrl;
@property (nonatomic) NSString *requestParams;
@property (nonatomic) NSInteger method;  // 1: GET 2:POST
@property (nonatomic) NSString *result;

+ (NSArray *)allRequests;

@end
