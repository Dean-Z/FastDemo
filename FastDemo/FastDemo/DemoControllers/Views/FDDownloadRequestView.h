//
//  FDDownloadRequestView.h
//  FastDemo
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDDownloadRequestView : UIView

@property (nonatomic, strong) NSString *defaultDownloadPath;
@property (nonatomic, strong) UITextField *inputTextField;

- (instancetype)init;
- (void)download;

@end

NS_ASSUME_NONNULL_END
