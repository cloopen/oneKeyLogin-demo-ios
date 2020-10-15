#import "BaseModalTransitionAnimator.h"

@interface BaseDismissInteractor : UIPercentDrivenInteractiveTransition

// YES if the interactive transition has started, otherwise NO.
@property (nonatomic, assign) BOOL hasStarted;

// YES if the owner of the interactor should call `-finishInteractiveTransition` instead of
// `-cancelInteractiveTransition`.
@property (nonatomic, assign) BOOL shouldFinish;

// The direction of the dismissal. This affects the appearance of the animation. Default is 'ModalTransitionDismissTypeRight'
@property (nonatomic, assign) ModalTransitionDismissType dismissType;

@end
