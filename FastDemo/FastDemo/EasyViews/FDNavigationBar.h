//
//  FDNavigationBar.h
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, FDNavigationBarParts) {
    FDNavigationBarPartNone         = 0,
    FDNavigationBarPartBack         = 1 << 0,
};

@interface FDNavigationBar : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIButton *backItem;

@property (nonatomic, copy) NSString *title;
@property (nonatomic) FDNavigationBarParts parts;

- (void)addPart:(FDNavigationBarParts)part;

@end
