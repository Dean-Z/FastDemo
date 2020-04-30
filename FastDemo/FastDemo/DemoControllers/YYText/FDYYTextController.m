//
//  FDYYTextController.m
//  FastDemo
//
//  Created by Jason on 2020/4/22.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDYYTextController.h"
#import "YYText.h"
#import "FDKit.h"

@interface FDYYTextController ()

@property (nonatomic, strong) YYLabel *tokenLabel;

@end

@implementation FDYYTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self.view addSubview:self.tokenLabel];
    [self addSeeMoreButtonInLabel:self.tokenLabel];
}

- (void)setup {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.title = @"YYLabel";
    self.navigationBar.parts = FDNavigationBarPartBack;
    WEAKSELF
    self.navigationBar.onClickBackAction = ^{
         [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (YYLabel *)tokenLabel {
    if (!_tokenLabel) {
        _tokenLabel = [YYLabel new];
        _tokenLabel.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 30);
        _tokenLabel.numberOfLines = 0;
        _tokenLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.75];
        [self addSeeMoreButtonInLabel:_tokenLabel];
        
    }
    
    return _tokenLabel;
}
 
- (void)addSeeMoreButtonInLabel:(YYLabel *)label {
    UIFont *font16 = [UIFont systemFontOfSize:16];
    label.attributedText = [[NSAttributedString alloc] initWithString:@"我们可以使用以下方式来指定切断文本;xx我们可以使用以下方式来指定切断文本" attributes:@{NSFontAttributeName : font16}];
 
    NSString *moreString = @" 展开";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"... %@", moreString]];
    NSRange expandRange = [text.string rangeOfString:moreString];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:expandRange];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor darkTextColor] range:NSMakeRange(0, expandRange.location)];
    
    //添加点击事件
    YYTextHighlight *hi = [YYTextHighlight new];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:moreString]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击展开
        [weakSelf setFrame:YES];
    };
    
    text.yy_font = font16;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentTop];
    
    label.truncationToken = truncationToken;
}
 
- (NSAttributedString *)appendAttriStringWithFont:(UIFont *)font {
    if (!font) {
        font = [UIFont systemFontOfSize:16];
    }
    if ([_tokenLabel.attributedText.string containsString:@"收起"]) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    NSString *appendText = @" 收起 ";
    NSMutableAttributedString *append = [[NSMutableAttributedString alloc] initWithString:appendText attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor blueColor]}];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [append yy_setTextHighlight:hi range:[append.string rangeOfString:appendText]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击收起
        [weakSelf setFrame:NO];
    };
    
    return append;
}
 
- (void)expandString {
    NSMutableAttributedString *attri = [_tokenLabel.attributedText mutableCopy];
    [attri appendAttributedString:[self appendAttriStringWithFont:attri.yy_font]];
    _tokenLabel.attributedText = attri;
}
 
- (void)packUpString {
    NSString *appendText = @" 收起 ";
    NSMutableAttributedString *attri = [_tokenLabel.attributedText mutableCopy];
    NSRange range = [attri.string rangeOfString:appendText options:NSBackwardsSearch];
 
    if (range.location != NSNotFound) {
        [attri deleteCharactersInRange:range];
    }
 
    _tokenLabel.attributedText = attri;
}
 
 
- (void)setFrame:(BOOL)isExpand {
    if (isExpand) {
        [self expandString];
        self.tokenLabel.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 200);
    }
    else {
        [self packUpString];
        self.tokenLabel.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 30);
    }
}



@end
