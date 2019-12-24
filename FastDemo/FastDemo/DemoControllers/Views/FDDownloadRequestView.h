//
//  FDDownloadRequestView.h
//  FastDemo
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FDDownloadFileType) {
    FDDownloadFileType_Unknow,
    FDDownloadFileType_Pic,
    FDDownloadFileType_Audio,
};

@interface FDDownloadRequestView : UIView

@property (nonatomic, assign) FDDownloadFileType type;
@property (nonatomic, strong) NSString *defaultDownloadPath;
@property (nonatomic, strong) UITextField *inputTextField;

- (instancetype)init;
- (void)download:(void(^)(NSString *path)) complete;

@end

NS_ASSUME_NONNULL_END
