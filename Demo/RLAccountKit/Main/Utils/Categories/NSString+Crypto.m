//
//  NSString+Crypto.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/3.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "NSString+Crypto.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Crypto)
/**
 MD5加密

 @return 加密结果
 */
- (NSString *)md5{
    
    const char *source = [self UTF8String];
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    CC_MD5(source, (uint32_t)strlen(source), md5);
    
    NSMutableString *retString = [NSMutableString stringWithCapacity:40];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        NSString *strValue = [NSString stringWithFormat:@"%02X", md5[i]];
        if ([strValue length] == 0) {
            strValue = @"";
        }
        
        [retString appendString:strValue];
    }
    
    if ([retString length] == 0) {
        return @"";
    }
    
    return [retString lowercaseString];
    
}

- (NSString *)hexString_HMACSHA1:(NSString *)key {
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSParameterAssert(data);

    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *hMacOut = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1,
           keyData.bytes, keyData.length,
           data.bytes,    data.length,
           hMacOut.mutableBytes);

    /* Returns hexadecimal string of NSData. Empty string if data is empty. */
    NSString *hexString = @"";
    if (data) {
        uint8_t *dataPointer = (uint8_t *)(hMacOut.bytes);
        for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            hexString = [hexString stringByAppendingFormat:@"%02X", dataPointer[i]];
        }
    }

    return hexString;
}

@end
