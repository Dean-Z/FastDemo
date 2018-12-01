//
//  FDNavigationBar.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "UIView+FDSeparatorView.h"
#import "FDNavigationBar.h"
#import "FDKit.h"

@interface FDNavigationBar()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong, readwrite) UIButton *backItem;
@property (nonatomic, strong, readwrite) UIButton *addItem;
@property (nonatomic, strong, readwrite) UIButton *fileItem;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@property (nonatomic, strong) UIView *leftLastView;
@property (nonatomic, strong) UIView *rightLastView;
@end

@implementation FDNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGSize)intrinsicContentSize {
   return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), SafeAreaTopHeight);
}

- (void)setHiddenLine:(BOOL)hiddenLine {
    [self fd_addSeparatorWithPosition:(hiddenLine ? FDSeparatorViewPositionNone : FDSeparatorViewPositionBottom)];
}

- (void)addPart:(FDNavigationBarParts)part {
    self.parts = self.parts | part;
}

- (void)setParts:(FDNavigationBarParts)parts {
    _parts = parts;
    
    self.hidden = NO;
    self.leftLastView = nil;
    self.rightLastView = nil;
    
    // LEFT
    
    if (parts & FDNavigationBarPartBack) {
        [self installBackItem];
        self.leftLastView = self.backItem;
    } else {
        [self uninstallWithView:_backItem];
    }
    
    // RIGHT
    
    if (parts & FDNavigationBarPartAdd) {
        [self installAddItem];
        self.rightLastView = self.addItem;
    } else {
        [self uninstallWithView:_addItem];
    }
    
    if (parts & FDNavigationBarPartFiles) {
        [self installFileItem];
        self.rightLastView = self.fileItem;
    } else {
        [self uninstallWithView:_fileItem];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    if (title) {
        [self installTitleLabel];
        self.hidden = NO;
    } else {
        [self uninstallWithView:_titleLabel];
    }
    [self.titleLabel sizeToFit];
    [self.titleLabel layoutIfNeeded];
}

- (void)setup {
    [self setupUI];
}

- (void)setupUI {
    [self addSubviews];
    [self bindingLayoutForSubviews];
    self.backgroundColor = [UIColor whiteColor];
    self.hiddenLine = NO;
}

- (void)addSubviews {
    [self addSubview:self.contentView];
}

- (void)bindingLayoutForSubviews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@(SafeAreaTopHeight));
    }];
}

#pragma mark - About parts

- (void)installBackItem {
    [self.contentView addSubview:self.backItem];
    [self.backItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(@(44));
        make.top.equalTo(@([self contentCenterY]));
    }];
}

- (void)installAddItem {
    [self.contentView addSubview:self.addItem];
    [self.addItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.width.equalTo(@(30));
        make.top.equalTo(@([self contentCenterY]));
    }];
}

- (void)installTitleLabel {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(@(75));
        make.right.lessThanOrEqualTo(@(-75));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(@([self contentCenterY]));
    }];
}

- (void)installFileItem {
    [self.contentView addSubview:self.fileItem];
    [self.fileItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLastView.mas_left);
        make.width.equalTo(@(30));
        make.top.equalTo(@([self contentCenterY]));
    }];
}

- (void)uninstallWithView:(UIView *)view {
    if (!view.superview) return;
    [view removeFromSuperview];
}

#pragma mark - Action

- (void)backItemAction {
    if (self.onClickBackAction) {
        self.onClickBackAction();
    }
}

- (void)addItemAction {
    if (self.onClickAddAction) {
        self.onClickAddAction();
    }
}

- (void)fileAction {
    if (self.onClickFileAction) {
        self.onClickFileAction();
    }
}

#pragma mark - Getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIButton *)backItem {
    if (!_backItem) {
        _backItem = [UIButton new];
        [_backItem setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
        [_backItem addTarget:self action:@selector(backItemAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backItem;
}

- (UIButton *)addItem {
    if (!_addItem) {
        _addItem = [UIButton new];
        [_addItem setImage:[UIImage imageNamed:@"icon_add_default_m"] forState:UIControlStateNormal];
        [_addItem addTarget:self action:@selector(addItemAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addItem;
}

- (UIButton *)fileItem {
    if (!_fileItem) {
        _fileItem = [UIButton new];
        [_fileItem setImage:[UIImage imageNamed:@"icon_files"] forState:UIControlStateNormal];
        [_fileItem addTarget:self action:@selector(fileAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _fileItem;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        [self installTitleLabel];
    }
    return _titleLabel;
}

- (CGFloat)contentCenterY {
    if (IPHONE_X) {
        CGFloat height = (SafeAreaTopHeight/2.f + 12);
        return height;
    }
    return SafeAreaTopHeight/2.f;
}

@end
