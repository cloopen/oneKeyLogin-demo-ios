//
//  ZDToastView.h
//  RLAccountKit
//
//  Created by 刘义增 on 2020/9/16.
//  Copyright © 2020 ccop. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDToastView : UILabel

// 吐丝 可多任务按顺序执行
+ (void)zd_toastMultipleTaskWithString:(NSString *)tStr
                              duration:(NSTimeInterval)time;

// 吐丝 任务互斥：当前执行任务时，不会新建其他任务
+ (void)zd_toastWithString:(NSString *)tStr
                  duration:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
