@class BaseDismissInteractor;

@interface BaseTransitionController : NSObject <UIViewControllerTransitioningDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic, strong) BaseDismissInteractor *dismissInteractionController;

@end
