//
//  GlobalTools.h
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/3.
//  Copyright © 2020 ccop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RLOperatorsType) {
    RLOperatorsType_ChinaMobile,    // 中国移动
    RLOperatorsType_ChinaUnicom,    // 中国联通
    RLOperatorsType_ChinaTelecom,   // 中国电信
    RLOperatorsType_ChinaTietong,   // 中国铁通
    RLOperatorsType_Other,          // 其他
};

typedef NS_ENUM(NSUInteger, RLNetWorkType) {
    RLNetWorkType_None  = 0,    // 网络不通
    RLNetWorkType_Wifi,
    RLNetWorkType_2G,
    RLNetWorkType_3G,
    RLNetWorkType_4G,
    RLNetWorkType_5G,
    RLNetWorkType_Other,
};

NS_ASSUME_NONNULL_BEGIN

@interface GlobalTools : NSObject

/** 获取当前显示的控制器 */
+ (UIViewController *)getCurrentVC;

/** 将字典转换成 json 字符串 */
+ (NSString *)dictToJson:(NSDictionary *)dict;

/// 获取SDK 版本号
+ (NSString *)getSDKVersion;




/** 获取运营商类型 */
+ (RLOperatorsType)getOperatorsType;

/// 是否是 中国移动
+ (BOOL)isChinaMobile;

/// 是否是 中国联通
+ (BOOL)isChinaUnicom;

/// 是否是 中国电信
+ (BOOL)isChinaTelecom;

/** 获取网络类型：如 3G，WiFi */
+ (RLNetWorkType)getNetWorkType;

/** 获取设备型号 */
+ (NSString *)getCurrentDeviceModel;

/** 判断设备是否装有 SIM卡 */
+ (BOOL)isSIMCardInstalled;

/** 判断设备是否开启了蜂窝煤网络 */
+ (BOOL)isDeviceOpenCellularNetwork;





/**
 * 计算文字大小(size)
 *
 * @param fontSize 文字大小
 * @param width 文字宽度，如果为‘0’或者‘MAXFLOAT’或者‘CGFLOAT_MAX’，该方法为计算文字宽度
 * @param height 文字高度，如果为‘0’或者‘MAXFLOAT’或者‘CGFLOAT_MAX’，该方法为计算文字高度
 * @param paragraphStyle 文字其他属性
 *
 * @return 返回文字的size
 */
+ (CGSize)sizeOfString:(NSString *)string
              fontSize:(CGFloat)fontSize
         textSizeWidth:(CGFloat)width
        textSizeHeight:(CGFloat)height
        paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;

/**
 * 改变图片的大小
 *
 * @param img     需要改变的图片
 * @param newsize 新图片的大小
 * @param frame 原有图片在新图片的位置
 *
 * @return 返回修改后的新图片
 */
+ (UIImage *)scaleImage:(UIImage *)img
                newsize:(CGSize)newsize
                  frame:(CGRect)frame;




/** 导航栏高度 */
+ (CGFloat)navBarHeight;

/** 状态栏高度 */
+ (CGFloat)statusBarHeight;

/** 判断刘海屏，返回YES表示是刘海屏 */
+ (BOOL)isNotchScreen;

/// 判断是否是横屏
+ (BOOL)isLandscape;

/// 判断是否是小屏手机
+ (BOOL)isSmallPhone;




#ifdef DEBUG
/** 获取类的所有方法 */
+ (void)getClassMethods:(Class)targetClass;
#endif

@end

NS_ASSUME_NONNULL_END
