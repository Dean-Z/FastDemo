//
//  UIViewController+FDNavigationBar.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "UIViewController+FDNavigationBar.h"
#import "FDNavigationBar.h"
#import "Masonry.h"
#import <objc/runtime.h>
#import "FDFuncations.h"

static const char FDNavigationBarKey = '\0';
static void *navigationBarKey = &navigationBarKey;

@implementation UIViewController (FDNavigationBar)

- (FDNavigationBar *)navigationBar {
    FDNavigationBar *navigationBar = objc_getAssociatedObject(self, &FDNavigationBarKey);
    if (!navigationBar) {
        navigationBar = [FDNavigationBar new];
        [self willChangeValueForKey:@"navigationBar"];
        objc_setAssociatedObject(self, &FDNavigationBarKey, navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"navigationBar"];
        navigationBar.hidden = YES;
        [self.view addSubview:navigationBar];
        [self bindingLayoutWithView:navigationBar];
    }
    return navigationBar;
}

- (void)bindingLayoutWithView:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(SafeAreaTopHeight));
        make.top.leading.trailing.equalTo(self.view);
    }];
}
@end
