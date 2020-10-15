//
//  SuccessView.h
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/14.
//  Copyright © 2020 ccop. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuccessView : UIView

@property(nonatomic, assign) BOOL isForLogin;

-(void)updateVerifyResult:(NSInteger)result;

@end

NS_ASSUME_NONNULL_END
