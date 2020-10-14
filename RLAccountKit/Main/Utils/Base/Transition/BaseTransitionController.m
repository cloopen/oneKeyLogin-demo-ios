#import "BaseTransitionController.h"
#import "BaseModalTransitionAnimator.h"
#import "BaseDismissInteractor.h"

@implementation BaseTransitionController

static BaseTransitionController *instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BaseTransitionController alloc] init];
        instance.dismissInteractionController = [[BaseDismissInteractor alloc]init];
    });
    return instance;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[BaseModalTransitionAnimator alloc] initWithTransitionType:ModalTransitionTypePresentation];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    BaseModalTransitionAnimator *animator = [[BaseModalTransitionAnimator alloc] initWithTransitionType:ModalTransitionTypeDismissal];
    animator.dismissType = self.dismissInteractionController.dismissType;
    
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    // If the interaction hasn't started then we return nil to simply run the custom dismiss animation without interactivity.
    return self.dismissInteractionController.hasStarted ? self.dismissInteractionController : nil;
}

@end
