//
//  NSString+FDUtils.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "NSString+FDUtils.h"
#import "FDFuncations.h"
#import <CommonCrypto/CommonDigest.h>

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

- (nonnull NSString*) MD5 {
    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_MD5(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];
}

- (nonnull NSData*) MD5Data {
    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_MD5(self.UTF8String, [self UTF8Length], output);
    return [NSData dataWithBytes:output length:outputLength];
}

- (nonnull NSString*) SHA1 {
    unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA1(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];
}

- (nonnull NSData*) SHA1Data {
    unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA1(self.UTF8String, [self UTF8Length], output);
    return [NSData dataWithBytes:output length:outputLength];
}

- (nonnull NSString*) SHA256 {
    unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA256(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];
}

- (nonnull NSData*) SHA256Data {
    unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA256(self.UTF8String, [self UTF8Length], output);
    return [NSData dataWithBytes:output length:outputLength];
}

- (unsigned int) UTF8Length {
    return (unsigned int) [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

- (nonnull NSString*) toHexString:(unsigned char*) data length: (unsigned int) length {
    NSMutableString* hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return [hash copy];
}

@end
