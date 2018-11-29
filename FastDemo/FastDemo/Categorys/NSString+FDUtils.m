//
//  NSString+FDUtils.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "NSString+FDUtils.h"
#import "FDFuncations.h"

@implementation NSString (FDUtils)

- (CGSize)fd_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    if (EMPLYSTRING(self)) return CGSizeZero;
    return [self boundingRectWithSize:size
                              options:NSStringDrawingTruncatesLastVisibleLine |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                           attributes:@{ NSFontAttributeName : font }
                              context:nil].size;
}

- (NSAttributedString *)fd_attributedStringWithFont:(UIFont*)font
                                          textColor:(UIColor *)textColor {
    return [self fd_attributedStringWithFont:font
                                  extraAttrs:@{NSForegroundColorAttributeName:textColor}
                              paragraphstyle:nil];
}

- (NSAttributedString *)fd_attributedStringWithFont:(UIFont*)font
                                         lineHeight:(CGFloat)lineHeight
                                          textColor:(UIColor *)textColor {
    return [self fd_attributedStringWithFont:font
                                  lineHeight:lineHeight
                                   textColor:textColor
                               lineBreakMode:NSLineBreakByTruncatingTail];
}

- (NSAttributedString *)fd_attributedStringWithFont:(UIFont*)font
                                         lineHeight:(CGFloat)lineHeight
                                          textColor:(UIColor *)textColor
                                      lineBreakMode:(NSLineBreakMode)breakMode {
    if (EMPLYSTRING(self)) return nil;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = breakMode;
    style.minimumLineHeight = lineHeight;
    style.maximumLineHeight = lineHeight;
    style.alignment = NSTextAlignmentJustified;
    return [self fd_attributedStringWithFont:font
                                  extraAttrs:@{NSForegroundColorAttributeName : textColor}
                              paragraphstyle:style];
}

- (NSAttributedString *)fd_attributedStringWithFont:(UIFont *)font
                                         lineHeight:(CGFloat)lineHeight
                                          textColor:(UIColor *)textColor
                                       textAligment:(NSTextAlignment)aligment
                                      lineBreakMode:(NSLineBreakMode)breakMode {
    if (EMPLYSTRING(self)) return nil;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = breakMode;
    style.minimumLineHeight = lineHeight;
    style.maximumLineHeight = lineHeight;
    style.alignment = aligment;
    return [self fd_attributedStringWithFont:font
                                  extraAttrs:@{NSForegroundColorAttributeName : textColor}
                              paragraphstyle:style];
}

- (NSAttributedString *)fd_attributedStringWithFont:(UIFont*)font
                                         extraAttrs:(NSDictionary *)extraAttrs
                                     paragraphstyle:(NSMutableParagraphStyle *)style {
    if (EMPLYSTRING(self)) return nil;
    NSMutableDictionary *attrs = [@{ NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor blackColor],
                                     NSBaselineOffsetAttributeName : @(0) } mutableCopy];
    if (style) {
        [attrs setObject:style forKey:NSParagraphStyleAttributeName];
    }
    if (extraAttrs) {
        [attrs addEntriesFromDictionary:extraAttrs];
    }
    return [[NSAttributedString alloc] initWithString:self attributes:attrs];
}

- (NSString *)fd_stringWithDeleteList:(NSArray*)deleteList {
    if (EMPLYSTRING(self)) return nil;
    NSString* res = self;
    for (NSString* str in deleteList) {
        res = [res stringByReplacingOccurrencesOfString:str withString:@""];
    }
    return res;
}

@end
