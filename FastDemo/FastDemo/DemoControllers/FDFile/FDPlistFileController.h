//
//  FDPlistFileController.h
//  FastDemo
//
//  Created by Jason on 2019/12/24.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDKit.h"

@interface FDPlistFileController : UIViewController

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, copy) fd_block_object callBackAction;

@end
