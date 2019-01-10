//
//  FDFuncations.h
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#ifndef FDFuncations_h
#define FDFuncations_h

/*********
 FAST COLOR
 *********/
#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:1.f]

#define HEXCOLOR(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define HEXACOLOR(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

/*********
 DEVICE ABOUT
 *********/
#define WindowSizeW   [[[[UIApplication sharedApplication] delegate] window] frame].size.width
#define WindowSizeH   [[[[UIApplication sharedApplication] delegate] window] frame].size.height

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
//导航栏高度
#define SafeAreaTopHeight (IPHONE_X ? 88 : 64)
//tabbar高度
#define SafeAreaBottomHeight (IPHONE_X ? (49 + 34) : 49)
#define DeviceSystemVersion [UIDevice currentDevice].systemVersion.floatValue

/*********
 NSSTRING
 *********/
#define EMPLYSTRING(string) \
({NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];\
([string stringByTrimmingCharactersInSet:whiteSpace].length <= 0);})

#define VALIDATEEMAIL(email) \
({NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";\
NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];\
([emailTest evaluateWithObject:email]);})

/*********
 DEVICE PATH
 *********/
#define FDPathTemp NSTemporaryDirectory()
#define FDPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define FDPathLibrary [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
#define FDPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

/*********
 OTHER
 *********/
#define WEAKSELF typeof(self) __weak weakSelf = self;

#endif /* FDFuncations_h */
