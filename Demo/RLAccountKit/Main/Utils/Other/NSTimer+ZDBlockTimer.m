//
//  NSTimer+ZDBlockTimer.m
//  RLAccountKit
//
//  Created by 刘义增 on 2020/9/15.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "NSTimer+ZDBlockTimer.h"

@implementation NSTimer (ZDBlockTimer)

+ (NSTimer *)zd_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                       repeats:(BOOL)repeats
                                         block:(void(^)(void))block {

    return [self scheduledTimerWithTimeInterval:ti
                                         target:self
                                       selector:@selector(zd_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)zd_blockInvoke:(NSTimer *)timer {

    void(^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}


/**
 // 使用
 __weak ViewController *weakSelf = self;
 _timer = [NSTimer zd_scheduledTimerWithTimeInterval:5.0
                                             repeats:YES
                                               block:^{
     __strong ViewController *strongSelf = weakSelf;
     [strongSelf method];
 }];
 */


@end
