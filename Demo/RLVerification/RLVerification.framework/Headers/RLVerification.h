//
//  RLVerification.h
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/2.
//  Copyright © 2020 ccop. All rights reserved.
//


// In this header, you should import all the public headers of your framework using statements like #import <RLVerification/PublicHeader.h>
#import "GlobalTools.h"
#import "RLResultModel.h"
#import "RLUIConfig.h"
#import "ZDDeviceTools.h"
#import "ZDNetworkState.h"
#import "ZDNetworkTools.h"


//! Project version number for RLVerification.
FOUNDATION_EXPORT double RLVerificationVersionNumber;

//! Project version string for RLVerification.
FOUNDATION_EXPORT const unsigned char RLVerificationVersionString[];



NS_ASSUME_NONNULL_BEGIN

@class RLResultModel;
@class RLUIConfig;

/** 结果 回调Block*/
typedef void (^RLResultBlock)(RLResultModel *rlResult);
/** 失败原因回调Block */
typedef void (^RLFailReason)(RLResult *result);




@protocol RLVerificationDelegate <NSObject>

@optional

/**
 一键登录 - 用户点击了授权页面的返回按钮
 */
- (void)userDidDismissAuthViewController;

/**
 一键登录 - 用户点击了授权页面的"切换账户"按钮
 */
- (void)userDidSwitchAccount;

/**
 一键登录 - 用户点击了授权页面的"第三方"按钮
 */
- (void)userDidThirdPartyWithIndex:(NSInteger)index;

@end



@interface RLVerification : NSObject

@property (nonatomic, weak) id <RLVerificationDelegate> delegate;

@property (nonatomic, strong) RLUIConfig *uiConfig;

@property (nonatomic, strong, readonly) NSString *appID;

/**
 * by 人间不知德
 * ❗️❗️❗️如果需要设置，请在 调用初始化方法 setupWithAppID: 之前设置
 *
 * @brief 超时时间：单位 s
 * 三大运营商的 SDK 超时时间默认为：
 * 移动8s 联通20s 电信：总8s 其他6s
 *
 * 设置的值 < 8.0 则 直接设置为 8.0
 * 本SDK默认值为 8.f
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

// by 人间不知德：是否已经初始化成功的标志
// 如果想重新初始化，将其置为 NO 后，再调用 setupWithAppID: 方法
@property (nonatomic, assign) BOOL isSDKInitSucceeded;


/** 获取单例实例 */
+ (instancetype)sharedInstance;

/**
 * 启动初始化
 * @param appID     用户申请的 应用ID
 */
- (void)setupWithAppID:(NSString *)appID;

/**
 * 启动初始化
 * @param appID     用户申请的 应用ID
 * @param compHandler   初始化结果回调 YES/NO
 * @param failReason    初始化失败的回调
 */
- (void)setupWithAppID:(NSString *)appID
 withCompletionHandler:(void (^)(void))compHandler
            failReason:(RLFailReason)failReason;

/** 删除本地的运营商配置信息 */
+ (void)removeServerConfig;




/**
 * 手机号认证
 *
 * @param mobile    需要被验证的手机号
 * @param listener  验证结果回调Block，信息用 RLResult 存放
 * @param failReason    失败结果回调，失败原因 + 失败状态码
 */
- (void)mobileAuthWithMobile:(NSString *)mobile
                    listener:(RLResultBlock)listener
                  failReason:(RLFailReason)failReason;

/**
 * 一键登录预取号
 *
 * @param listener  预取号结果回调Block，信息用 RLResult 存放
 * @param failReason    失败结果回调，失败原因 + 失败状态码
 */
- (void)getAccessCode2Login:(RLResultBlock)listener
                 failReason:(RLFailReason)failReason;

/**
 * 一键登录-全屏
 *
 * @param listener  登录结果回调Block，信息用 RLResult 存放
 * @param failReason    失败结果回调，失败原因 + 失败状态码
 */
- (void)doLogin:(RLResultBlock)listener
     failReason:(RLFailReason)failReason;

/**
 * 一键登录-弹窗
 *
 * @param listener  验证结果回调Block，信息用 RLResult 存放
 * @param failReason    失败结果回调，失败原因 + 失败状态码
 */
- (void)doLoginPopup:(RLResultBlock)listener
          failReason:(RLFailReason)failReason;

/**
 * 关闭一键登录页面
 *
 * @param completion    关闭后回调
 */
- (void)dismissLoginWithCompletion:(void (^ __nullable)(void))completion;


/** 设置debug模式 输出日志 */
@property(nonatomic, assign) BOOL debug;




/** 为了demoDebug页面 debugLogLabel */
- (void)setupSDK;
// 注册 调试log输出标签，显示log信息
- (void)registerDebugLogLabel:(UILabel *)debugLogLabel;
// 删除 调试log标签
- (void)unRegisterDebugLogLabel;

@end

NS_ASSUME_NONNULL_END
