//
//  BaseViewController.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/4/5.
//  Copyright © 2020 luanchen. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "UIImage+RL.h"
#import "UIView+RL.h"
#import "DismissLogicalProcessing.h"
#import "BaseDismissInteractor.h"
#import "CustomTransparentNavBar.h"
#import "BaseTransitionController.h"
#import "BaseCurveTransitionAnimation.h"

static inline CGFloat iosVersion(){
    static CGFloat iosV;
    static dispatch_once_t nameToken;
    dispatch_once(&nameToken, ^{
        iosV = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return iosV;
}

@interface BaseViewController ()<UIGestureRecognizerDelegate>
{
    
}

@property (nonatomic, strong) UITapGestureRecognizer *tapViewGesture;
@property (nonatomic, strong) UIView *transparentNavigationBar;/**<透明导航栏时使用的NavigationBar*/
@property (nonatomic, strong) BaseCurveTransitionAnimation *curveTransition;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.baseTransitionController = [BaseTransitionController sharedInstance];
    
    //为解决IOS的BUG，加个View让self.view立即初始化，不用等到页面渲染开始时才初始化
    [self.view addSubview:[UIView new]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.exclusiveTouch = YES;
    
    [self addNotification];
    [self setupCustomNavigationItem];
    [self setupDismissScreenEdgePanGestureRecognizer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc %@ - BaseViewController",[self class],self);
}

#pragma mark - 状态栏变化
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameDidChange:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(traitCollectionDidChange:) name:@"NM_kNotificationChangeTheme" object:nil];
}

- (void)statusBarFrameDidChange:(NSNotification *)notification {
//    NSValue *rectValue = [[notification userInfo] valueForKey:UIApplicationStatusBarFrameUserInfoKey];
//    CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
//    return UIStatusBarStyleLightContent;
}
#pragma mark - 导航栏自定义
-(void)setupCustomNavigationItem {
    
    if(self.navigationController.viewControllers.count >= 1 || ![self hideBackAction]){
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
        /**
         * by 人间不知德
         * @brief 动态image  导航栏返回按钮
         */
        UIImage *image;
        if (@available(iOS 13.0, *)) {
            if (self.view.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                image = [[UIImage imageNamed:@"navigation_back"] imageWithColor:UIColor.whiteColor imageSize:CGSizeMake(16, 16)];
            } else {
                image = [[UIImage imageNamed:@"navigation_back"] imageWithColor:UIColor.darkGrayColor imageSize:CGSizeMake(16, 16)];
            }
        } else {
            image = [[UIImage imageNamed:@"navigation_back"] imageWithColor:UIColor.darkGrayColor imageSize:CGSizeMake(16, 16)];
        }
        [self setupLeftBarButtonWithTitle:@"" OrImage:image]; //closeButton.imageView.image];//navigation_back
    }
    if ([self hideBackAction]) {
        [self.navigationItem setHidesBackButton:YES animated:NO];
        [self setupLeftBarButtonWithTitle:@"" OrImage:nil]; //closeButton.imageView.image];
    }
}

#pragma mark - 自定义系统导航栏左右按钮
-(UIButton*)setupLeftBarButtonWithTitle:(NSString*)title OrImage:(UIImage*)image{
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setFrame:CGRectMake(0, 0, 60, 44)];
    [leftBarButton setImage:image forState:UIControlStateNormal];
    leftBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    leftBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    if(iosVersion()<11){
        leftBarButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        leftBarButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    
    [leftBarButton setTitle:title forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarButton];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    
    [leftBarButton addTarget:self action:@selector(leftBarButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.navigationItem setLeftBarButtonItems:@[spaceItem,barItem] animated:YES];
    [CATransaction commit];
    _leftBarButton = leftBarButton;
    return leftBarButton;
    
}
-(void)leftBarButtonDidPressed:(UIButton*)sender{
    BOOL shouldBack = [self customBackAction];
    if(shouldBack){
        [self navigationBackAnimated:YES];
        if (self.onCloseBlock) {
            self.onCloseBlock(self, self.returnObject);
        }
    }
}
-(UIButton*)setupRightBarButtonWithTitle:(NSString*)title OrImage:(UIImage*)image{
    return [self setupRightBarButtonWithTitle:title OrImage:image disableImage:nil];
}

-(UIButton*)setupRightBarButtonWithTitle:(NSString*)title OrImage:(UIImage*)image disableImage:(UIImage*)disableImage{
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    if(iosVersion()<11){
        rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        rightBarButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    
    [rightBarButton setTitle:title forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarButton setFrame:CGRectMake(0, 0, 80, 44)];
    [rightBarButton setImage:image forState:UIControlStateNormal];
    if (disableImage) {
        [rightBarButton setImage:disableImage forState:UIControlStateDisabled];
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    
    [rightBarButton addTarget:self action:@selector(rightBarButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if(!_transparentNavigationBar)
        [self.navigationItem setRightBarButtonItems:@[barItem,spaceItem] animated:YES];
    else {
        [self.navigationItem setRightBarButtonItems:nil];
        [rightBarButton setFrameHeight:44];
        [rightBarButton setFrameY:20];
        if(iosVersion() >= 11){
            [rightBarButton setRight:SCREEN_WIDTH - 20];
        }else {
            [rightBarButton setRight:SCREEN_WIDTH];
        }
        [_transparentNavigationBar addSubview:rightBarButton];
    }
    [CATransaction commit];
    _rightBarButton = rightBarButton;
    return rightBarButton;
}
-(void)rightBarButtonDidPressed:(UIButton*)sender{
    
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([NSStringFromClass([nextResponder class])isEqualToString:@"RootViewController"]) {
        //        RootViewController * vc = (RootViewController *);
        //        nextResponder = objc_msgSend([RootViewController class], @selector(eat));
        if ([nextResponder respondsToSelector:@selector(navigationController)]) {
            nextResponder = [nextResponder performSelector:@selector(navigationController)];
        }
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}

-(void)cleanup{
    
}

-(BOOL)hideBackAction{
    return NO;
}

-(BOOL)customBackAction{
    return YES;
}

- (void)setupDismissScreenEdgePanGestureRecognizer
{
    _dismissScreenEdgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPanGestureRecognizerDidChange:)];
    _dismissScreenEdgePanGestureRecognizer.edges = UIRectEdgeLeft;
    _dismissScreenEdgePanGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_dismissScreenEdgePanGestureRecognizer];
}

-(void)navigationToTargetViewController:(BaseViewController *)baseVC modalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle isTransparent:(BOOL)isTransparent animated:(BOOL)animated{
    INIT_WEAK_SELF();
    if (self.isRotateVC) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppDelegate_AlowRotate" object:@(YES)];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppDelegate_AlowRotate" object:@(NO)];
    }
    __weak BaseViewController *weakVC = baseVC;
    BaseNavigationController *navigationController = [[BaseNavigationController alloc] initWithNavigationBarClass:isTransparent?[CustomTransparentNavBar class]:[UINavigationBar class] toolbarClass:nil];
    navigationController.viewControllers = @[weakVC];
    navigationController.transitioningDelegate = weakSelf.baseTransitionController;
    navigationController.modalPresentationStyle = modalPresentationStyle;
    navigationController.modalPresentationCapturesStatusBarAppearance = YES;
    __weak UIViewController *topRootViewController = [[UIApplication  sharedApplication] keyWindow].rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    if (topRootViewController.presentedViewController == nil){
        NSLog(@"topRootViewController:%@",topRootViewController);
        [topRootViewController presentViewController:navigationController animated:animated completion:nil];
    }
}

- (void)presentCurveToTargetController:(BaseViewController *)baseVc animated:(BOOL)animated {
    baseVc.modalPresentationStyle = UIModalPresentationCustom;
    baseVc.transitioningDelegate = self.curveTransition;
    if (self.presentedViewController == nil){
        [self presentViewController:baseVc animated:animated completion:nil];
    }
}

-(void)navigationToTargetViewController:(BaseViewController *)baseVC animated:(BOOL)animated{
    [self navigationToTargetViewController:baseVC modalPresentationStyle:UIModalPresentationCustom isTransparent:NO animated:animated];
}

-(void)navigationBackAnimated:(BOOL)animated{
    if (self.isRotateVC) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppDelegate_AlowRotate" object:@(NO)];
    }
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:animated completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

-(void)navigationBackAnimated:(BOOL)animated willCloseHandle:(BOOL)willCloseHandle{
    [self navigationBackAnimated:animated];
    if (willCloseHandle && self.onCloseBlock) {
        self.onCloseBlock(self, self.returnObject);
    }
}

-(void)setRightButtonEnable:(BOOL)enable{
    _rightBarButton.enabled = enable;
}

-(void)navigationBackToRootWithAnimated:(BOOL)animated{
    UIImage *screenshot = [self captureView:self.view frame:self.view.bounds];
    UIViewController *rootVC = self.presentingViewController;
    UIViewController *lastVC = nil;
    while (rootVC.presentingViewController) {
        lastVC = rootVC;
        rootVC = rootVC.presentingViewController;
    }
    //切换时不显示上个vc的内容
    //现在仅用作 切换国家 不显示上一个vc的图像 如果需要u扩展到通用 还要考虑到 两个不同的vc的导航/位置/是否隐藏等因素
    if (lastVC && [lastVC isKindOfClass:[UINavigationController class]]) {
        UIImageView *view = [[UIImageView alloc]initWithFrame:self.view.bounds];
        view.image = screenshot;
        UIViewController *vc = ((UINavigationController *)lastVC).viewControllers.firstObject;
        [vc.view addSubview:view];
    }
    [rootVC dismissViewControllerAnimated:animated completion:nil];
}

#pragma mark - Pan-to-dismiss
- (void)dismissPanGestureRecognizerDidChange:(UIPanGestureRecognizer *)panRecognizer
{
    INIT_WEAK_SELF();
    ArticleDismissLogicalProcessing *logicalProcessing = [ArticleDismissLogicalProcessing new];
    logicalProcessing.viewController = weakSelf;
    logicalProcessing.dismissInteractionController = self.baseTransitionController.dismissInteractionController;
    logicalProcessing.onCloseBlock = ^{
        if (weakSelf.onCloseBlock) {
            weakSelf.onCloseBlock(weakSelf, weakSelf.returnObject);
        }
    };
    [logicalProcessing handleEventWithPanGestureRecognizer:panRecognizer];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return gestureRecognizer == _dismissScreenEdgePanGestureRecognizer;
}

///截屏
- (UIImage*)captureView:(UIView *)theView frame:(CGRect)frame
{
    CGFloat scale = [UIScreen mainScreen].scale;//清晰度
    UIGraphicsBeginImageContextWithOptions(theView.frame.size,NO,scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *img;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        if ([theView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [theView drawViewHierarchyInRect:theView.bounds afterScreenUpdates:YES];
        }
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    else
    {
        CGContextSaveGState(context);
        [theView.layer renderInContext:context];
        img = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    CGRect rect = CGRectMake(frame.origin.x*scale, frame.origin.y*scale, frame.size.width*scale, frame.size.height*scale);
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, rect);
    UIImage *CGImg = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    
    return CGImg;
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    //viewController所支持的全部旋转方向
//    return UIInterfaceOrientationMaskPortrait;
//}
-(void)hideLeftButton:(BOOL)hide{
    _leftBarButton.hidden = hide;
}
-(void)hideRightButton:(BOOL)hide{
    _rightBarButton.hidden = hide;
}

#pragma mark - lazy
- (BaseCurveTransitionAnimation *)curveTransition {
    if (!_curveTransition) {
        _curveTransition = [[BaseCurveTransitionAnimation alloc] init];
    }
    return _curveTransition;
}

#pragma mark - Orientation

- (BOOL)shouldAutorotate{
    //是否允许转屏
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //viewController所支持的全部旋转方向
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //viewController初始显示的方向
    return UIInterfaceOrientationPortrait;
}


- (void)zd_showTip:(NSString*)content afterDelay:(NSTimeInterval)delay {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    //控制提示框显示的时间为3秒
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:delay];
}

- (void)zd_showTip:(NSString*)content {
    [self zd_showTip:content afterDelay:3.f];
}

- (void)dismiss:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:YES completion:nil];
}

@end
