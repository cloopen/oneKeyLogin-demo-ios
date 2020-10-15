//
//  NetworkManager.h
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/2.
//  Copyright © 2020 ccop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DemoNetworkResponse)(NSDictionary *_Nullable networkResponse);

@interface NetworkManager : NSObject

/// 获取该类单例进行操作
+ (instancetype)sharedInstance;

/// 本地模拟服务器端请求-一键登录获取号码
// 此接口调用应放到服务器
// SDK获取到token即生成认证token任务,后面应该token传到自己服务器端访问容联服务进行登录or验证
- (void)requestMobileLoginQuery:(NSString *_Nullable)appId token:(NSString *)token completion:(DemoNetworkResponse)completion;

/// 本地模拟服务器端请求-本机号码校验
// 此接口调用应放到服务器
// SDK获取到token即生成认证token任务,后面应该token传到自己服务器端访问容联服务进行登录or验证
- (void)requestMobileVerify:(NSString *_Nullable)appId token:(NSString *)token mobile:(NSString *)mobile completion:(DemoNetworkResponse)completion;

@end

NS_ASSUME_NONNULL_END
