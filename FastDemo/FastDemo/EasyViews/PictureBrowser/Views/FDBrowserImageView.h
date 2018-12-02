//
//  FDBrowserImageView.h
//  FastDemo
//
//  Created by Jason on 2018/12/2.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDBrowserImageViewTransformDelegate <NSObject>

@optional

- (void)beganTransformOfRecognizer:(UIGestureRecognizer *)recognizer;
- (void)changedTransformOfRecognizer:(UIGestureRecognizer *)recognizer;
- (void)endedTransformOfRecognizer:(UIGestureRecognizer *)recognizer;
- (void)longPressOfRecognizer:(UIGestureRecognizer *)recognizer itemIndex:(NSUInteger)index;
- (void)singlePressOfRecognizer:(UIGestureRecognizer *)recognizer;
- (void)doublePressOfRecognizer:(UIGestureRecognizer *)recognizer;

@end

@interface FDBrowserImageView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, weak) id <FDBrowserImageViewTransformDelegate> delegate;

+ (CGSize)imageSizeToFit:(UIImage *)image;

@end

