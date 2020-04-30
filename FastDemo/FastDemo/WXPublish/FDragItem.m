//
//  HDragItem.m
//  FastDemo
//
//  Created by Jason on 2020/4/30.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDragItem.h"

@implementation FDragItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

@end
