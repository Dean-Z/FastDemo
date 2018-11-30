//
//  FDDownloadRequestView.m
//  FastDemo
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDDownloadRequestView.h"
#import "UIView+FDSeparatorView.h"
#import "FDKit.h"

@interface FDDownloadRequestView ()

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;

@end

@implementation FDDownloadRequestView

- (instancetype)init {
    self = [super init];
    [self setup];
    return self;
}

- (void)setup {
    [self fd_addSeparatorWithPosition:FDSeparatorViewPositionBottom];
    [self addSubview:self.inputTextField];
    [self addSubview:self.progressView];
    [self addSubview:self.progressLabel];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-40);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(0));
    }];

    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
    }];
}

#pragma mark - Getter

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [UITextField new];
        _inputTextField.font = [UIFont systemFontOfSize:13];
        _inputTextField.placeholder = @"Please input file download url";
    }
    return _inputTextField;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [UIView new];
        _progressView.backgroundColor = HEXACOLOR(0x6ed56c, 0.3);
    }
    return _progressView;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [UILabel new];
        _progressLabel.textColor = HEXCOLOR(0x666666);
        _progressLabel.font = [UIFont systemFontOfSize:13];
        _progressLabel.text = @"-.-";
    }
    return _progressLabel;
}

@end
