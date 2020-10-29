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
    NSString *authURL = [NSString stringWithFormat:@"%@/server/path", SERVER_PATH];
    
    ///请求参数
    NSMutableDictionary *authParams = [NSMutableDictionary dictionaryWithDictionary:@{
    }];

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
    NSString *authURL = [NSString stringWithFormat:@"%@/server/path", SERVER_PATH];

    ///请求参数
    NSMutableDictionary *authParams = [NSMutableDictionary dictionaryWithDictionary:@{

    }];
    
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


/// 获取验证码
- (void)zd_sendVerifyCodeWithPhoneNumber:(NSString *)phone completion:(DemoNetworkResponse)completion {
    
    /// 获取验证码 url
    NSString *authURL = [NSString stringWithFormat:@"%@/server/path", SERVER_PATH];
    
    ///请求参数
    NSMutableDictionary *authParams = [NSMutableDictionary dictionaryWithDictionary:@{
        
    }];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:authURL]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10.f;
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:authParams options:NSJSONWritingPrettyPrinted error:nil];
    [[NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            if (data.length > 0) {
                NSError *error;
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            } else {
                if (completion) {
                    completion(nil);
                }
            }
        }];
    }] resume];
}


@end
