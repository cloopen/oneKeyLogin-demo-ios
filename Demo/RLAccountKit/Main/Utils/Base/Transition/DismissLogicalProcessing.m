#import "DismissLogicalProcessing.h"
#import "BaseDismissInteractor.h"

// The magic constants 0.4 and 750.0 come from empirical testing.
static CGFloat const kInteractiveDismissalProgressThreshold = 0.4;
static CGFloat const kInteractiveDismissalVelocityThreshold = 750.0;

@implementation DismissLogicalProcessing

- (void)handleEventWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIGestureRecognizerState state = panGestureRecognizer.state;
    if (state == UIGestureRecognizerStateBegan) {
        [self beginInteractiveDismissalUsingPanRecognizer:panGestureRecognizer];
    } else if (state == UIGestureRecognizerStateChanged) {
        [self updateInteractiveDismissalUsingPanRecognizer:panGestureRecognizer];
    } else if (state == UIGestureRecognizerStateEnded && self.dismissInteractionController.hasStarted) {
        [self endInteractiveDismissal];
    } else if (state == UIGestureRecognizerStateCancelled && self.dismissInteractionController.hasStarted) {
        [self cancelInteractiveDismissal];
    }
}

- (void)beginInteractiveDismissalUsingPanRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    self.dismissInteractionController.hasStarted = YES;
    self.dismissInteractionController.dismissType = [self dismissTypeForPanRecognizer:panRecognizer];
    
    [panRecognizer setTranslation:CGPointZero inView:self.viewController.view];
    
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        if (!self.dismissInteractionController.shouldFinish) {
            return;
        }
        
        if (self.onCloseBlock) {
            self.onCloseBlock();
        }
        
        self.dismissInteractionController.shouldFinish = NO;
    }];
}

- (void)updateInteractiveDismissalUsingPanRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    if ([self shouldCancelInteractiveDismissalForPanRecognizer:panRecognizer]) {
        [self cancelInteractiveDismissal];
        return;
    }
    if(!self.dismissInteractionController.hasStarted){
        return;
    }
    
    BOOL shouldFinish = [self shouldFinishInteractiveDismissalForPanRecognizer:panRecognizer];
    self.dismissInteractionController.shouldFinish = shouldFinish;
    
    CGFloat progress = [self interactiveDismissalProgressFromPanRecognizer:panRecognizer];
    [self.dismissInteractionController updateInteractiveTransition:progress];
}

- (void)endInteractiveDismissal
{
    if (self.dismissInteractionController.shouldFinish) {
        [self finishInteractiveDismissal];
    } else {
        [self cancelInteractiveDismissal];
    }
}

- (void)finishInteractiveDismissal
{
    if (self.dismissInteractionController.dismissType == ModalTransitionDismissTypeDown) {
    } else {
    }
    [self.dismissInteractionController finishInteractiveTransition];
}

- (void)cancelInteractiveDismissal
{
    [self.dismissInteractionController cancelInteractiveTransition];
}

- (CGFloat)interactiveDismissalProgressFromPanRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    if ([panRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        CGFloat horizontalTranslation = [panRecognizer translationInView:self.viewController.view].x;
        CGFloat progress = horizontalTranslation / CGRectGetWidth(self.viewController.view.bounds);
        return progress;
    } else if (self.dismissInteractionController.dismissType == ModalTransitionDismissTypeDown) {
        CGFloat verticalTranslation = [panRecognizer translationInView:self.viewController.view].y;
        CGFloat progress = verticalTranslation / CGRectGetHeight(self.viewController.view.bounds);
        return progress;
    } else {
        CGFloat verticalTranslation = [panRecognizer translationInView:self.viewController.view].y;
        CGFloat progress = verticalTranslation / -CGRectGetHeight(self.viewController.view.bounds);
        return progress;
    }
}

- (CGFloat)panningVelocityFromPanRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    if ([panRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        CGFloat horizontalVelocity = [panRecognizer velocityInView:self.viewController.view].x;
        return horizontalVelocity;
    } else {
        CGFloat verticalVelocity = [panRecognizer velocityInView:self.viewController.view].y;
        return verticalVelocity;
    }
}

- (ModalTransitionDismissType)dismissTypeForPanRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    if ([panRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return ModalTransitionDismissTypeRight;
    } else {
        BOOL isMovingDown = [panRecognizer translationInView:self.viewController.view].y > 0.0;
        return isMovingDown ? ModalTransitionDismissTypeDown : ModalTransitionDismissTypeUp;
    }
}

- (BOOL)shouldFinishInteractiveDismissalForPanRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    CGFloat velocity = [self panningVelocityFromPanRecognizer:panRecognizer];
    CGFloat progress = [self interactiveDismissalProgressFromPanRecognizer:panRecognizer];
    
    if (progress > kInteractiveDismissalProgressThreshold) {
        return YES;
    }
    
    if ([panRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] || [self isDismissingDownwards]) {
        return velocity > kInteractiveDismissalVelocityThreshold;
    } else {
        // When we're dismissing upwards the velocity will be negative.
        return velocity < -kInteractiveDismissalVelocityThreshold;
    }
}

- (BOOL)shouldCancelInteractiveDismissalForPanRecognizer:(UIPanGestureRecognizer *)panRecognizer
{
    CGFloat progress = [self interactiveDismissalProgressFromPanRecognizer:panRecognizer];
    
    // Allow the user to cancel the dismissal by panning the opposite direction.
    return progress < 0.0 && self.dismissInteractionController.hasStarted;
}

- (BOOL)isDismissingDownwards
{
    return self.dismissInteractionController.dismissType == ModalTransitionDismissTypeDown;
}

- (BOOL)isDismissingUpwards
{
    return self.dismissInteractionController.dismissType == ModalTransitionDismissTypeUp;
}

@end

@implementation ArticleDismissLogicalProcessing

- (void)endInteractiveDismissal
{
    [super endInteractiveDismissal];
    [self resetArticleToPreDismissalStateIfNeeded];
}

- (void)cancelInteractiveDismissal
{
    [super cancelInteractiveDismissal];
    [self resetArticleToPreDismissalStateIfNeeded];
}

- (void)resetArticleToPreDismissalStateIfNeeded
{
    if ([self isDismissingDownwards]) {
    } else if ([self isDismissingUpwards]) {
    }
}


@end
