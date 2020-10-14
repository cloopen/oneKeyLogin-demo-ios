#import "BaseDismissInteractor.h"

@implementation BaseDismissInteractor

- (instancetype)init
{
    if (self = [super init]) {
        _dismissType = ModalTransitionDismissTypeRight;
    }
    return self;
}

- (void)cancelInteractiveTransition
{
    [super cancelInteractiveTransition];
    [self reset];
}

- (void)finishInteractiveTransition
{
    [super finishInteractiveTransition];
    [self reset];
}

- (void)reset
{
    self.hasStarted = NO;
    self.dismissType = ModalTransitionDismissTypeRight;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
