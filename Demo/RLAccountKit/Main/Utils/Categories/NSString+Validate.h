//
//  NSString+Validate.h
//  RLAccountKit
//
//  Created by 刘义增 on 2020/9/22.
//  Copyright © 2020 ccop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Validate)

/// 是否是 有效的 手机号
- (BOOL)zd_isValidPhone;

/// 是否是 有效的 密码（数字+字母 6-16位）
- (BOOL)zd_isValidPassword;

/// 是否是 有效的 邮箱📮
- (BOOL)zd_isvalidEmaill;

/// 是否是 有效的 身份证号🆔
- (BOOL)zd_isValidIDCard;

/// 是否是 全数字 字符串
- (BOOL)zd_isAllDigitString;

/// 是否是 全字母 字符串
- (BOOL)zd_isAllAlphaString;

/// 是否是 全中文 字符串
- (BOOL)zd_isChineseSring;

@end

NS_ASSUME_NONNULL_END
