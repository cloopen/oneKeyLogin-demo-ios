//
//  NSString+Validate.m
//  RLAccountKit
//
//  Created by 刘义增 on 2020/9/22.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "NSString+Validate.h"

@implementation NSString (Validate)

// 是否是 有效的 手机号
- (BOOL)zd_isValidPhone {
    NSString *reg = @"^1(3[0-9]|4[579]|5[0-35-9]|6[6]|7[0-35-9]|8[0-9]|9[89])\\d{8}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [test evaluateWithObject:self];
}

// 是否是 有效的 密码（6-16位 字母+数字）
- (BOOL)zd_isValidPassword {
    NSString *reg = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [test evaluateWithObject:self];
}

// 是否是 有效的 邮箱📮
- (BOOL)zd_isvalidEmaill {
    NSString *reg = @"^(([^<>()[\\]\\\\.,;:\\s@\"]+(\\.[^<>()[\\]\\\\.,;:\\s@\"]+)*)|(\".+\"))@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [test evaluateWithObject:self];
}

// 是否是 有效的 身份证号🆔
- (BOOL)zd_isValidIDCard {
    // 一代身份证：年 YY，无校验位
    if (self.length == 15) {
        NSString *reg1 = @"^[1-9]\\d{7}(?:0\\d|10|11|12)(?:0[1-9]|[1-2][\\d]|30|31)\\d{3}$";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg1];
        
        return [test evaluateWithObject:self];
    }
    // 二代身份证：年 YYYY，最后一位校验位
    else if (self.length == 18) {
        NSString *reg2 = @"^[1-9]\\d{5}(?:18|19|20)\\d{2}(?:0[1-9]|10|11|12)(?:0[1-9]|[1-2]\\d|30|31)\\d{3}[\\dXx]$";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg2];
        
        BOOL valid = [test evaluateWithObject:self];
        
        if (valid) {
            return [self zd_judgeIdentityStringValid];
        }
        
        return valid;   // 此时 valid == NO
    }
    
    return NO;
    
    // 综合校验 一代/二代 身份证
    // @"(^[1-9]\\d{7}(?:0\\d|10|11|12)(?:0[1-9]|[1-2][\\d]|30|31)\\d{3}$)|(^[1-9]\\d{5}(?:18|19|20)\\d{2}(?:0[1-9]|10|11|12)(?:0[1-9]|[1-2]\\d|30|31)\\d{3}[\\dXx]$)";
}

// 判断身份证最后校验位是否有效
- (BOOL)zd_judgeIdentityStringValid {
    
    // 将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    // 这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    // 用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0; i < 17; i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum += (subStrIndex * idCardWiIndex);
    }
    
    // 计算出校验码所在数组的位置
    NSInteger idCardMod = idCardWiSum%11;
    // 得到最后一位身份证号码
    NSString *idCardLast = [self substringWithRange:NSMakeRange(17, 1)];
    // 如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod == 2) {
        if(![idCardLast isEqualToString:@"X"] || ![idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else {
        // 用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

// 是否是 全数字 字符串
- (BOOL)zd_isAllDigitString {
    NSString *reg = @"^\\d+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [test evaluateWithObject:self];
}

// 是否是 全字母 字符串
- (BOOL)zd_isAllAlphaString {
    NSString *reg = @"^[a-zA-Z]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [test evaluateWithObject:self];
}

// 是否是 全中文 字符串
- (BOOL)zd_isChineseSring {
    // [\u4E00-\u9FA5]  据说只能检测常用汉字（少部分汉字，大部分生僻字是不包括的）
    // 需要添加 [\uDB40DC00-\uDB7FDFFF]，但是目前正则 不支持四个字节unicode的表示
    // 另有：[\u4E00-\u9FFF]
    NSString *reg = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [test evaluateWithObject:self];
}

@end
