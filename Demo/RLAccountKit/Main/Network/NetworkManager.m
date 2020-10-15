//
//  NetworkManager.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/2.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "NetworkManager.h"
#import "NSString+Crypto.h"
#import "ArgsDefine.h"


@implementation NetworkManager

/// 获取该类单例进行操作
static NetworkManager *instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
    });
    return instance;
}


/// 获取号码
- (void)requestMobileLoginQuery:(NSString *_Nullable)appId token:(NSString *)token completion:(DemoNetworkResponse)completion {
    if (!appId) {
        appId = APPID;
    }
    /// 获取号码
    NSString *authURL = [NSString stringWithFormat:@"%@/v1/demo/mobile/login/query", SERVER_PATH];
    ///random
    NSString *random = [self randomWithLen:10];
    
    ///请求参数
    NSMutableDictionary *authParams = [NSMutableDictionary dictionaryWithDictionary:@{
        @"appId":appId,
        @"token":token,
        @"random":random
    }];
    
    ///sign
    authParams[@"sign"] = [self getSign:authParams subAccId:nil];
    
    NSLog(@"%s,params:%@", __func__, authParams);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:authURL]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:authParams options:NSJSONWritingPrettyPrinted error:nil];
    [[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            if (data.length > 0) {
                NSError *error;
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (completion) {
                    completion(dataDict);
                }
            }else {
                if (completion) {
                    completion(nil);
                }
            }
        }];
    }] resume];
}

/// 本机号码校验
- (void)requestMobileVerify:(NSString *_Nullable)appId token:(NSString *)token mobile:(NSString *)mobile completion:(DemoNetworkResponse)completion {
    if (!appId) {
        appId = APPID;
    }
    ///获取运营商应用信息 url
    NSString *authURL = [NSString stringWithFormat:@"%@/v1/demo/mobile/verify", SERVER_PATH];
    
    ///random
    NSString *random = [self randomWithLen:10];
    ///请求参数
    NSMutableDictionary *authParams = [NSMutableDictionary dictionaryWithDictionary:@{
       @"appId":appId,
       @"token":token,
       @"mobile":mobile,
       @"random":random
    }];
       
    ///sign
    authParams[@"sign"] = [self getSign:authParams subAccId:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:authURL]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:authParams options:NSJSONWritingPrettyPrinted error:nil];
    [[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
//            NSLog(@"result %@", data);
            if (data.length > 0) {
                NSError *error;
//                NSString *value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"http response = %@", value);
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                NSLog(@"domain %@  code=%ld",error.domain,error.code);
                if (completion) {
                    completion(dataDict);
                }
            }else {
                if (completion) {
                    completion(nil);
                }
            }
        }];
    }] resume];
}

// 生成签名 当有subAccId时候,加密方式不同
- (NSString*)getSign:(NSDictionary*) authParams subAccId:(NSString*)subAccId {
    NSArray* authParamKeys = [authParams allKeys];
    authParamKeys = [authParamKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableString *sign = [[NSMutableString alloc] init];
    for (NSString* key in authParamKeys) {
        [sign appendString:key];
        [sign appendString:[authParams valueForKey:key]];
    }
    NSLog(@"%@", sign);
    if (!subAccId || subAccId.length == 0) {
        return [sign md5];
    }else {
        return [sign hexString_HMACSHA1:[subAccId md5]];
    }
}


// 生成随机字符串(由大小写字母、数字组成)
- (NSString *)randomWithLen:(int)len {
    char ch[len];
    for (int index=0; index<len; index++) {
        
        int num = arc4random_uniform(75)+48;
        if (num>57 && num<65) { num = num%57+48; }
        else if (num>90 && num<97) { num = num%90+65; }
        ch[index] = num;
    }
    
    return [[NSString alloc] initWithBytes:ch length:len encoding:NSUTF8StringEncoding];
}


@end
