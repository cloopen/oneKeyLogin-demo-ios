//
//  AppDelegate.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/5/31.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "RootViewController.h"
#import "IQKeyboardManager.h"
#import <RLVerification/RLVerification.h>
#import "ArgsDefine.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"willFinishLaunch");
    
    //设置键盘监听管理
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [RLVerification removeServerConfig];
    RLVerification.sharedInstance.debug = YES;
    [RLVerification.sharedInstance setupWithAppID:APPID withCompletionHandler:^(void) {
        NSLog(@"😁初始化成功");
    } failReason:^(RLResult * _Nonnull result) {
        NSLog(@"😁初始化失败 %@", result.code);
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"didFinishLaunch");
    
    // 如果没有触发恢复, 则重新设置根控制器
    if (!self.window.rootViewController) {
        RootViewController *rootvc = [[RootViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:rootvc];
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


// MARK: - 状态保存和恢复

// 保存
//- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
//    NSLog(@"应该保存状态 %@", coder);
//    return YES;
//}
//
//- (BOOL)application:(UIApplication *)application shouldSaveSecureApplicationState:(NSCoder *)coder {
//    NSLog(@"应该保存Secure状态 %@", coder);
//    return YES;
//}
//
//- (void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder {
//    NSLog(@"状态将要保存");
//}
//
//// 恢复
//- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
//    NSLog(@"应该恢复状态 %@", coder);
//    return YES;
//}
//
//- (BOOL)application:(UIApplication *)application shouldRestoreSecureApplicationState:(NSCoder *)coder {
//    NSLog(@"应该恢复Secure状态 %@", coder);
//    return YES;
//}
//
//- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents coder:(NSCoder *)coder {
//    NSLog(@"状态恢复中");
//    Class cls = NSClassFromString(identifierComponents.lastObject);
//    UIViewController *vc = [[cls alloc] init];
//    if (identifierComponents.count == 1) {
//        UINavigationController *nav = (UINavigationController *)vc;
//        self.window.rootViewController = nav;
//    }
//
//    return vc;
//}
//
//- (void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder {
//    NSLog(@"状态已经恢复");
//}


@end
