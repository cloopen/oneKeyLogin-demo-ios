#import "BaseModalTransitionAnimator.h"

const CGFloat kPresentingViewControllerTargetScale = 0.955;
const CGFloat kPresentingViewControllerTargetAlpha = 0.3;

@interface BaseModalTransitionAnimator ()

@property (nonatomic) ModalTransitionType transitionType;

@end

@implementation BaseModalTransitionAnimator

- (instancetype)initWithTransitionType:(ModalTransitionType)transitionType
{
    if (self = [super init]) {
        _transitionType = transitionType;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if (!fromViewController || !toViewController) {
        [transitionContext completeTransition:NO];
        return;
    }
    
    if ([self isBeingPresented]) {
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        [self animatePresentationTransitionWithToViewController:toViewController
                                             fromViewController:fromViewController
                                              transitionContext:transitionContext];
    } else {
        [self animateDismissalTransitionWithToViewController:toViewController
                                          fromViewController:fromViewController
                                           transitionContext:transitionContext];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

#pragma mark - Presentation

- (void)animatePresentationTransitionWithToViewController:(UIViewController *)toViewController
                                       fromViewController:(UIViewController *)fromViewController
                                        transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Slide the presented view controller from the right and darken/scale the presenting view controller.
    
    UIView *fromViewSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    [[transitionContext containerView] insertSubview:fromViewSnapshot belowSubview:toViewController.view];
    fromViewController.view.hidden = YES;
    
    UIView *blackBackgroundView = [[UIView alloc] initWithFrame:transitionContext.containerView.bounds];
    blackBackgroundView.backgroundColor = [UIColor blackColor];
    [[transitionContext containerView] insertSubview:blackBackgroundView belowSubview:fromViewSnapshot];
    
    CGAffineTransform initialTransform = CGAffineTransformMakeTranslation(CGRectGetMaxX(toViewController.view.bounds), 0.0);
    
    toViewController.view.transform = initialTransform;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.transform = CGAffineTransformIdentity;
        
        fromViewSnapshot.transform = CGAffineTransformMakeScale(kPresentingViewControllerTargetScale, kPresentingViewControllerTargetScale);
        fromViewSnapshot.alpha = kPresentingViewControllerTargetAlpha;
    } completion:^(BOOL finished) {
        fromViewSnapshot.transform = CGAffineTransformIdentity;
        fromViewSnapshot.alpha = 1.0;
        
        [blackBackgroundView removeFromSuperview];
        [fromViewSnapshot removeFromSuperview];
        fromViewController.view.hidden = NO;
        toViewController.view.hidden = NO;
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

#pragma mark - Dismissal

- (void)animateDismissalTransitionWithToViewController:(UIViewController *)toViewController
                                    fromViewController:(UIViewController *)fromViewController
                                     transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Slide the presented view controller to the right and undarken and unscale the presenting view controller.
    
    UIView *blackBackgroundView = [[UIView alloc] initWithFrame:transitionContext.containerView.bounds];
    blackBackgroundView.backgroundColor = [UIColor blackColor];
    [[transitionContext containerView] insertSubview:blackBackgroundView aboveSubview:fromViewController.view];
    
    UIView *fromViewSnapshot = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    [[transitionContext containerView] insertSubview:fromViewSnapshot aboveSubview:blackBackgroundView];
    fromViewController.view.hidden = YES;
    
    UIView *toViewSnapshot = nil;
    if(toViewController.navigationController.modalTransitionStyle == UIModalPresentationFullScreen){
        toViewSnapshot = [toViewController.view snapshotViewAfterScreenUpdates:YES];
    }else{
        toViewSnapshot = [toViewController.view snapshotViewAfterScreenUpdates:NO];
    }
    toViewSnapshot.alpha = kPresentingViewControllerTargetAlpha;
    toViewSnapshot.transform = CGAffineTransformMakeScale(kPresentingViewControllerTargetScale, kPresentingViewControllerTargetScale);
    [[transitionContext containerView] insertSubview:toViewSnapshot belowSubview:fromViewSnapshot];
    toViewController.view.hidden = YES;
    
    UIViewAnimationOptions options = [self animationOptions:transitionContext];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:options animations:^{
        if (self.dismissType == ModalTransitionDismissTypeFade) {
            fromViewSnapshot.alpha = 0.0;
        } else {
            fromViewSnapshot.transform = [self targetTransformForDismissingViewController:fromViewController forDismissType:self.dismissType];
        }
        
        toViewSnapshot.alpha = 1.0;
        toViewSnapshot.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromViewController.view.hidden = NO;
        toViewController.view.hidden = NO;
        [blackBackgroundView removeFromSuperview];
        [fromViewSnapshot removeFromSuperview];
        [toViewSnapshot removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

#pragma mark - Utilities

- (UIViewAnimationOptions)animationOptions:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return transitionContext.isInteractive ? UIViewAnimationOptionCurveLinear : UIViewAnimationOptionCurveEaseInOut;
}

- (BOOL)isBeingPresented
{
    return self.transitionType == ModalTransitionTypePresentation;
}

- (CGAffineTransform)targetTransformForDismissingViewController:(UIViewController *)fromViewController
                                                 forDismissType:(ModalTransitionDismissType)dismissType
{
    if (dismissType == ModalTransitionDismissTypeUp) {
        return CGAffineTransformMakeTranslation(0.0, -CGRectGetMaxY(fromViewController.view.frame));
    } else if (dismissType == ModalTransitionDismissTypeDown) {
        return CGAffineTransformMakeTranslation(0.0, CGRectGetMaxY(fromViewController.view.frame));
    } else if (dismissType == ModalTransitionDismissTypeRight) {
        return CGAffineTransformMakeTranslation(CGRectGetMaxX(fromViewController.view.frame), 0.0);
    }
    return CGAffineTransformIdentity;
}

@end
