//
//  BaseViewController.h
//  RLAccountKit
//
//  Created by Luan Chen on 2020/4/5.
//  Copyright © 2020 luanchen. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BaseTransitionController;
NS_ASSUME_NONNULL_BEGIN

static NSString *const FirstContentNetworkNotification = @"kFirstContentNetworkNotification";
@interface BaseViewController : UIViewController

/**主动清理*/
-(void)cleanup;

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC;

/**返回按钮拦截，return NO则不返回*/
-(BOOL)customBackAction;

typedef void (^OnCloseHandler)(UIViewController *vc, id _Nullable returnObject);
@property (nonatomic, copy) OnCloseHandler onCloseBlock;
@property (nonatomic) BaseTransitionController *baseTransitionController;
//@property (nonatomic) id dismissInteractionController;
@property (nonatomic) UIScreenEdgePanGestureRecognizer *dismissScreenEdgePanGestureRecognizer;
@property (nonatomic) id returnObject;
@property (nonatomic, assign) BOOL isRotateVC;

@property (nonatomic, strong) UIButton *leftBarButton;
@property (nonatomic, strong) UIButton *rightBarButton;

-(UIButton*)setupLeftBarButtonWithTitle:(NSString*)title OrImage:(UIImage* _Nullable)image;
-(UIButton*)setupRightBarButtonWithTitle:(NSString* _Nullable)title OrImage:(UIImage* _Nullable)image;
-(UIButton*)setupRightBarButtonWithTitle:(NSString* _Nullable)title OrImage:(UIImage* _Nullable)image disableImage:(UIImage* _Nullable)disableImage;

-(void)navigationToTargetViewController:(BaseViewController *)vc animated:(BOOL)animated;
-(void)navigationToTargetViewController:(BaseViewController *)baseVC modalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle isTransparent:(BOOL)isTransparent animated:(BOOL)animated;
-(void)navigationBackAnimated:(BOOL)animated;
-(void)navigationBackAnimated:(BOOL)animated willCloseHandle:(BOOL)willCloseHandle;
-(void)navigationBackToRootWithAnimated:(BOOL)animated;
//override
- (void)statusBarFrameDidChange:(NSNotification *)notification;

-(void)hideLeftButton:(BOOL)hide;
-(void)hideRightButton:(BOOL)hide;

- (void)presentCurveToTargetController:(BaseViewController *)baseVc animated:(BOOL)animated;

- (void)setRightButtonEnable:(BOOL)enable;


- (void)zd_showTip:(NSString*)content
        afterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
