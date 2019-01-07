//
//  FDAlbumCollectionCell.m
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDAlbumCollectionCell.h"
#import "FDAlbumLibraryContext.h"

@interface FDAlbumCollectionCell ()

@property (nonatomic, strong) UIImageView *photoImageView;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIView *translucentView;

@end

@implementation FDAlbumCollectionCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup {
    CGFloat width = (WindowSizeW - 20.f) / 3.f;
    [self.contentView addSubview:self.photoImageView];
    [self.contentView addSubview:self.translucentView];
    [self.contentView addSubview:self.selectButton];
    
    [self.photoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.width.height.equalTo(@(width));
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.photoImageView.mas_right).offset(-5);
        make.top.equalTo(self.photoImageView).offset(5);
        make.width.height.equalTo(@(25));
    }];
    [self.translucentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.photoImageView);
    }];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPhoto:)]];
}

-(void)loadImage:(NSIndexPath *)indexPath {
    CGFloat imageWidth = (WindowSizeW - 20.f) / 5.5;
    self.photoImageView.image = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = NO;
    
    [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(imageWidth * [UIScreen mainScreen].scale, imageWidth * [UIScreen mainScreen].scale) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (self.row == indexPath.row) {
            self.photoImageView.image = result;
        }
    }];
}

-(void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    
    self.translucentView.hidden = !isSelect;
    [self.selectButton setBackgroundImage:isSelect ? [UIImage imageNamed: @"selectImage_select"] : nil forState:UIControlStateNormal];
    
    if ([FDAlbumLibraryContext standardAlbumLibraryContext].maxCount == [FDAlbumLibraryContext standardAlbumLibraryContext].choiceCount) {
        self.translucentView.hidden = NO;
        if (isSelect) {
            _translucentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        } else {
            _translucentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        }
    } else {
        _translucentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
}

-(void)selectPhoto:(UIButton *)button {
    if (self.selectPhotoAction) {
        self.selectPhotoAction(self.asset);
    }
}

#pragma mark - Getter
-(UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.layer.masksToBounds = YES;
    }
    
    return _photoImageView;
}

-(UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _selectButton.layer.borderWidth = 1.f;
        _selectButton.layer.cornerRadius = 12.5f;
        _selectButton.layer.masksToBounds = YES;
        [_selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectButton;
}

-(UIView *)translucentView {
    if (!_translucentView) {
        _translucentView = [[UIView alloc] init];
        _translucentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _translucentView.hidden = YES;
    }
    
    return _translucentView;
}

@end
