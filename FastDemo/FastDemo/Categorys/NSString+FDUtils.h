//
//  NSString+FDUtils.h
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (FDUtils)

- (CGSize)fd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (NSAttributedString *)fd_attributedStringWithFont:(UIFont*)font
                                          textColor:(UIColor *)textColor;
- (NSAttributedString *)fd_attributedStringWithFont:(UIFont*)font
                                         lineHeight:(CGFloat)lineHeight
                                          textColor:(UIColor *)textColor;
- (NSAttributedString *)fd_attributedStringWithFont:(UIFont*)font
                                         lineHeight:(CGFloat)lineHeight
                                          textColor:(UIColor *)textColor
                                      lineBreakMode:(NSLineBreakMode)breakMode;
- (NSAttributedString *)fd_attributedStringWithFont:(UIFont *)font
                                         lineHeight:(CGFloat)lineHeight
                                          textColor:(UIColor *)textColor
                                       textAligment:(NSTextAlignment)aligment
                                      lineBreakMode:(NSLineBreakMode)breakMode;
- (NSAttributedString *)fd_attributedStringWithFont:(UIFont*)font
                                         extraAttrs:(NSDictionary *)extraAttrs
                                     paragraphstyle:(NSMutableParagraphStyle *)style;

- (NSString *)fd_stringWithDeleteList:(NSArray*)deleteList;

/**
 Creates a MD5 hash of the current string as hex NSString representation.
 */
- (nonnull NSString*) MD5;

/**
 Creates a MD5 hash of the current string as NSData representation.
 */
- (nonnull NSData*) MD5Data;

/**
 Creates a SHA1 hash of the current string as hex NSString representation.
 */
- (nonnull NSString*) SHA1;

/**
 Creates a SHA1 hash of the current string as NSData representation.
 */
- (nonnull NSData*) SHA1Data;

/**
 Creates a SHA256 hash of the current string as hex NSString representation.
 */
- (nonnull NSString*) SHA256;

/**
 Creates a SHA256 hash of the current string as NSData representation.
 */
- (nonnull NSData*) SHA256Data;


@end
