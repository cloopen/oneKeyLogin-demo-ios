@interface UIAlertController (Toast)

+ (void)showToastWithTitle:(NSString *)title andMessage:(NSString *)message inViewController:(UIViewController *)viewController duration:(NSTimeInterval)time;

+ (void)showToastWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle inViewController:(UIViewController *)viewController andCallBack:(void(^)(void))block;

@end
