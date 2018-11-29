//
//  FDRequestParamView.h
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDRequestParamView : UIView

@property (nonatomic, strong, readonly) UITextField *keyTextField;
@property (nonatomic, strong, readonly) UITextField *valueTextField;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
