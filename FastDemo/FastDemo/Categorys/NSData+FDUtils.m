//
//  NSData+FDUtils.m
//  FastDemo
//
//  Created by Jason on 2018/11/29.
//  Copyright © 2018 Jason. All rights reserved.
//

#import "NSData+FDUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (FDUtils)

- (NSString *)fd_md5 {
    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    (void) CC_MD5( [self bytes], (CC_LONG)[self length], hash );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",hash[i]];
    }
    return output;
}

@end
