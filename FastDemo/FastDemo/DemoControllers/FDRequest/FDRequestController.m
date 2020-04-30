//
//  FDRequestController.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "FDRequestController.h"
#import "UIView+FDSeparatorView.h"
#import "FDRequestParamView.h"
#import "FDKit.h"

#import "FDNetService.h"
#import "NSString+FDUtils.h"
#import "FDRequestParamsModel.h"
#import "FDRequestHistoryController.h"
#import "FDRealmHelper.h"

#import "FDTuLingRequestModel.h"
#import "YYModel.h"

@interface FDRequestController ()

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UITextField *requestURLTextField;
@property (nonatomic, strong) NSMutableArray *parmaViewsArray;
@property (nonatomic, strong) UIButton *requestButton;
@property (nonatomic, strong) UIButton *mockButton;
@property (nonatomic, strong) UIButton *methodButton;

@property (nonatomic, strong) UILabel *requestReultLabel;

@end

@implementation FDRequestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [FDRealmHelper shareRealmHelper];
}

- (void)setup {
    self.navigationBar.title = @"Request URL";
    self.navigationBar.parts = FDNavigationBarPartBack | FDNavigationBarPartAdd | FDNavigationBarPartFiles;
    self.view.backgroundColor = [UIColor whiteColor];
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.navigationBar.onClickAddAction = ^{
        [weakSelf addParamView];
    };
    self.navigationBar.onClickFileAction = ^{
        FDRequestHistoryController *vc = [FDRequestHistoryController new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self addViews];
    [self bringLayouts];
}

- (void)addViews {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.requestURLTextField];
    [self.contentView addSubview:self.requestButton];
    [self.contentView addSubview:self.mockButton];
    [self.contentView addSubview:self.methodButton];
    [self.contentView addSubview:self.requestReultLabel];
}

- (void)bringLayouts {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];
    [self.requestURLTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.height.equalTo(@(50));
        make.left.equalTo(@(20));
        make.width.equalTo(@(WindowSizeW - 40));
    }];
    [self.requestButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(40));
        make.width.equalTo(@(100));
        make.top.equalTo(self.requestURLTextField.mas_bottom).offset(20);
    }];
    [self.methodButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.height.equalTo(@(40));
        make.width.equalTo(@(100));
        make.centerY.equalTo(self.requestButton);
    }];
    [self.mockButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.requestButton.mas_right).offset(20);
        make.height.equalTo(@(40));
        make.width.equalTo(@(100));
        make.centerY.equalTo(self.requestButton);
    }];
    
    [self.requestReultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.requestURLTextField);
        make.top.equalTo(self.requestButton.mas_bottom).offset(20);
    }];
}

- (void)addParamView {
    UIView *lastView = self.requestURLTextField;
    if (self.parmaViewsArray.count > 0) {
        lastView = self.parmaViewsArray.lastObject;
    }
    FDRequestParamView *paramView = [FDRequestParamView new];
    [self.contentView addSubview:paramView];
    [self.parmaViewsArray addObject:paramView];
    [paramView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.requestURLTextField);
        make.height.equalTo(@(50));
        make.top.equalTo(lastView.mas_bottom);
    }];
    [self.requestButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(40));
        make.width.equalTo(@(100));
        make.top.equalTo(paramView.mas_bottom).offset(20);
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    }];
    self.mockButton.hidden = YES;
}

