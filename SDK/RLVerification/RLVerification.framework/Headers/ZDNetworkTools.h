//
//  ZDNetworkTools.h
//  RLVerification
//
//  Created by 刘义增 on 2020/7/30.
//  Copyright © 2020 ccop. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZDOperatorsType) {
    ZDOperatorsType_ChinaMobile     = 1 << 0,   // 中国移动
    ZDOperatorsType_ChinaUnicom     = 1 << 1,   // 中国联通
    ZDOperatorsType_ChinaTelecom    = 1 << 2,   // 中国电信
    ZDOperatorsType_ChinaTietong    = 1 << 3,   // 中国铁通
    ZDOperatorsType_Other           = 1 << 10,  // 其他
};

typedef NS_ENUM(NSUInteger, ZDNetworkType) {
    ZDNetworkType_None  = 0,    // 网络不通
    ZDNetworkType_Wifi,
    ZDNetworkType_2G,
    ZDNetworkType_3G,
    ZDNetworkType_4G,
    ZDNetworkType_5G,
    ZDNetworkType_Other,
};

NS_ASSUME_NONNULL_BEGIN

@interface ZDNetworkTools : NSObject

/** 获取运营商类型 */
+ (ZDOperatorsType)zd_getOperatorsType;

/** 获取网络类型：如 3G，4G，WiFi ... */
+ (ZDNetworkType)zd_getNetworkType;

/** 获取设备型号 */
+ (NSString *)zd_getCurrentDeviceModel;

/** 判断设备是否装有 SIM卡 */
+ (BOOL)zd_isSIMCardInstalled;

/** 判断设备是否开启了蜂窝煤网络 */
+ (BOOL)zd_isDeviceOpenCellularNetwork;



/// 获取网络类型
+ (NSString *)zd_getNetworkTypeString;

/// 获取信号强度
+ (int)zd_getSignalStrength;

/// 获取设备IP地址（ipv4）
+ (NSString *)zd_getIPAddress;

///  检测是否是合格的 ipv4地址
+ (BOOL)zd_isValidIPv4Address:(NSString *)ipAddr;

///  检测是否是合格的 ipv6地址
+ (BOOL)zd_isValidIPv6Address:(NSString *)ipAddr;

/// 获取设备 UUID
+ (NSString*)getUUID;

/// 获取设备信息（设备类别、当前系统&版本）
+ (NSString *)zd_getDeviceInfo;


@end

NS_ASSUME_NONNULL_END
