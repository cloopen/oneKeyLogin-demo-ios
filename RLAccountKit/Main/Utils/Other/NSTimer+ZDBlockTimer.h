//
//  NSTimer+ZDBlockTimer.h
//  RLAccountKit
//
//  Created by 刘义增 on 2020/9/15.
//  Copyright © 2020 ccop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (ZDBlockTimer)

// repeats == YES 时，才有必要
// repeats == NO，执行完就销毁了，不会引起循环引用
+ (NSTimer *)zd_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                       repeats:(BOOL)repeats
                                         block:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
