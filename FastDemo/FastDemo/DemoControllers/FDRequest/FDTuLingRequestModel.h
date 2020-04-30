//
//  FDTuLingRequestModel.h
//  FastDemo
//
//  Created by Jason on 2020/4/15.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDUserInfo : NSObject

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *userId;

@end

//------------------------------------------------------------

@interface FDInputText : NSObject

@property (nonatomic, strong) NSString *text;

@end

@interface FDPerceptionModel : NSObject

@property (nonatomic, strong) FDInputText *inputText;

@end

//------------------------------------------------------------

@interface FDTuLingRequestModel : NSObject

@property (nonatomic, strong) FDPerceptionModel *perception;
@property (nonatomic, strong) FDUserInfo *userInfo;

@end

