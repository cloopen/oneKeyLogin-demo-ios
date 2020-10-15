//
//  LoginViewController.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/4.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "LoginViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+RL.h"
#import <RLVerification/RLVerification.h>

#import "NetworkManager.h"
#import "LoginDebugViewController.h"
#import "SuccessView.h"
#import "UIImage+RL.h"

#import <AuthenticationServices/AuthenticationServices.h>


@interface LoginViewController () <RLVerificationDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property(nonatomic, strong) UIImageView *imageV;
@property(nonatomic, strong) UILabel  *label;
@property(nonatomic, strong) UIButton *fullScreenBtn;
@property(nonatomic, strong) UIButton *windowBtn;
@property(nonatomic, strong) UIButton *debugBtn;
@property(nonatomic, strong) SuccessView *successView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一键登录";
    self.view.backgroundColor = [UIColor whiteColor];
        
    [self initUI];
    RLVerification.sharedInstance.delegate = self;
    self.successView = [[SuccessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.successView.isForLogin = YES;
}

- (void)initUI {
    ///
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
    [imageV setImage:[UIImage imageNamed:@"okl_2.png"]];
    [self.view addSubview:imageV];
    _imageV = imageV;
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 2 + 20, SCREEN_WIDTH, 50)];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.attributedText = [[NSAttributedString alloc] initWithString:@"一键认证，提高用户体验" attributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:18],//字体
        NSForegroundColorAttributeName:[UIColor blackColor],//前景
        NSKernAttributeName:@(1),//间距
    }];
    [self.view addSubview:label];
    _label = label;
    
    UIButton *fullScreenBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fullScreenBtn.frame = CGRectMake(25, SCREEN_HEIGHT-KphotoScale*50*6, SCREEN_WIDTH-50, KphotoScale*50);
    [fullScreenBtn setBackgroundColor:[UIColor colorWithRGB:0x4169E1 alpha:1.0]];
    [fullScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fullScreenBtn setTitle:@"一键登录/全屏" forState:UIControlStateNormal];
    [fullScreenBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [fullScreenBtn setClipsToBounds:YES];
    [fullScreenBtn.layer setCornerRadius:4];
    [fullScreenBtn addTarget:self action:@selector(doFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fullScreenBtn];
    _fullScreenBtn = fullScreenBtn;
    
    UIButton *windowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    windowBtn.frame = CGRectMake(25, CGRectGetMaxY(fullScreenBtn.frame)+15, SCREEN_WIDTH-50, KphotoScale*50);
    [windowBtn setBackgroundColor:[UIColor colorWithRGB:0x4169E1 alpha:1.0]];
    [windowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [windowBtn setTitle:@"一键登录/弹窗" forState:UIControlStateNormal];
    [windowBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [windowBtn setClipsToBounds:YES];
    [windowBtn.layer setCornerRadius:4];
    [windowBtn addTarget:self action:@selector(doWindowScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:windowBtn];
    _windowBtn = windowBtn;
    
    UIButton *debugBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    debugBtn.frame = CGRectMake(25, CGRectGetMaxY(windowBtn.frame)+15, SCREEN_WIDTH-50, KphotoScale*50);
    [debugBtn setBackgroundColor:[UIColor colorWithRGB:0x4169E1 alpha:1.0]];
    [debugBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [debugBtn setTitle:@"一键登录/调试" forState:UIControlStateNormal];
    [debugBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [debugBtn setClipsToBounds:YES];
    [debugBtn.layer setCornerRadius:4];
    [debugBtn addTarget:self action:@selector(doDebug) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:debugBtn];
    _debugBtn = debugBtn;
}

/// 一键登录全屏
- (void)doFullScreen {
//    ZDOperatorsType ot = [ZDNetworkTools zd_getOperatorsType];
//    if ((ot & 7) == 0) {
//        [self tip:@"调起授权页失败！\n请确保您的iPhone设备中安装了中国移动/联通/电信Sim卡，并且开启了4G蜂窝煤网络！" afterDelay:3.f];
//        return;
//    }
    INIT_WEAK_SELF();
    RLUIConfig *config = [self setupCustomUI:NO];
    RLVerification.sharedInstance.uiConfig = config;
    [RLVerification.sharedInstance doLogin:^(RLResultModel *rlResult) {
        NSString *token = rlResult.token;
        [NetworkManager.sharedInstance requestMobileLoginQuery:nil token:token completion:^(NSDictionary * _Nonnull data) {
            NSString *sc = data[@"statusCode"];
            if (sc.integerValue == 0) {
//                NSString* mobile = data[@"mobile"];
                // APP服务端匹配
                [RLVerification.sharedInstance dismissLoginWithCompletion:^{
                    [weakSelf.view addSubview:weakSelf.successView];
//                    [weakSelf tip:[NSString stringWithFormat:@"手机号%@登录成功",mobile]];
                }];
            } else {
                NSString *string = [self dictToJson:data];
                [RLVerification.sharedInstance dismissLoginWithCompletion:^{
                    [weakSelf tip:[NSString stringWithFormat:@"容联服务请求失败 %@", string]];
                }];
            }
        }];
    } failReason:^(RLResult * _Nonnull result) {
        [weakSelf tip:[NSString stringWithFormat:@"%@,%@", result.code, result.message]];
    }];
}

- (void)closeWindow {
    
}

/// 一键登录弹窗
- (void)doWindowScreen {
//    ZDOperatorsType ot = [ZDNetworkTools zd_getOperatorsType];
//    if ((ot & 7) == 0) {
//        [self tip:@"调起授权页失败！\n请确保您的iPhone设备中安装了中国移动/联通/电信Sim卡，并且开启了4G蜂窝煤网络！" afterDelay:3.f];
//        return;
//    }
    INIT_WEAK_SELF();
    RLUIConfig *config = [self setupCustomUI:YES];
    RLVerification.sharedInstance.uiConfig = config;
    [RLVerification.sharedInstance doLoginPopup:^(RLResultModel *rlResult) {
        NSString *token = rlResult.token;
        [NetworkManager.sharedInstance requestMobileLoginQuery:nil token:token completion:^(NSDictionary * _Nonnull data) {
            NSString *sc = data[@"statusCode"];
            if (sc.integerValue == 0) {
                //APP服务端匹配
                [RLVerification.sharedInstance dismissLoginWithCompletion:^{
                    [weakSelf.view addSubview:weakSelf.successView];
                }];
            }else{
                NSString *string = [self dictToJson:data];
                [RLVerification.sharedInstance dismissLoginWithCompletion:^{
                    [weakSelf tip:[NSString stringWithFormat:@"容联服务请求失败 %@",string]];
                }];
            }
        }];
    } failReason:^(RLResult * _Nonnull result) {
        [weakSelf tip:[NSString stringWithFormat:@"%@,%@", result.code, result.message]];
    }];
}

- (void)doDebug {
    LoginDebugViewController *vc = [[LoginDebugViewController alloc]init];
    [self navigationToTargetViewController:vc animated:YES];
}


- (RLUIConfig *)setupCustomUI:(BOOL)ispopup {
//    return [self testCustomUI:ispopup];
    
    RLUIConfig *config = [[RLUIConfig alloc] init];
//    config.naviBgColor = UIColor.redColor;
//    config.thirdpartyHidden = YES;
    if (ispopup) {
        
    } else {
        config.logoOffsetY = 60;
        config.numberOffsetY = 130;
        config.sloganOffsetY = 200;
        config.authButtonOffsetY = 300;
        config.switchButtonOffsetY = 400;
        config.privacyLabelBottomOffsetY = ispopup ? 0.f : 10.f;
    }
    return config;
    
    /**
     // 默认值 如下：
     RLUIConfig *config = [[RLUIConfig alloc]init];
     // 需要定制化 在这里调整参数 / //否则走默认参数
     //状态栏
     config.statusBarStyle = UIStatusBarStyleDefault;
     
     //导航栏
     config.navText = @"一键登录";
     config.navTextSize = 18;
     config.navTextColor = [UIColor systemBlueColor];
     config.naviBgColor = [UIColor whiteColor];
     config.naviBackImage = [UIImage imageNamed:@"rl_login_back" inBundleName:@"RLVerification"];
     
     //logo
     config.logoImage = [UIImage imageNamed:@"demo_logo" inBundleName:@"RLVerification"];  // 自定义logo图片
     config.logoOffsetY = 40;
     config.logoWidth = 250;
     config.logoHeight = 50;
     config.logoHidden = NO;
     
     //xxxxx提供服务
     config.sloganOffsetY = 160;
     config.sloganTextColor = [UIColor lightGrayColor];
     config.sloganTextSize = 12;
     
     //手机号
     config.numberColor = [UIColor darkTextColor];
     config.numberTextSize = 26;
     config.numberOffsetY = 100;
     
     //登录按钮
     config.authButtonText = @"一键登录";
     config.authButtonTextColor = [UIColor whiteColor];
     config.authButtonTextSize = 18;
     config.authButtonWidth = 280;
     config.authButtonHeight = 46;
     config.authButtonOffsetY = 230;
     config.authButtonImages = @[[UIImage imageNamed:@"btn_n" inBundleName:@"RLVerification"],
     [UIImage imageNamed:@"btn_d" inBundleName:@"RLVerification"],
     [UIImage imageNamed:@"btn_l" inBundleName:@"RLVerification"]
     ];
     
     //其他登录方式按钮
     config.switchButtonText = @"其他登录方式";
     config.switchButtonColor = [UIColor systemBlueColor];
     config.switchButtonSize = 15;
     config.switchButtonOffsetY = 285;
     config.switchButtonHidden = NO;
     
     //隐私条款
     config.privacyCheckedBoxSize = CGSizeMake(16, 16);
     config.privacyCheckedBoxDefaultState = YES;
     config.privacyCheckedImage = [UIImage imageNamed:@"checkbox" inBundleName:@"RLVerification"];
     config.privacyUncheckedImage = [UIImage imageNamed:@"uncheckbox" inBundleName:@"RLVerification"];
     config.privacyMobileNameColor = [UIColor systemGreenColor];
     config.privacyOtherTextColor = [UIColor lightGrayColor];
     config.privacyPartnerLabelText = @"《用户协议》";
     config.privacyPartnerUrl = @"http://";
     config.privacyLabelBottomOffsetY = 0;
     config.privacyLabelTextSize = 12;
     
     //弹窗
     config.isPopup = NO;
     config.popupCornerRadius = 6;
     
     config.webNaviTitleText = @"用户协议";
     
     return config;
     */
}

- (void)tip:(NSString*)content afterDelay:(NSTimeInterval)delay {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    //控制提示框显示的时间为3秒
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:delay];
}

- (void)tip:(NSString*)content {
    [self tip:content afterDelay:3.f];
}

- (void)dismiss:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RLVerificationDelegate
/**
 用户点击了授权页面的返回按钮
 */
- (void)userDidDismissAuthViewController {
    NSLog(@"用户界面 userDidDismissAuthViewController");
}

/**
 用户点击了授权页面的"切换账户"按钮
 */
- (void)userDidSwitchAccount {
    NSLog(@"用户界面 userDidSwitchAccount");
//    INIT_WEAK_SELF();
//    [RLVerification.sharedInstance dismissLoginWithCompletion:^{
//        [weakSelf tip:@"授权界面关闭完成"];
//    }];
}
/**
 一键登录 - 用户点击了授权页面的"第三方"按钮
 */
- (void)userDidThirdPartyWithIndex:(NSInteger)index {
    UIApplication *app = [UIApplication sharedApplication];
    // 创建一个url
    NSURL *url;
    switch (index) {
        case 0: {
//            url = [NSURL URLWithString:@"App-Prefs:"];
//            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [self handleAuthrization:nil];
            return;
        }
        case 1: {
            // @"mqq://"
            url = [NSURL URLWithString:@"http://www.dogedoge.com"];
            break;
        }
        case 2: {
            // @"weixin://"
            // https://www.yuntongxun.com/advice_400.html 官网找到的
            url = [NSURL URLWithString:@"tel://400-610-1019"];
            break;
        }
        default:
            url = [NSURL URLWithString:@""];
            break;
    }
    
    // 打开url
    if ([app canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [app openURL:url options:@{} completionHandler:^(BOOL success) {}];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat screenHeight = self.view.bounds.size.height;
    BOOL isLandscape = screenHeight<screenWidth;
    
    CGFloat width = 0.f;
    CGFloat height = 0.f;
    if (isLandscape) {
        width = screenWidth/2;
        height = screenHeight;
    } else {
        width = screenWidth;
        height = screenHeight/2;
    }
    BOOL isSmallPhone = MAX(screenWidth, screenHeight)<=667;
    
    [_imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(isLandscape?44:64);
        make.leading.equalTo(self.view);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    if (isLandscape) {
        CGFloat delta = isSmallPhone?-20:0;
        [_label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset((isLandscape?44+50:64+50) +delta);
            make.centerX.equalTo(self.view.mas_centerX).offset(width/2.0);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(50);
        }];
    } else {
        CGFloat delta = isSmallPhone?-20:0;
        [_label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_centerY).offset(60+10+delta);
            make.leading.equalTo(self.view);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(50);
        }];
    }
    [_fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_label.mas_bottom).offset(20);
        make.centerX.equalTo(_label);
        make.width.mas_equalTo(width-50);
        make.height.mas_equalTo(KphotoScale*50);
    }];
    [_windowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fullScreenBtn.mas_bottom).offset(20);
        make.centerX.equalTo(_label);
        make.width.mas_equalTo(width-50);
        make.height.mas_equalTo(KphotoScale*50);
    }];
    [_debugBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_windowBtn.mas_bottom).offset(20);
        make.centerX.equalTo(_label);
        make.width.mas_equalTo(width-50);
        make.height.mas_equalTo(KphotoScale*50);
    }];
    if (_successView.superview) {
        [_successView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(0);
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(screenHeight);
        }];
    }
    
