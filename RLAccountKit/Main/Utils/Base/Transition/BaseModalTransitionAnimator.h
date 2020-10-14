typedef NS_ENUM(NSUInteger, ModalTransitionType) {
    ModalTransitionTypePresentation,
    ModalTransitionTypeDismissal,
};

typedef NS_ENUM(NSUInteger, ModalTransitionDismissType) {
    ModalTransitionDismissTypeUp,
    ModalTransitionDismissTypeDown,
    ModalTransitionDismissTypeRight,
    ModalTransitionDismissTypeFade
};

@interface BaseModalTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/**
 *  If the animator is used for a dismissal, the value of this property
 *  specifies the transition type in which to animate the dismissed view controller.
 */
@property ModalTransitionDismissType dismissType;

- (instancetype)initWithTransitionType:(ModalTransitionType)transitionType;

@end
