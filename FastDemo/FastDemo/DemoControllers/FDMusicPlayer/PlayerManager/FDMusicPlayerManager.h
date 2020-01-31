//
//  FDPlayerManager.h
//  FastDemo
//
//  Created by Jason on 2020/1/31.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDMusicModel.h"

extern NSString *const kLastMusciModelJasonData;

@interface FDMusicPlayerManager : NSObject

+ (instancetype)sharePlayerManager;
- (void)playerWithMusicModel:(FDMusicModel *)musicModel;

@end