- (void)requestAction {
    
    FDTuLingRequestModel *requstModel = [FDTuLingRequestModel new];
    requstModel.perception.inputText.text = @"今天心情不好啊";
    
    NSString *jsonString = [requstModel yy_modelToJSONString];
    [[FDNetService sharedInstance] postJsonToServer:jsonString complete:^(id resp, id error) {
        if (!error) {
            NSLog(@"%@",resp);
        }
    }];
    
//    NSDictionary *dict = @{@"perception":[requstModel.perception yy_modelToJSONString],@"userInfo":[requstModel.userInfo yy_modelToJSONString]};
//    NSDictionary *data = @{@"dat":[dict yy_modelToJSONString]};
//    [[FDNetService sharedInstance] postRequestWithURL:@"http://openapi.tuling123.com/openapi/api/v2" parameters:data complete:^(id resp) {
//        NSLog(@"%@",resp);
//    } failed:^(id resp) {
//        NSLog(@"%@",resp);
//    }];
    
//    [self resignAllFirstResponder];
//    WEAKSELF
//    if ([self.methodButton.titleLabel.text isEqualToString:@"GET"]) {
//        [[FDNetService sharedInstance] getRequestWithURL:self.requestURLTextField.text
//                                              parameters:[self allParmas] complete:^(id result) {
//                                                  [weakSelf saveRequestData:result];
//                                                  weakSelf.requestReultLabel.text = [weakSelf convertToJSONData:result];
//                                                  [weakSelf.requestReultLabel layoutIfNeeded];
//                                                  CGSize size = [weakSelf.requestReultLabel.text fd_sizeWithFont:weakSelf.requestReultLabel.font constrainedToSize:CGSizeMake(weakSelf.requestReultLabel.frame.size.width, CGFLOAT_MAX)];
//                                                  weakSelf.contentView.contentSize = CGSizeMake(0, weakSelf.requestReultLabel.frame.origin.y + size.height);
//                                              } failed:^(NSError *error) {
//                                                  NSLog(@"%@",error.localizedDescription);
//                                              }];
//    } else {
//        [[FDNetService sharedInstance] postRequestWithURL:self.requestURLTextField.text
//                                              parameters:[self allParmas] complete:^(id result) {
//                                                  [weakSelf saveRequestData:result];
//                                                  weakSelf.requestReultLabel.text = [weakSelf convertToJSONData:result];
//                                                  [weakSelf.requestReultLabel layoutIfNeeded];
//                                                  CGSize size = [weakSelf.requestReultLabel.text fd_sizeWithFont:weakSelf.requestReultLabel.font constrainedToSize:CGSizeMake(weakSelf.requestReultLabel.frame.size.width, CGFLOAT_MAX)];
//                                                  weakSelf.contentView.contentSize = CGSizeMake(0, weakSelf.requestReultLabel.frame.origin.y + size.height);
//                                              } failed:^(NSError *error) {
//                                                  NSLog(@"%@",error.localizedDescription);
//                                              }];
//    }
}

- (void)saveRequestData:(NSDictionary *)result {
    FDRequestParamsModel *model = [FDRequestParamsModel new];
    model.requestUrl = self.requestURLTextField.text;
    model.requestParams = [self convertToJSONData:[self allParmas]];
    if ([self.methodButton.titleLabel.text isEqualToString:@"GET"]) {
        model.method = 1;
    } else {
        model.method = 2;
    }
    model.result = [self convertToJSONData:result];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:model];
    [realm commitWriteTransaction];
}

- (void)resignAllFirstResponder {
    [self.requestURLTextField resignFirstResponder];
    for (FDRequestParamView *paramView in self.parmaViewsArray) {
        [paramView.keyTextField resignFirstResponder];
        [paramView.valueTextField resignFirstResponder];
    }
}

- (void)mockAction {
    self.requestURLTextField.text = @"http://fanyi.youdao.com/openapi.do";
    [self addParamView];
    FDRequestParamView *paramView1 = [self.parmaViewsArray lastObject];
    paramView1.keyTextField.text = @"type";
    paramView1.valueTextField.text = @"data";
    [self addParamView];
    FDRequestParamView *paramView2 = [self.parmaViewsArray lastObject];
    paramView2.keyTextField.text = @"doctype";
    paramView2.valueTextField.text = @"json";
    [self addParamView];
    FDRequestParamView *paramView3 = [self.parmaViewsArray lastObject];
    paramView3.keyTextField.text = @"version";
    paramView3.valueTextField.text = @"1.1";
    [self addParamView];
    FDRequestParamView *paramView4 = [self.parmaViewsArray lastObject];
    paramView4.keyTextField.text = @"keyfrom";
    paramView4.valueTextField.text = @"iReader";
    [self addParamView];
    FDRequestParamView *paramView5 = [self.parmaViewsArray lastObject];
    paramView5.keyTextField.text = @"key";
    paramView5.valueTextField.text = @"1142461068";
    [self addParamView];
    FDRequestParamView *paramView6 = [self.parmaViewsArray lastObject];
    paramView6.keyTextField.text = @"q";
    paramView6.valueTextField.text = @"Hello";
    
}

