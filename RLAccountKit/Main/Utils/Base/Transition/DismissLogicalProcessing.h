@class BaseDismissInteractor;
@class ArticleWebView;
@interface DismissLogicalProcessing : NSObject

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) BaseDismissInteractor *dismissInteractionController;
@property (nonatomic, copy) void (^onCloseBlock)(void);

- (void)handleEventWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;

- (void)beginInteractiveDismissalUsingPanRecognizer:(UIPanGestureRecognizer *)panRecognizer;
- (void)updateInteractiveDismissalUsingPanRecognizer:(UIPanGestureRecognizer *)panRecognizer;
- (void)endInteractiveDismissal;
- (void)cancelInteractiveDismissal;

@end

@interface ArticleDismissLogicalProcessing : DismissLogicalProcessing
@property (nonatomic, strong) ArticleWebView *articleWebView;
@end
