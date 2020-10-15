//
//  UniAuthHelper.h
//  account_verify_sdk_core
//
//  Created by zhuof on 2018/3/8.
//  Copyright © 2018年 xiaowo. All rights reserved.
//

#import "UniAuthViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^UniResultListener)(NSDictionary *data);

@protocol UniAuthHelperDelegate;

@interface UniAuthHelper : NSObject

+ (UniAuthHelper *)getInstance;
/**
 初始化，禁止多次调用，禁止更换不同appid尝试初始化。
 */
- (void)initWithAppId:(NSString*) appId appSecret:(NSString*) appSecret;
/**
 号码认证
 */
- (void)mobileAuth:(UniResultListener) listener;

/**
 预取号
 */
- (void)getAccessCode:(UniResultListener) listener;

/**
 拉起授权登录页面
 viewModel每次使用需重新创建，否则会导致授权条款出现问题。
 */
- (void)doLogin:(UIViewController *)viewController
                             viewModel:(nullable UniAuthViewModel *)viewModel
                            listener:(UniResultListener) listener;

/**
 预取号是否拿到的code
 */
- (BOOL)isPreGettedTokenValidate;
/**
 设置代理对象
 */
- (void)setDelegate:(nullable id<UniAuthHelperDelegate>)delegate;
/**
 设置网络请求超时时间（单位s）
 */
- (void)setRequestTimeout:(NSTimeInterval)timeout;

/**
 关闭当前的授权页面
 */
- (void)dismissAuthViewController:(BOOL)animated completion:(void (^ __nullable)(void))completion;
/**
 关闭当前的授权页面
 */
- (void)dismissAuthViewController:(void (^ __nullable)(void))completion;

/**
 废弃20200320
 停止点击授权页面登录按钮之后的加载进度条
 */
- (void)stopLoading;

@end

@protocol UniAuthHelperDelegate <NSObject>

@optional

/**
 用户点击了授权页面的返回按钮
 */
- (void)userDidDismissAuthViewController;

/**
 用户点击了授权页面的"切换账户"按钮
 */
- (void)userDidSwitchAccount;

@end

NS_ASSUME_NONNULL_END
