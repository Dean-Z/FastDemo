//
//  FDMusicModel.h
//  FastDemo
//
//  Created by Jason on 2019/12/24.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDMusicModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *localPicPath;
@property (nonatomic, strong) NSString *localAudioPath;
@property (nonatomic, strong) NSString *sizeString;


- (NSString *)fullLocalAudioPath;
- (NSString *)fullLocalPicPath;
@end
