//
//  FDAVPlayerControlle.h
//  FastDemo
//
//  Created by Jason on 2019/1/16.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FDAVStatus){
    FDPlay,
    FDPaused,
    FDReadToPlay,
    FDFail
};

@interface FDAVPlayerController : UIViewController

@property (nonatomic,copy)NSString * url;

@end

