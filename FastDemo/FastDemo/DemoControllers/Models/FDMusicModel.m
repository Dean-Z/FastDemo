//
//  FDMusicModel.m
//  FastDemo
//
//  Created by Jason on 2019/12/24.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDMusicModel.h"
#import "FDKit.h"

@implementation FDMusicModel

- (NSString *)fullLocalAudioPath {
    NSString *dir = [FDPathDocument stringByAppendingPathComponent:@"musics"];
    return [dir stringByAppendingPathComponent:_localAudioPath];
}

- (NSString *)fullLocalPicPath {
    NSString *dir = [FDPathDocument stringByAppendingPathComponent:@"musics"];
    return [dir stringByAppendingPathComponent:_localPicPath];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    return [[(FDMusicModel *)object localAudioPath] isEqualToString:self.localAudioPath];
}

@end
