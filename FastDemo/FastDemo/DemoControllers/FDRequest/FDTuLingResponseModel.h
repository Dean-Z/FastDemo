//
//  FDTuLingResponseModel.h
//  FastDemo
//
//  Created by Jason on 2020/4/16.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDTuLingResponseVaule : NSObject

@property (nonatomic, strong) NSString *text;

@end

@interface FDTuLingResponseModel : NSObject

@property (nonatomic, strong) NSString *resultType;
@property (nonatomic, strong) FDTuLingResponseVaule *values;

@end
