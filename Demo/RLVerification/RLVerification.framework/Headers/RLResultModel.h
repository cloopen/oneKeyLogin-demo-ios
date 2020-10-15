//
//  RLResult.h
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/4.
//  Copyright © 2020 ccop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface RLResult : NSObject

@property(nonatomic, strong) NSString *code;    // 状态码
@property(nonatomic, strong) NSString *message; // 状态码描述

@end


@interface RLResultModel : NSObject

@property (nonatomic, strong) RLResult *result;

// 联通：用于定位请求失败问题
@property(nonatomic, strong) NSString *traceId;     // 流水号


/// 在RLVerification中拼接
@property(nonatomic, strong) NSString *token;       // 已经拼好的token


@property(nonatomic, strong) NSString *mobile;      // 手机号
// 访问令牌
@property(nonatomic, strong) NSString *accessCode;  //
// CM移动，CU联通，CT电信，UN其他
@property(nonatomic, strong) NSString *operatorType;// 运行商类型
// 超时时间，单位秒
@property(nonatomic, assign) NSInteger expires;     // 过期时间

@property(nonatomic, strong) NSString *authCode;    // just for CTCC ： 授权码
@property(nonatomic, strong) NSString *openId;      // just for CMCC ： 

@end

NS_ASSUME_NONNULL_END
