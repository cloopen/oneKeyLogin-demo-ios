//
//  NSString+encrypto.h
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/3.
//  Copyright © 2020 ccop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Crypto)
- (NSString *)md5;
- (NSString *)hexString_HMACSHA1:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
