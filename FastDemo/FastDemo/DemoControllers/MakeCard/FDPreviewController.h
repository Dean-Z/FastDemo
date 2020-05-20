//
//  FDPreviewController.h
//  FastDemo
//
//  Created by Jason on 2020/5/20.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCardNumLastValue  @"kCardNumLastValue"

@interface FDPreviewController : UIViewController

@property (nonatomic, strong) NSString *numberString;
@property (nonatomic, strong) NSString *typeString;
@property (nonatomic, strong) NSDate *toDate;

@end