//    [GlobalTools getClassMethods:NSClassFromString(@"UAAuthViewController")];
//    NSLog(@"\n\n\n======\n");
//    [GlobalTools getClassMethods:NSClassFromString(@"EAccountAuthenticateViewController")];
    
}

- (NSString *)dictToJson:(NSDictionary *)dict {
    @try{
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString;
        if (jsonData) {
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
        NSRange range = {0,jsonString.length};
        //去掉字符串中的空格
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        NSRange range2 = {0,mutStr.length};
        //去掉字符串中的换行符
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        return mutStr;
    }@catch(NSException *exception){
        return @"";
    }
}

- (void)handleAuthrization:(UIButton *)sender {
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
        // 在用户授权期间请求的联系信息
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        controller.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        controller.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [controller performRequests];
    }
}

//! 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", controller);
    NSLog(@"%@", authorization);
    
    NSLog(@"authorization.credential：%@", authorization.credential);
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        //  需要使用钥匙串的方式保存用户的唯一信息 这里暂且处于测试阶段 是否的NSUserDefaults
        NSString *familyName = appleIDCredential.fullName.familyName;
        NSString *givenName = appleIDCredential.fullName.givenName;
        NSString *email = appleIDCredential.email;
        NSLog(@"%@, %@, %@, %@", user, familyName, givenName, email);
        
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString *password = passwordCredential.password;
        NSLog(@"%@：%@", user, password);
    } else {
        NSLog(@"授权信息均不符");
    }
}

