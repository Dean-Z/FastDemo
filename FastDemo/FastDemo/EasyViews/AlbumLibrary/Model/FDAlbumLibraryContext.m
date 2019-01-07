//
//  FDAlbumLibraryContext.m
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDAlbumLibraryContext.h"

@implementation FDAlbumLibraryContext

+(FDAlbumLibraryContext*)standardAlbumLibraryContext {
    static FDAlbumLibraryContext *context = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[FDAlbumLibraryContext alloc] init];
    });
    
    return context;
}

#pragma mark - Set方法
-(void)setMaxCount:(NSInteger)maxCount {
    _maxCount = maxCount;
    
    self.photoModelList = [NSMutableArray array];
    self.choiceCount = 0;
}

-(void)setChoiceCount:(int)choiceCount {
    _choiceCount = choiceCount;
    
    if (self.choiceCountChange) {
        self.choiceCountChange(choiceCount);
    }
}

@end
