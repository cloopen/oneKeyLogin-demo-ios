//
//  ZDNetworkState.h
//  RLVerification
//
//  Created by 刘义增 on 2020/9/10.
//  Copyright © 2020 ccop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDNetworkState : NSObject

/**
网络类型及运营商（双卡下，获取上网卡的运营商）
"carrier"     运营商： 0.未知 / 1.中国移动 / 2.中国联通 / 3.中国电信
"networkType" 网络类型： 0.无网络/ 1.数据流量 / 2.wifi / 3.数据+wifi
@return  @{NSString : NSNumber}
*/
+ (NSDictionary<NSString *, NSNumber *> *)getNetworkInfo;

@end

NS_ASSUME_NONNULL_END
