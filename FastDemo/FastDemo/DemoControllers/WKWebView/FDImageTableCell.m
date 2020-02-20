//
//  FDImageTableCell.m
//  FastDemo
//
//  Created by Jason on 2020/2/20.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDImageTableCell.h"
#import "YYWebImage.h"
#import "FDKit.h"

@interface FDImageTableCell ()

@property (nonatomic, strong) UIImageView *contentImageView;

@end

@implementation FDImageTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setup];
    return self;
}

- (void)setup {
    [self addSubview:self.contentImageView];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void)renderWithImage:(UIImage *)image {
    self.contentImageView.image = image;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

#pragma mark - Getter

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [UIImageView new];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        _contentImageView.backgroundColor = [UIColor clearColor];
        _contentImageView.clipsToBounds = YES;
    }
    return _contentImageView;
}

@end
