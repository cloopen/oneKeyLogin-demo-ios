//
//  ArgsDefine.h.h
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/15.
//  Copyright © 2020 ccop. All rights reserved.
//

#ifndef ArgsDefine_h_h
#define ArgsDefine_h_h

#define APPID @"8a216da858af3ac60158b33360d901ee"
#define SERVER_PATH @"https://aim-mobileauth.yuntongxun.com"


#define zd_lastVersionKey @"lastInstallVersionKey"

#define zd_standbyLoginKey @"standbyModeLoginKey"


#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

#define kIs_iPhone      ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX     (kScreenWidth >= 375.0f && kScreenHeight >= 812.0f && kIs_iPhone)
 
/*状态栏高度*/
#define kStatusBarHeight    (kIs_iPhoneX ? 44.0 : 20.0)
/*导航栏高度*/
#define kNavBarHeight       (44.0)
/*状态栏和导航栏总高度*/
#define kNavAndStatusBarHeight  (kStatusBarHeight + kNavBarHeight)
/*TabBar高度*/
#define kTabBarHeight       (kIs_iPhoneX ? (49.0 + 34.0) : 49.0)
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight    (kNavAndStatusBarHeight + kTabBarHeight)

/*顶部安全区域远离高度*/
#define kTopBarSafeHeight   (kIs_iPhoneX ? 44.0 : 0)
/*底部安全区域远离高度*/
#define kBottomSafeHeight   (kIs_iPhoneX ? 34.0 : 0)
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight    (kIs_iPhoneX ? 24.0 : 0)


#define zd_lowestVersion(version) ([UIDevice.currentDevice.systemVersion floatValue] > version)

/// 状态栏高度
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunguarded-availability-new"
    #define zd_statusBarH (zd_lowestVersion(11.0) ? UIApplication.sharedApplication.delegate.window.safeAreaInsets.top : 20.f)
#pragma clang diagnostic pop

/// 导航栏高度
#define zd_navBarH 44.f

/// 标签栏高度
#define kTabBarH 49.f

/// 底部安全高度
#define zd_safeBottomH (zd_lowestVersion(11.0) ? UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom : 0.f)

/// 状态栏+导航栏 高度
#define zd_statusAndNavbarH (zd_statusBarH + zd_navBarH)
/// 安全标签栏高度
#define zd_tabBarH (kTabBarH + zd_safeBottomH)



#define zd_userDefault NSUserDefaults.standardUserDefaults
#define zd_udSync [zd_userDefault synchronize]


#endif /* ArgsDefine_h_h */
