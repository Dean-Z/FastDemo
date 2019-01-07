//
//  FDAlbumView.m
//  FastDemo
//
//  Created by Jason on 2019/1/7.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "FDAlbumView.h"
#import "FDAlbumTableView.h"
#import "FDAlbumModel.h"

@interface FDAlbumView ()

@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, strong) UIView *targetView;

@property (nonatomic, strong) UIView *greyTransparentView;

@property (nonatomic, strong) FDAlbumTableView *tableView;

@property (nonatomic, assign) CGFloat presentHeight;

@end

@implementation FDAlbumView

-(instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (void)showInView:(UIView *)view originY:(CGFloat)originY {
    self.originY = originY;
    self.targetView = view;
    
    if (self.greyTransparentView.superview != view) {
        [self.targetView addSubview:self.greyTransparentView];
        [self.greyTransparentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.targetView);
            make.top.equalTo(@(originY));
        }];
    }
    if (self.superview != view) {
        [self.targetView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.equalTo(view).offset(originY - self.presentHeight);
            make.height.equalTo(@(self.presentHeight));
        }];
    }
    [self showAnimate];
}

-(void)setup {
    self.clipsToBounds = YES;
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)showAnimate {
    self.hidden = NO;
    self.greyTransparentView.hidden = NO;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.targetView);
        make.top.equalTo(self.targetView).offset(self.originY);
        make.height.equalTo(@(self.presentHeight));
    }];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.greyTransparentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 隐藏动画
-(void)endAnimate {
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.targetView);
        make.top.equalTo(self.targetView).offset(self.originY - self.presentHeight);
        make.height.equalTo(@(self.presentHeight));
    }];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.greyTransparentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.greyTransparentView.hidden = YES;
    }];
}

#pragma mark - Set方法
-(void)setAssetCollectionList:(NSMutableArray<FDAlbumModel *> *)assetCollectionList {
    _assetCollectionList = assetCollectionList;
    self.presentHeight = assetCollectionList.count * 80.f;
    if (self.presentHeight > WindowSizeH - 80.f) {
        self.presentHeight = WindowSizeH - 80.f;
    }
    
    self.tableView.assetCollectionList = assetCollectionList;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(self.presentHeight));
    }];
    
    WEAKSELF
    self.tableView.selectAction = ^(FDAlbumModel *albumModel) {
        if (weakSelf.selectAction) {
            weakSelf.selectAction(albumModel);
        }
        
        [weakSelf endAnimate];
    };
}

#pragma mark - 点击事件
-(void)clickCancel:(UIButton *)button {
    if (self.selectAction) {
        self.selectAction(nil);
    }
    [self endAnimate];
}

#pragma mark - Get方法
-(FDAlbumTableView *)tableView {
    if (!_tableView) {
        _tableView = [[FDAlbumTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

-(UIView *)greyTransparentView {
    if (!_greyTransparentView) {
        _greyTransparentView = [UIView new];
        _greyTransparentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0f];
        [_greyTransparentView setUserInteractionEnabled:YES];
        [_greyTransparentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCancel:)]];
    }
    
    return _greyTransparentView;
}

@end
