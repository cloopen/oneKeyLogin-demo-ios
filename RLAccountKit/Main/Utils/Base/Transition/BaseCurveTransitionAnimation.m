//
//  BaseCurveTransitionAnimation.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/4/5.
//  Copyright © 2020 luanchen. All rights reserved.
//

#import "BaseCurveTransitionAnimation.h"
@interface BaseCurveTransitionAnimation()
@property (nonatomic, assign) BOOL dismiss;
@end

@implementation BaseCurveTransitionAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_dismiss) {
        [self dismiss:transitionContext];
    } else {
        [self present:transitionContext];
    }
}

- (void)present:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    UIView * fromView = fromVC.view;
    UIView * toView = toVC.view;
    toView.alpha = 0;
    [containerView addSubview:toView];
    [[transitionContext containerView] bringSubviewToFront:fromView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        toView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismiss:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * fromView = fromVC.view;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.alpha = 0;
    } completion:^(BOOL finished) {
        [fromView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.dismiss = NO;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.dismiss = YES;
    return self;
}

@end
