//
//  FDFilesListController.h
//  FastDemo
//
//  Created by Jason on 2018/12/1.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDKit.h"

typedef enum : NSUInteger {
    FDFileChooseAll,
    FDFileChoosePicture,
    FDFileChooseVideo,
    FDFileChooseAudio,
} FDFileChooseType;

@interface FDFilesListController : UIViewController

@property (nonatomic, assign) FDFileChooseType type;
@property (nonatomic, copy) fd_block_object chooseFinishBlock;

@end
