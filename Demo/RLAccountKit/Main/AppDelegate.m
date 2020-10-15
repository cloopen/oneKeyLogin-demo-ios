//
//  AppDelegate.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/5/31.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "IQKeyboardManager.h"
#import <RLVerification/RLVerification.h>
#import "ArgsDefine.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置键盘监听管理
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [RLVerification removeServerConfig];
    RLVerification.sharedInstance.debug = YES;
    [RLVerification.sharedInstance setupWithAppID:APPID withCompletionHandler:^(BOOL success) {
        NSLog(@"初始化成功");
    } failReason:^(RLResult * _Nonnull result) {
        NSLog(@"初始化失败 %@", result.code);
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RootViewController *rootvc = [[RootViewController alloc] init];
    self.window.rootViewController = rootvc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
