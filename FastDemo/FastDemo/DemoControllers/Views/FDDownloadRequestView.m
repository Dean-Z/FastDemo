//
//  FDDownloadRequestView.m
//  FastDemo
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDDownloadRequestView.h"
#import "UIView+FDSeparatorView.h"
#import "NSString+FDUtils.h"
#import "FDFileDownloader.h"
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
    
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(@(80));
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self.progressLabel.mas_left).offset(-10);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(0));
    }];

}

- (void)download {
    if (EMPLYSTRING(self.inputTextField.text)) {
        return;
    }
    [self setUserInteractionEnabled:NO];
    NSURL *url = [NSURL URLWithString:self.inputTextField.text];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",FDPathDocument,[self.inputTextField.text MD5]];
    WEAKSELF
    [[FDFileDownloader shareDownloader] downloadWithURL:url filePath:filePath progress:^(float progress) {
        [weakSelf.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.equalTo(@(weakSelf.fd_width * (progress)));
        }];
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%d%@",(int)(progress * 100),@"%"];
    } complete:^(NSURL *path, NSError *error) {
        if (!error) {
            weakSelf.progressLabel.text = @"下载完成";
        } else {
            weakSelf.progressLabel.text = @"请求失败";
        }
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
        _progressLabel.font = [UIFont systemFontOfSize:12];
        _progressLabel.textAlignment = NSTextAlignmentRight;
        _progressLabel.text = @"-.-";
    }
    return _progressLabel;
}

@end
