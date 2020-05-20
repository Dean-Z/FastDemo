//
//  FDPreviewController.m
//  FastDemo
//
//  Created by Jason on 2020/5/20.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDPreviewController.h"
#import "UIView+FDUtils.h"
#import "FDKit.h"

@interface FDPreviewController ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *cardStyleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation FDPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.title = @"预览";
    self.navigationBar.parts = FDNavigationBarPartBack;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
         [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    UIButton *submit = [UIButton new];
    [submit setTitle:@"保存" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submit.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
    [submit addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.width.equalTo(@(40));
        make.centerY.equalTo(self.navigationBar.titleLabel);
    }];
    
    self.contentView = [UIView new];
    [self.view addSubview:self.contentView];
    self.contentView.layer.cornerRadius = 15.f;
    self.contentView.layer.masksToBounds = YES;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(50);
        make.width.equalTo(@400);
        make.height.equalTo(@225);
    }];
    
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.cardStyleLabel];
    [self.cardStyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(@(-30));
    }];
    
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(@(-5));
    }];
}

- (void)saveAction {
    UIImage *image = [self.contentView fd_captureScaneView];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"完成" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [[NSUserDefaults standardUserDefaults] setObject:self.numberString forKey:kCardNumLastValue];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.image = [UIImage imageNamed:@"empty"];
    }
    return _coverImageView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [UILabel new];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _numberLabel.text = [NSString stringWithFormat:@"No.%@",self.numberString];
    }
    return _numberLabel;
}

- (UILabel *)cardStyleLabel {
    if (!_cardStyleLabel) {
        _cardStyleLabel = [UILabel new];
        _cardStyleLabel.textColor = [UIColor whiteColor];
        _cardStyleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        _cardStyleLabel.text = self.typeString;
    }
    return _cardStyleLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        _dateLabel.text = [NSString stringWithFormat:@"有效期至:%@",[formatter stringFromDate:self.toDate]];
    }
    return _dateLabel;
}

@end
