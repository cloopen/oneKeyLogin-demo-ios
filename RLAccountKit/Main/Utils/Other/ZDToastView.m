//
//  ZDToastView.m
//  RLAccountKit
//
//  Created by 刘义增 on 2020/9/16.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "ZDToastView.h"

@interface ZDToastView ()

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *showList;

@end

@implementation ZDToastView

static NSInteger toastTag = 12999;

- (instancetype)zd_initWithToast:(NSString *)str {
    if (self == [super init]) {
        self.text = str;
//        [self zd_setupUI];
    }
    return self;
}

- (void)zd_setupUI {
    CGFloat x = 80;
    CGFloat w = SCREEN_WIDTH - 2*x;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    self.textColor = UIColor.whiteColor;
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:14.f];
    
    CGSize lbs = [self sizeThatFits:CGSizeMake(w, 100)];
    CGFloat h = lbs.height + 20.f;
    CGFloat y = SCREEN_HEIGHT - h - 160;
    
    self.frame = CGRectMake(x, y, w, h);
    self.layer.cornerRadius = 10.f;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}


#pragma mark - 单任务

+ (void)zd_toastWithString:(NSString *)tStr
                  duration:(NSTimeInterval)time {
    ZDToastView *zd_tv = [UIApplication.sharedApplication.keyWindow viewWithTag:toastTag];
    if (zd_tv) {
        return;
    }
    
    zd_tv = [[ZDToastView alloc] zd_initWithToast:tStr];
    [zd_tv zd_setupUI];
    NSLog(@"新建单任务Toast : %@", zd_tv);
    zd_tv.tag = toastTag;
    [UIApplication.sharedApplication.keyWindow addSubview:zd_tv];
    [zd_tv zd_showToastWithDuration:time];
}

- (void)zd_showToastWithDuration:(CGFloat)duration {

    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:duration repeats:NO block:^(NSTimer * _Nonnull timer) {
            [self zd_hideToast];
        }];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(zd_hideToast) userInfo:nil repeats:NO];
    }
}

- (void)zd_hideToast {
    NSLog(@"移除单任务Toast");
    UILabel *lb = [UIApplication.sharedApplication.keyWindow viewWithTag:toastTag];
    [lb removeFromSuperview];
}


#pragma mark - 多任务

+ (void)zd_toastMultipleTaskWithString:(NSString *)tStr
                              duration:(NSTimeInterval)time {
    ZDToastView *zd_tv = [UIApplication.sharedApplication.keyWindow viewWithTag:toastTag];
    if (!zd_tv) {
        zd_tv = [[ZDToastView alloc] zd_initWithToast:tStr];
        NSLog(@"新建多任务Toast : %@", zd_tv);
        zd_tv.tag = toastTag;
        [UIApplication.sharedApplication.keyWindow addSubview:zd_tv];
        zd_tv.hidden = YES;
    }

    if (zd_tv.hidden) {
        zd_tv.text = tStr;
        [zd_tv zd_setupUI];
        [zd_tv zd_showMTToastWithDuration:time];
    } else {
        NSLog(@"新建等待任务");
        NSDictionary *dic = @{@"toast": tStr, @"duration": @(time)};
        [zd_tv.showList addObject:dic];
    }
}

- (void)zd_showMTToastWithDuration:(CGFloat)duration {
    self.hidden = NO;

    if (@available(iOS 10.0, *)) {
        [NSTimer scheduledTimerWithTimeInterval:duration repeats:NO block:^(NSTimer * _Nonnull timer) {
            [self zd_hideMTToast];
        }];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(zd_hideMTToast) userInfo:nil repeats:NO];
    }
}

- (void)zd_hideMTToast {
    UILabel *lb = [UIApplication.sharedApplication.keyWindow viewWithTag:toastTag];
    lb.hidden = YES;
    
    NSLog(@"等待任务总数量：%lu", (unsigned long)self.showList.count);
    if (self.showList.count) {
        NSDictionary *showDic = self.showList.firstObject;
        [self.showList removeObjectAtIndex:0];
        
        [ZDToastView zd_toastMultipleTaskWithString:showDic[@"toast"] duration:[showDic[@"duration"] doubleValue]];
    } else {
        [lb removeFromSuperview];
    }
}


- (NSMutableArray<NSDictionary *> *)showList {
    if (!_showList) {
        _showList = [NSMutableArray array];
    }
    return _showList;
}

@end
