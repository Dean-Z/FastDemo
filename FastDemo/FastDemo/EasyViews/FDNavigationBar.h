//
//  FDNavigationBar.h
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDBlockContants.h"

typedef NS_OPTIONS(NSInteger, FDNavigationBarParts) {
    FDNavigationBarPartNone         = 0,
    FDNavigationBarPartBack         = 1 << 0,
    FDNavigationBarPartAdd          = 1 << 1,
    FDNavigationBarPartFiles        = 1 << 2,
};

@interface FDNavigationBar : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIButton *backItem;
@property (nonatomic, strong, readonly) UIButton *addItem;

@property (nonatomic, copy) NSString *title;
@property (nonatomic) FDNavigationBarParts parts;
@property (nonatomic, assign) BOOL hiddenBottomLine;

@property (nonatomic, copy) fd_block_void onClickBackAction;
@property (nonatomic, copy) fd_block_void onClickAddAction;
@property (nonatomic, copy) fd_block_void onClickFileAction;

- (void)addPart:(FDNavigationBarParts)part;

@end