- (void)methodAction {
    if ([self.methodButton.titleLabel.text isEqualToString:@"GET"]) {
        [self.methodButton setTitle:@"POST" forState:UIControlStateNormal];
    } else {
        [self.methodButton setTitle:@"GET" forState:UIControlStateNormal];
    }
}

- (NSDictionary *)allParmas {
    NSMutableDictionary *parma = @{}.mutableCopy;
    for (FDRequestParamView *paramView in self.parmaViewsArray) {
        [parma setValue:paramView.valueTextField.text forKey:paramView.keyTextField.text];
    }
    return parma;
}

#pragma mark - Getter

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [UIScrollView new];
    }
    return _contentView;
}

- (UITextField *)requestURLTextField {
    if (!_requestURLTextField) {
        _requestURLTextField = [UITextField new];
        _requestURLTextField.placeholder = @"Please input request url";
        _requestURLTextField.font = [UIFont systemFontOfSize:12];
        [_requestURLTextField fd_addSeparatorWithPosition:FDSeparatorViewPositionBottom];
    }
    return _requestURLTextField;
}

- (UIButton *)requestButton {
    if (!_requestButton) {
        _requestButton = [UIButton new];
        _requestButton.backgroundColor = HEXCOLOR(0x6ed56c);
        [_requestButton setTitle:@"Request" forState:UIControlStateNormal];
        [_requestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_requestButton addTarget:self action:@selector(requestAction) forControlEvents:UIControlEventTouchUpInside];
        _requestButton.layer.cornerRadius = 5.f;
        _requestButton.layer.masksToBounds = YES;
    }
    return _requestButton;
}

- (UIButton *)mockButton {
    if (!_mockButton) {
        _mockButton = [UIButton new];
        _mockButton.backgroundColor = HEXCOLOR(0x666666);
        [_mockButton setTitle:@"Mock" forState:UIControlStateNormal];
        [_mockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mockButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_mockButton addTarget:self action:@selector(mockAction) forControlEvents:UIControlEventTouchUpInside];
        _mockButton.layer.cornerRadius = 5.f;
        _mockButton.layer.masksToBounds = YES;
    }
    return _mockButton;
}

- (UIButton *)methodButton {
    if (!_methodButton) {
        _methodButton = [UIButton new];
        _methodButton.backgroundColor = HEXCOLOR(0x666666);
        [_methodButton setTitle:@"GET" forState:UIControlStateNormal];
        [_methodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_methodButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_methodButton addTarget:self action:@selector(methodAction) forControlEvents:UIControlEventTouchUpInside];
        _methodButton.layer.cornerRadius = 5.f;
        _methodButton.layer.masksToBounds = YES;
    }
    return _methodButton;
}

- (UILabel *)requestReultLabel {
    if(!_requestReultLabel) {
        _requestReultLabel = [UILabel new];
        _requestReultLabel.textColor = HEXCOLOR(0x666666);
        _requestReultLabel.font = [UIFont systemFontOfSize:12];
        _requestReultLabel.numberOfLines = 0;
    }
    return _requestReultLabel;
}

- (NSMutableArray *)parmaViewsArray {
    if (!_parmaViewsArray) {
        _parmaViewsArray = @[].mutableCopy;
    }
    return _parmaViewsArray;
}

- (NSString *)convertToJSONData:(id)infoDict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = @"";
    
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

@end
