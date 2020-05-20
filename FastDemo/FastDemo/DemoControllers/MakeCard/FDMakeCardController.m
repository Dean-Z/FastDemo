//
//  FDMakeCardController.m
//  FastDemo
//
//  Created by Jason on 2020/5/20.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDMakeCardController.h"
#import "FDPreviewController.h"
#import "FDKit.h"

@interface FDMakeCardController ()

@property (nonatomic, strong) UIButton *cardNameButton;
@property (nonatomic, strong) UITextField *cardNumberTextField;
@property (nonatomic, strong) UIDatePicker *picker;

@property (nonatomic, strong) UILabel *numerLabel;
@property (nonatomic, strong) NSString *cardName;

@end

@implementation FDMakeCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.title = @"创建会员卡";
    self.navigationBar.parts = FDNavigationBarPartBack;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
         [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    UIButton *submit = [UIButton new];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submit.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
    [submit addTarget:self action:@selector(previewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.width.equalTo(@(40));
        make.centerY.equalTo(self.navigationBar.titleLabel);
    }];
    
    [self.view addSubview:self.cardNameButton];
    
    [self.cardNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(30);
    }];
    
    [self.view addSubview:self.cardNumberTextField];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kCardNumLastValue] != nil) {
        self.cardNumberTextField.text = @([[[NSUserDefaults standardUserDefaults] objectForKey:kCardNumLastValue] intValue] + 1).stringValue;
    }
    [self.cardNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardNameButton.mas_bottom).offset(30);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.numerLabel];
    [self.numerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cardNumberTextField.mas_left).offset(-20);
        make.centerY.equalTo(self.cardNumberTextField);
    }];
    
    [self.view addSubview:self.picker];
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@300);
        make.top.equalTo(self.numerLabel.mas_bottom).offset(20);
    }];
}

- (void)previewAction {
    FDPreviewController *preview = [FDPreviewController new];
    preview.numberString = self.cardNumberTextField.text;
    preview.typeString = self.cardName;
    preview.toDate = self.picker.date;
    [self.navigationController pushViewController:preview animated:YES];
}

- (void)chooseCardAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择卡种" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"单日畅学卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cardName = @"单日畅学卡";
        [self.cardNameButton setTitle:[NSString stringWithFormat:@"卡种：%@",self.cardName] forState:UIControlStateNormal];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"30日畅学卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cardName = @"30日畅学卡";
        [self.cardNameButton setTitle:[NSString stringWithFormat:@"卡种：%@",self.cardName] forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"90日畅学卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cardName = @"90日畅学卡";
        [self.cardNameButton setTitle:[NSString stringWithFormat:@"卡种：%@",self.cardName] forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"180日畅学卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cardName = @"180日畅学卡";
        [self.cardNameButton setTitle:[NSString stringWithFormat:@"卡种：%@",self.cardName] forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"5次畅学卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cardName = @"5次畅学卡";
        [self.cardNameButton setTitle:[NSString stringWithFormat:@"卡种：%@",self.cardName] forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"10次畅学卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.cardName = @"10次畅学卡";
        [self.cardNameButton setTitle:[NSString stringWithFormat:@"卡种：%@",self.cardName] forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.cardNumberTextField resignFirstResponder];
}

#pragma mark -

- (UIButton *)cardNameButton {
    if (!_cardNameButton) {
        _cardNameButton = [UIButton new];
        [_cardNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cardNameButton.titleLabel setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium]];
        [_cardNameButton setTitle:@"选择卡片" forState:UIControlStateNormal];
        [_cardNameButton addTarget:self action:@selector(chooseCardAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cardNameButton;
}

- (UITextField *)cardNumberTextField {
    if (!_cardNumberTextField) {
        _cardNumberTextField = [UITextField new];
        _cardNumberTextField.placeholder = @"卡号";
        _cardNumberTextField.backgroundColor = HEXCOLOR(0xf1f1f1);
        _cardNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _cardNumberTextField;
}

- (UILabel *)numerLabel {
    if (!_numerLabel) {
        _numerLabel = [UILabel new];
        _numerLabel.textColor = [UIColor blackColor];
        _numerLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        _numerLabel.text = @"卡号：";
    }
    return _numerLabel;
}

- (UIDatePicker *)picker {
    if (!_picker) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        // 设置当前显示时间
        [datePicker setDate:[NSDate date] animated:YES];
        
        NSInteger maxTime = [[NSDate date] timeIntervalSince1970] + 365 * 24 * 60 * 60;
        NSDate *maxDate = [NSDate dateWithTimeIntervalSince1970:maxTime];
        [datePicker setMinimumDate:[NSDate date]];
        [datePicker setMaximumDate:maxDate];
        
        _picker = datePicker;
    }
    return _picker;
}

@end
