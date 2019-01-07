//
//  FDAlbumTableViewCell.m
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDAlbumTableViewCell.h"
#import "FDKit.h"

@interface FDAlbumTableViewCell ()

@property (nonatomic, strong) UIImageView *albumImageView;

@property (nonatomic, strong) UILabel *albumNameLabel;

@property (nonatomic, strong) UILabel *albumNumberLabel;

@end

@implementation FDAlbumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.albumImageView];
    [self.contentView addSubview:self.albumNameLabel];
    [self.contentView addSubview:self.albumNumberLabel];
    
    [self.albumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@5);
        make.width.height.equalTo(@70);
    }];
    
    [self.albumNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-5));
        make.top.equalTo(@(15));
    }];
    [self.albumNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-5));
        make.top.equalTo(@(40));
    }];
}

-(void)loadImage:(NSIndexPath *)index {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    __weak typeof(self) weakSelf = self;
    [[PHCachingImageManager defaultManager] requestImageForAsset:self.albumModel.firstAsset targetSize:CGSizeMake(WindowSizeW / 2, WindowSizeH / 2) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (weakSelf.row == index.row) {
            weakSelf.albumImageView.image = result;
        }
    }];
}

-(void)setAlbumModel:(FDAlbumModel *)albumModel {
    _albumModel = albumModel;
    
    self.albumNameLabel.text = albumModel.collectionTitle;
    self.albumNumberLabel.text = albumModel.collectionNumber;
}

#pragma mark - Getter
-(UIImageView *)albumImageView {
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc] init];
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImageView.layer.masksToBounds = YES;
    }
    
    return _albumImageView;
}

-(UILabel *)albumNameLabel {
    if (!_albumNameLabel) {
        _albumNameLabel = [[UILabel alloc] init];
        _albumNameLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return _albumNameLabel;
}

-(UILabel *)albumNumberLabel {
    if (!_albumNumberLabel) {
        _albumNumberLabel = [[UILabel alloc] init];
        _albumNumberLabel.font = [UIFont systemFontOfSize:12];
        _albumNumberLabel.textColor = [UIColor lightTextColor];
    }
    
    return _albumNumberLabel;
}

@end
