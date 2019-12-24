//
//  FDMusicPlayerController.h
//  FastDemo
//
//  Created by Jason on 2019/12/24.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDMusicModel.h"

@interface FDMusicPlayerController : UIViewController

@property (nonatomic, strong) NSString *baseDir;
+ (instancetype)musicPlayerControllerWithMusicModel:(FDMusicModel *)musicModel;

@end

