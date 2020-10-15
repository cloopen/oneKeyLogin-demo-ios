//
//  UIColor+NM.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/5/31.
//  Copyright © 2020 luanchen. All rights reserved.
//

#import "UIColor+RL.h"

@implementation UIColor (RL)

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)colorWithRGB:(NSUInteger)rgbValue {
    return [self colorWithRGB:rgbValue alpha:1];
}

+ (UIColor *)colorWithRGB:(NSUInteger)rgbValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(CGFloat)((rgbValue & 0xff0000) >> 16) / 255.0
                           green:(CGFloat)((rgbValue & 0x00ff00) >> 8) / 255.0
                            blue:(CGFloat)((rgbValue & 0x0000ff)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithARGB:(NSUInteger)argbValue {
    return [UIColor colorWithRed:(CGFloat)((argbValue & 0x00ff0000) >> 16) / 255.0
                           green:(CGFloat)((argbValue & 0x0000ff00) >> 8) / 255.0
                            blue:(CGFloat)((argbValue & 0x000000ff)) / 255.0
                           alpha:(CGFloat)((argbValue & 0xff000000) >> 24) / 255.0];
}

- (NSString *)hexString {
    CGFloat r, g, b, a;
    if (![self getRed:&r green:&g blue:&b alpha:&a]) {
        if (![self getWhite:&r alpha:&a]) return nil;
        g = b = r;
    }
    return [NSString stringWithFormat:@"#%02lx%02lx%02lx%02lx", lrint(a * 0xff), lrint(r * 0xff), lrint(g * 0xff), lrint(b * 0xff)];
}

- (UIColor *)blendWith:(UIColor *)color {
    CGFloat la, lr, lg, lb;
    CGFloat ra, rr, rg, rb;
    CGFloat ta, tr, tg, tb;

    if (![self getRed:&lr green:&lg blue:&lb alpha:&la]) return nil;
    if (![color getRed:&rr green:&rg blue:&rb alpha:&ra]) return nil;
    ta = la + ra * (1 - la);
    tr = (lr * la + rr * ra * (1 - la)) / ta;
    tg = (lg * la + rg * ra * (1 - la)) / ta;
    tb = (lb * la + rb * ra * (1 - la)) / ta;
    return [UIColor colorWithRed:tr green:tg blue:tb alpha:ta];
}

+ (UIColor *)colorFromHexString:(NSString *)string {
    if (string.length != 7 && string.length != 9) return nil;
    if ([string characterAtIndex:0] != '#') return nil;

    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setScanLocation:1];
    unsigned long long value;
    if (![scanner scanHexLongLong:&value]) return nil;
    if (value > 0xffffffffUL) return nil;
    if (!scanner.isAtEnd) return nil;
    return string.length == 7 ? [UIColor colorWithRGB:(NSUInteger)value] : [UIColor colorWithARGB:(NSUInteger)value];
}

+ (UIColor *)colorFromHexString:(NSString *)string alpha:(CGFloat)alpha {
    if (string.length != 7 && string.length != 9) return nil;
    if ([string characterAtIndex:0] != '#') return nil;

    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setScanLocation:1];
    unsigned long long value;
    if (![scanner scanHexLongLong:&value]) return nil;
    if (value > 0xffffffffUL) return nil;
    if (!scanner.isAtEnd) return nil;
    return string.length == 7 ? [UIColor colorWithRGB:(NSUInteger)value alpha:alpha] : [UIColor colorWithARGB:(NSUInteger)value];
}

+(UIColor *)rgbColor:(NSString *)color andAlpha:(CGFloat)alpha {
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [color substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [color substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [color substringWithRange:range];
    unsigned int Red = 0, Green = 0, Blue = 0;
    [[NSScanner scannerWithString:rString] scanHexInt:&Red];
    [[NSScanner scannerWithString:gString] scanHexInt:&Green];
    [[NSScanner scannerWithString:bString] scanHexInt:&Blue];
    //    sscanf(color, "%2x%2x%2x", &Red, &Green, &Blue);
    return [UIColor colorWithRed:Red/255.0 green:Green/255.0 blue:Blue/255.0 alpha:alpha];
}

/**
 * by 人间不知德
 * @brief 根据系统模式，和传入的颜色字符串，返回合适的颜色（原颜色或者反转颜色）
 *
 * @param hexStr 正常模式下的颜色字符串（#xxxxxx）
 */
+ (UIColor *)dynamicColorWithLightColor:(NSString *)hexStr {
    
    UIColor *color = [self colorFromHexString:hexStr];
    
    if (@available(iOS 13.0, *)) {
        return [[UIColor alloc] initWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            // 正常模式
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return color;
            }
            // 暗黑模式
            else if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [color antitheticColor];
            } else {
                return UIColor.grayColor;
            }
        }];
    }
    return UIColor.whiteColor;
}


// UIColor 颜色反转
- (UIColor *)antitheticColor {
    CGFloat red, green, blue, alpha;
    
    BOOL got = [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (!got) return UIColor.whiteColor;
    
    return [UIColor colorWithRed:1-red green:1-green blue:1-blue alpha:alpha];
}

// 判断两个颜色是否一样
- (BOOL)isSameColor:(UIColor *)color {
    if (CGColorEqualToColor(self.CGColor, color.CGColor))
        return YES;
    return NO;
}


@end

