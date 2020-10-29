//
//  RootViewController.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/5/31.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "RootViewController.h"
#import <Masonry/Masonry.h>
#import <RLVerification/RLVerification.h>
#import "UIColor+RL.h"
#import "ArgsDefine.h"

#import "XYIntroductionPage.h"

#import "LoginViewController.h"
#import "LocalViewController.h"
#import "ZDUserPwdLoginVC.h"
#import "ZDStandbyListVC.h"

@interface RootViewController () <XYIntroductionDelegate>
@property(nonatomic, nonnull) UIImageView *imageLOGO;
@property(nonatomic, nonnull) UILabel* label;
@property(nonatomic, nonnull) UIButton *loginBtn;
@property(nonatomic, nonnull) UIButton *localBtn;

@property (nonatomic, strong) UIButton *userLoginBtn;

@end

@implementation RootViewController {
    XYIntroductionPage *_xyIntroductionPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restorationIdentifier = NSStringFromClass(self.class);
    
    self.title = @"容联一键登录DEMO";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self initUI];
    
    [self setupIntroductionPage];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [super viewDidDisappear:animated];
}

- (void)initUI {
    /// VIEW背景图片
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageV setImage:[UIImage imageNamed:@"okl_main.png"]];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    /// LOGO
    CGFloat imageW = 160;
    CGFloat imageH = 160;
    UIImageView *imageLOGO = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-imageW)/2, (SCREEN_HEIGHT - imageH)/4, imageW, imageH)];
    [imageLOGO setImage:[UIImage imageNamed:@"main_logo.png"]];
    [self.view addSubview:imageLOGO];
    _imageLOGO = imageLOGO;
    
    /// 文字
    NSShadow* shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor blueColor];
    shadow.shadowOffset = CGSizeMake(5, 5);
    shadow.shadowBlurRadius = 8;
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 10;//行间距
    style.paragraphSpacing = 8;//段间距
    style.firstLineHeadIndent = 20;//首行缩进
    NSDictionary* dict = @{
        NSFontAttributeName:[UIFont systemFontOfSize:20],//字体
        NSForegroundColorAttributeName:[UIColor whiteColor],//前景
        NSKernAttributeName:@(6),//间距
        NSParagraphStyleAttributeName:style,
        NSShadowAttributeName:shadow
    };
    NSAttributedString* attribute = [[NSAttributedString alloc]initWithString:@"您的新一代\n身份验证解决方案" attributes:dict];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(imageLOGO.bounds.origin.x ,(SCREEN_HEIGHT - imageH)/2 + 100 , SCREEN_WIDTH, 70)];
    label.attributedText = attribute;
    [label setNumberOfLines:0];
    [self.view addSubview:label];
    _label = label;
    
    /// 一键登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.frame = CGRectMake(25, CGRectGetMaxY(label.frame) + 100, SCREEN_WIDTH-50, KphotoScale*50);
    [loginBtn setBackgroundColor:[UIColor colorWithRGB:0x012161 alpha:1.0]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"一键登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [loginBtn setClipsToBounds:YES];
    [loginBtn.layer setCornerRadius:4];
    [loginBtn addTarget:self action:@selector(goLoginController) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn = loginBtn;
    
    /// 本机号码校验
    UIButton *localBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    localBtn.frame = CGRectMake(25, CGRectGetMaxY(loginBtn.frame)+15, SCREEN_WIDTH-50, KphotoScale*50);
    [localBtn setBackgroundColor:[UIColor colorWithRGB:0x012161 alpha:1.0]];
    [localBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [localBtn setTitle:@"本机号码验证" forState:UIControlStateNormal];
    [localBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [localBtn setClipsToBounds:YES];
    [localBtn.layer setCornerRadius:4];
    [localBtn addTarget:self action:@selector(goLocalController) forControlEvents:UIControlEventTouchUpInside];
    _localBtn = localBtn;
    
    /// 账号密码 登录按钮
    UIButton *userLoginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    userLoginBtn.frame = CGRectMake(25, CGRectGetMaxY(label.frame) + 100, SCREEN_WIDTH-50, KphotoScale*50);
    [userLoginBtn setBackgroundColor:[UIColor colorWithRGB:0x012161 alpha:1.0]];
    [userLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userLoginBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [userLoginBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [userLoginBtn setClipsToBounds:YES];
    [userLoginBtn.layer setCornerRadius:4];
    [userLoginBtn addTarget:self action:@selector(clickNamePwdButton:) forControlEvents:UIControlEventTouchUpInside];
    _userLoginBtn = userLoginBtn;
    
//    ZDOperatorsType ot = [ZDNetworkTools zd_getOperatorsType];
//    if ((ot & 7) == 0) {
//        [self.view addSubview:userLoginBtn];
//    } else {
        [self.view addSubview:loginBtn];
        [self.view addSubview:localBtn];
//    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (_xyIntroductionPage) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

- (void)goLoginController {
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    [self navigationToTargetViewController:vc animated:YES];
}

- (void)goLocalController {
    LocalViewController *vc = [[LocalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    [self navigationToTargetViewController:vc animated:YES];
}

- (void)clickNamePwdButton:(UIButton *)btn {
    BOOL isLogin = [zd_userDefault boolForKey:zd_standbyLoginKey];
    // 已登录，去主页
    if (isLogin) {
        ZDStandbyListVC *listVC = [[ZDStandbyListVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nav animated:YES completion:nil];
        
        return;
    }
    
    // 未登录，去登录界面
    ZDUserPwdLoginVC *userPwdVC = [[ZDUserPwdLoginVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userPwdVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - XYIntroductionPage
- (void)setupIntroductionPage {
    NSString *saveVersion = [zd_userDefault stringForKey:zd_lastVersionKey];
    NSString *curVersion = [NSBundle.mainBundle.infoDictionary valueForKey:@"CFBundleShortVersionString"];
    if ([saveVersion isEqualToString:curVersion]) {
        NSLog(@"版本一致，不会进入引导页");
        return;
    }
    // 存储当前版本
    [zd_userDefault setValue:curVersion forKey:zd_lastVersionKey];
    zd_udSync;
    
    XYIntroductionPage *xyPage = [[XYIntroductionPage alloc] init];
    xyPage.xyCoverImgArr = @[@"guide_img_1", @"guide_img_2", @"guide_img_last"];//设置浮层滚动图片数组
    xyPage.xyDelegate = self;//进入按钮事件代理
    xyPage.xyAutoScrolling = NO;//是否自动滚动
    //可以自定义设置进入按钮样式
    [xyPage.xyEnterBtn setTitle:@"开始体验" forState:UIControlStateNormal];
    [xyPage.xyEnterBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    xyPage.xyEnterBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    xyPage.xyEnterBtn.layer.borderWidth = 0.7;
    xyPage.xyEnterBtn.layer.cornerRadius = 6;
    _xyIntroductionPage = xyPage;
    [self.view addSubview:_xyIntroductionPage.view];
}

//进入按钮事件
- (void)xyIntroductionViewEnterTap:(id)sender {
    _xyIntroductionPage = nil;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat screenHeight = self.view.bounds.size.height;
    CGFloat screenWidth = self.view.bounds.size.width;
    BOOL isLandscape = screenHeight<screenWidth;
    
    CGFloat imageW = 160;
    CGFloat imageH = 160;
    CGFloat imageLOGODelta = isLandscape? -40 :0;
    [_imageLOGO mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset((screenHeight - imageH)/4 + imageLOGODelta);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(imageW);
        make.height.mas_equalTo(imageH);
    }];
    
    CGFloat labelDelta = isLandscape? -50 :0;
    [_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset((screenHeight - imageH)/2 + 100 + labelDelta);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(-60);
        make.height.mas_equalTo(70);
    }];
    
    CGFloat loginBtnDelta = isLandscape? 50 :0;
//    ZDOperatorsType ot = [ZDNetworkTools zd_getOperatorsType];
//    if ((ot & 7) == 0) {
//        [_userLoginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view.mas_bottom).offset(-128 + loginBtnDelta);
//            make.centerX.equalTo(self.view);
//            make.width.mas_equalTo(MIN(screenWidth, screenHeight)-50);
//            make.height.mas_equalTo(KphotoScale*50);
//        }];
//    } else {
        [_loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-128 + loginBtnDelta);
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(MIN(screenWidth, screenHeight)-50);
            make.height.mas_equalTo(KphotoScale*50);
        }];

        [_localBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_loginBtn.mas_bottom).offset(15);
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(MIN(screenWidth, screenHeight)-50);
            make.height.mas_equalTo(KphotoScale*50);
        }];
//    }
}

@end