//! 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"错误信息：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    
    if (errorMsg) {
    }
    
    if (error.localizedDescription) {
    }
    NSLog(@"controller requests：%@", controller.authorizationRequests);
}


//! 告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)) {
    
    NSLog(@"调用展示window方法：%s", __FUNCTION__);
    // 返回window
    return self.view.window;
}

/*
- (RLUIConfig *)testCustomUI:(BOOL)ispopup {
    
    RLUIConfig *config = [[RLUIConfig alloc]init];
    //状态栏
    //    config.statusBarStyle = UIStatusBarStyleLightContent;
    
    //导航栏
    config.navText = @"二键登录";
    config.navTextSize = 20;
    config.navTextColor = [UIColor systemRedColor];
    config.naviBgColor = [UIColor blueColor];
    config.naviBackImage = [UIImage imageNamed:@"navigation_back"];// inBundleName:@"RLVerification"];
    
    //logo
    config.logoImage = [UIImage imageNamed:@"ccop_one_login_title"];// inBundleName:@"RLVerification"];  // 自定义logo图片
    config.logoOffsetY = 30;
    config.logoWidth = 100;
    config.logoHeight = 100;
    config.logoHidden = NO;
    
    //xxxxx提供服务
    config.sloganOffsetY = 260;
    config.sloganTextColor = [UIColor blueColor];
    config.sloganTextSize = 16;
    
    //手机号
    config.numberColor = [UIColor redColor];
    config.numberTextSize = 36;
    config.numberOffsetY = 300;
    
    //登录按钮
    config.authButtonText = @"二键登录";
    config.authButtonTextColor = [UIColor blueColor];
    config.authButtonTextSize = 26;
    config.authButtonWidth = 380;
    config.authButtonHeight = 100;
    config.authButtonOffsetY = 50;
    config.authButtonImages = @[[UIImage imageNamed:@"btn_n" inBundleName:@"RLVerification"],
                                [UIImage imageNamed:@"btn_d" inBundleName:@"RLVerification"],
                                [UIImage imageNamed:@"btn_l" inBundleName:@"RLVerification"]
    ];
    
    //其他登录方式按钮
    config.switchButtonText = @"其他登录方式123";
    config.switchButtonColor = [UIColor systemRedColor];
    config.switchButtonSize = 20;
    config.switchButtonOffsetY = 385;
    config.switchButtonHidden = NO;
    
    //隐私条款
    config.privacyCheckedBoxSize = CGSizeMake(20, 20);
    config.privacyCheckedBoxDefaultState = NO;
    config.privacyCheckedImage = [UIImage imageNamed:@"checkbox" inBundleName:@"RLVerification"];
    config.privacyUncheckedImage = [UIImage imageNamed:@"uncheckbox" inBundleName:@"RLVerification"];
    config.privacyMobileNameColor = [UIColor systemBlueColor];
    config.privacyOtherTextColor = [UIColor blackColor];
    config.privacyPartnerLabelText = @"《容联隐私协议》";
    config.privacyPartnerUrl = @"https://aim-rcs.yuntongxun.com/okl.html";
    config.privacyLabelBottomOffsetY = 10;
    config.privacyLabelTextSize = 16;
    
    //弹窗
    config.isPopup = ispopup;
    
    config.webNaviTitleText = @"用户协议123";
    
    NSMutableArray *thirdpartyImages = [NSMutableArray array];
    if ([UIImage imageNamed:@"thirdparty_wechat"]) {
        [thirdpartyImages addObject:[UIImage imageNamed:@"thirdparty_wechat"]];
    }
    if ([UIImage imageNamed:@"thirdparty_weibo"]) {
        [thirdpartyImages addObject:[UIImage imageNamed:@"thirdparty_weibo"]];
    }
    if ([UIImage imageNamed:@"thirdparty_qq"]) {
        [thirdpartyImages addObject:[UIImage imageNamed:@"thirdparty_qq"]];
    }
    config.thirdpartyImages = thirdpartyImages;
    config.thirdpartySpacing = 60;
    config.thirdpartySize = 80;
    config.thirdpartyOffsetY = 230;
    return config;
}
*/

@end
