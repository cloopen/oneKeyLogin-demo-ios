//
//  BaseNavigationController.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/4/5.
//  Copyright © 2020 luanchen. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Orientation

- (BOOL)shouldAutorotate {
    //是否允许转屏
//    return NO;
    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    //viewController所支持的全部旋转方向
//    return UIInterfaceOrientationMaskPortrait;
    return [self.visibleViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    //viewController初始显示的方向
//    return UIInterfaceOrientationPortrait;
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if(self.forceLightContentUIStatusBarStyle) {
        return UIStatusBarStyleLightContent;
    }
    return self.topViewController.preferredStatusBarStyle;
}
@end
