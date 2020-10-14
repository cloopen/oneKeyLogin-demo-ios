#import "UIAlertController+Toast.h"

@implementation UIAlertController (Toast)

+ (void)showToastWithTitle:(NSString *)title andMessage:(NSString *)message inViewController:(UIViewController *)viewController duration:(NSTimeInterval)time
{
    if (!viewController) {
        viewController = [self getCurrentVC];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [viewController presentViewController:alertController animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

+ (void)showToastWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle inViewController:(UIViewController *)viewController andCallBack:(void(^)(void))block
{
    if (!viewController) {
        viewController = [self getCurrentVC];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = viewController.view;
        popover.sourceRect = viewController.view.bounds;
        popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
    }
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (UIViewController *)getCurrentVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    if (result.childViewControllers.lastObject) {
        result = result.childViewControllers.lastObject;
    }
    if ([result isKindOfClass:[UIPageViewController class]]) {
        NSArray *vcs = ((UIPageViewController *)result).viewControllers;
        for (UIViewController *vc in vcs) {
            if (vc.isViewLoaded && vc.view.window != nil) {
                result = vc;
                break;
            }
        }
    }
    return result;
}
@end
