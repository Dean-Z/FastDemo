//
//  FDRequestParamView.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDRequestParamView.h"
#import "UIView+FDSeparatorView.h"
#import "FDKit.h"

@interface FDRequestParamView ()

@property (nonatomic, strong, readwrite) UITextField *keyTextField;
@property (nonatomic, strong, readwrite) UITextField *valueTextField;
@property (nonatomic, strong) UILabel *centerLabel;

@end

@implementation FDRequestParamView

- (instancetype)init {
    self = [super init];
    [self setup];
    return self;
}

- (void)setup {
    [self addSubview:self.keyTextField];
    [self addSubview:self.valueTextField];
    [self addSubview:self.centerLabel];
    
    [self.keyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(@(100));
    }];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.keyTextField.mas_right).offset(20);
        make.centerY.equalTo(self);
    }];
    
    [self.valueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.height.equalTo(self);
        make.left.equalTo(self.centerLabel.mas_right).offset(20);
    }];
}

#pragma mark - Getter

- (UITextField *)keyTextField {
    if (!_keyTextField) {
        _keyTextField = [UITextField new];
        _keyTextField.font = [UIFont systemFontOfSize:12];
        _keyTextField.placeholder = @"Key";
        [_keyTextField fd_addSeparatorWithPosition:FDSeparatorViewPositionBottom];
    }
    return _keyTextField;
}

- (UITextField *)valueTextField {
    if (!_valueTextField) {
        _valueTextField = [UITextField new];
        _valueTextField.font = [UIFont systemFontOfSize:12];
        _valueTextField.placeholder = @"Value";
        [_valueTextField fd_addSeparatorWithPosition:FDSeparatorViewPositionBottom];
    }
    return _valueTextField;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [UILabel new];
        _centerLabel.text = @"-->";
        _centerLabel.textColor = HEXCOLOR(0x999999);
        _centerLabel.font = [UIFont systemFontOfSize:15];
    }
    return _centerLabel;
}

@end
