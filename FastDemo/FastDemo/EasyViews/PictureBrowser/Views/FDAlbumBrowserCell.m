//
//  FDAlbumBrowserCell.m
//  FastDemo
//
//  Created by Jason on 2018/12/2.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDAlbumBrowserCell.h"
#import <YYWebImage/YYWebImage.h>
#import "FDKit.h"

@interface FDAlbumBrowserCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *fullPictureButton;
@property (nonatomic, strong) FDBrowserImageView *pictureImageView;
@property (nonatomic, strong) YYWebImageOperation *operation;

@end

@implementation FDAlbumBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - Public methods

- (void)showWithSource:(id)source {
    if ([source isKindOfClass:[NSURL class]]) {
        [self setImageWithUrl:source progress:nil];
    } else if ([source isKindOfClass:[UIImage class]]) {
        self.pictureImageView.image = source;
        self.imageView.image = source;
    }
}

- (void)setImageWithUrl:(NSURL *)url progress:(YYWebImageProgressBlock)progress {
    [self.operation cancel];
    self.operation = nil;
    self.pictureImageView.imageURL = url.copy;
    self.operation = [[YYWebImageManager sharedManager] requestImageWithURL:url
                                                                    options:kNilOptions
                                                                   progress:progress
                                                                  transform:nil
                                                                 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                                                     WEAKSELF
                                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                         self.pictureImageView.image = image;
                                                                         if (progress) {
                                                                             [weakSelf.fullPictureButton setTitle:@"Done" forState:(UIControlStateNormal)];
                                                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                                 weakSelf.fullPictureButton.hidden = YES;
                                                                             });
                                                                         }
                                                                     });
                                                                 }];
}

- (void)setImageViewDelegate:(id <FDBrowserImageViewTransformDelegate>)delegate {
    self.pictureImageView.delegate = delegate;
}

- (void)setImageViewTag:(NSUInteger)tag {
    self.pictureImageView.tag = tag;
}

#pragma mark - Event methods

- (void)showFullPicture:(UIButton *)button {
//    button.enabled = NO;
//    [button setTitle:@"loading" forState:(UIControlStateNormal)];
}

#pragma mark - Initialize subviews and make subviews for layout

- (void)setupView {
    [self addSubviews];
    [self makeSubviewsLayout];
}

- (void)addSubviews {
    [self.contentView addSubview:self.pictureImageView];
    [self.contentView addSubview:self.fullPictureButton];
}

- (void)makeSubviewsLayout {
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.fullPictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@25);
        make.width.greaterThanOrEqualTo(@88);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(IPHONE_X ? -35 : -15);
    }];
}

#pragma mark - Setter and getter

- (FDBrowserImageView *)pictureImageView {
    if (!_pictureImageView) {
        _pictureImageView = [FDBrowserImageView new];
    }
    return _pictureImageView;
}

- (UIButton *)fullPictureButton {
    if (!_fullPictureButton) {
        _fullPictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullPictureButton.layer.cornerRadius = 3;
        _fullPictureButton.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        _fullPictureButton.layer.borderColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1.0].CGColor;
        _fullPictureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_fullPictureButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [_fullPictureButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_fullPictureButton setTitle:@"Full Image" forState:UIControlStateNormal];
        [_fullPictureButton addTarget:self action:@selector(showFullPicture:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _fullPictureButton;
}

- (UIImageView *)imageView {
    return self.pictureImageView.imageView;
}

@end
