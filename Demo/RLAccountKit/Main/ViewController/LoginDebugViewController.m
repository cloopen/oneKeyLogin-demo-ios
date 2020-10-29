//
//  LoginDebugViewController.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/4.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "LoginDebugViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+RL.h"

#import <RLVerification/RLVerification.h>

#import "NetworkManager.h"
#import "SuccessView.h"
#import "RLPhoneVerifyLoginVC.h"

@interface TopLeftLabel : UILabel

@property (nonatomic, assign) BOOL isWaitingLog;
@property (nonatomic, assign) NSTimeInterval now;

@end

@implementation TopLeftLabel
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y;
    return textRect;
}

- (void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

- (void)setText:(NSString *)text {
    NSString *newText = text;
    if (self.isWaitingLog) {
        long time = [NSDate date].timeIntervalSince1970*1000 - _now*1000;//now
        newText = [NSString stringWithFormat:@"%@\n耗时:%ldms\n日志:%@", self.text, time, text];
        self.isWaitingLog = NO; //只单次等log日志
    }
    [super setText:newText];
}
@end

@interface LoginDebugViewController () <RLVerificationDelegate>

@property(nonatomic, strong) TopLeftLabel* logLabel;
@property(nonatomic, strong) UIImageView *imageV;
@property(nonatomic, strong) UIView *labelBackgroudView;
@property(nonatomic, strong) UIButton *sdkInitBtn;
@property(nonatomic, strong) UIButton *preGettedTokenBtn;
@property(nonatomic, strong) UIButton *fullScreenBtn;
@property(nonatomic, strong) UIButton *popupBtn;
@property(nonatomic, strong) SuccessView *successView;

@end

@implementation LoginDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一键登录/调试";
    self.restorationIdentifier = NSStringFromClass(self.class);
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;//不被导航栏挡住
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [[RLVerification sharedInstance] registerDebugLogLabel:self.logLabel];
    [RLVerification sharedInstance].delegate = self;
    self.successView = [[SuccessView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.successView.isForLogin = YES;
}
- (void)initUI {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY([UIScreen mainScreen].bounds)/8, SCREEN_WIDTH - 20, 20)];
    [imageV setImage:[UIImage imageNamed:@"demo_debug_top_bg.png"]];
    [self.view addSubview:imageV];
    _imageV = imageV;
    
    UIView *labelBackgroudView = [[UIView alloc]initWithFrame:CGRectMake(18 ,CGRectGetMaxY(imageV.frame)-8 , SCREEN_WIDTH - 36, SCREEN_HEIGHT / 3)];
    labelBackgroudView.backgroundColor = [UIColor colorWithRGB:0x2C2C46];
    [self.view addSubview:labelBackgroudView];
    _labelBackgroudView = labelBackgroudView;
    
    /// 调试log文字
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;//行间距
    style.paragraphSpacing = 1.5;//段间距
//    style.firstLineHeadIndent = 20;//首行缩进
    NSDictionary *dict = @{
        NSKernAttributeName:@(1),//间距
        NSParagraphStyleAttributeName:style,
    };
    NSString *string = [NSString stringWithFormat:@"通过优化验证流程，帮助企业从根源上有效防止用户流失，提升体验，让用户享受到瞬间完成验证的体验。\n手机机型: %@\niOS系统版本: %@", GlobalTools.getCurrentDeviceModel, UIDevice.currentDevice.systemVersion];
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:string attributes:dict];
    TopLeftLabel *label = [[TopLeftLabel alloc] initWithFrame:CGRectMake(18+10, CGRectGetMaxY(imageV.frame)-8+15, SCREEN_WIDTH - 36-10*2, SCREEN_HEIGHT / 3-15*2)];
    label.attributedText = attribute;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColor.whiteColor;
    [self.view addSubview:label];
    _logLabel = label;
    
    // 打开标签用户交互
    label.userInteractionEnabled = YES;
    // 添加 双击手势（复制标签中的文字）
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapButton:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [label addGestureRecognizer:doubleTapGesture];
    
    UIButton *sdkInitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sdkInitBtn.frame = CGRectMake(25, SCREEN_HEIGHT-KphotoScale*50*6, SCREEN_WIDTH-50, KphotoScale*50);
    [sdkInitBtn setBackgroundColor:[UIColor colorWithRGB:0x4169E1 alpha:1.0]];
    [sdkInitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sdkInitBtn setTitle:@"1.SDK初始化" forState:UIControlStateNormal];
    [sdkInitBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [sdkInitBtn setClipsToBounds:YES];
    [sdkInitBtn.layer setCornerRadius:4];
    [sdkInitBtn addTarget:self action:@selector(sdkInitBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sdkInitBtn];
    _sdkInitBtn = sdkInitBtn;
    
    UIButton *preGettedTokenBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    preGettedTokenBtn.frame = CGRectMake(25, CGRectGetMaxY(sdkInitBtn.frame)+15, SCREEN_WIDTH-50, KphotoScale*50);
    [preGettedTokenBtn setBackgroundColor:[UIColor colorWithRGB:0x4169E1 alpha:1.0]];
    [preGettedTokenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [preGettedTokenBtn setTitle:@"2.SDK预取号" forState:UIControlStateNormal];
    [preGettedTokenBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [preGettedTokenBtn setClipsToBounds:YES];
    [preGettedTokenBtn.layer setCornerRadius:4];
    [preGettedTokenBtn addTarget:self action:@selector(preGettedTokenBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preGettedTokenBtn];
    _preGettedTokenBtn = preGettedTokenBtn;
    
    UIButton *fullScreenBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fullScreenBtn.frame = CGRectMake(25, CGRectGetMaxY(preGettedTokenBtn.frame)+15, SCREEN_WIDTH-50, KphotoScale*50);
    [fullScreenBtn setBackgroundColor:[UIColor colorWithRGB:0x4169E1 alpha:1.0]];
    [fullScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fullScreenBtn setTitle:@"3.拉起授权页-全屏" forState:UIControlStateNormal];
    [fullScreenBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [fullScreenBtn setClipsToBounds:YES];
    [fullScreenBtn.layer setCornerRadius:4];
    [fullScreenBtn addTarget:self action:@selector(fullScreenBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fullScreenBtn];
    _fullScreenBtn = fullScreenBtn;
    
    UIButton *popupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    popupBtn.frame = CGRectMake(25, CGRectGetMaxY(fullScreenBtn.frame)+15, SCREEN_WIDTH-50, KphotoScale*50);
    [popupBtn setBackgroundColor:[UIColor colorWithRGB:0x4169E1 alpha:1.0]];
    [popupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [popupBtn setTitle:@"4.拉起授权页-弹窗" forState:UIControlStateNormal];
    [popupBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [popupBtn setClipsToBounds:YES];
    [popupBtn.layer setCornerRadius:4];
    [popupBtn addTarget:self action:@selector(popupBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popupBtn];
    _popupBtn = popupBtn;
    
}

- (void)sdkInitBtnTapped:(UIButton *)button {
    
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;//now
    _logLabel.now = now;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:now];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    
    _logLabel.text = [NSString stringWithFormat:@"初始化步骤:\n开始时间: %@.%lld",dateString,(((long long)(now*1000))%1000)];
    _logLabel.isWaitingLog = YES;
    
    [[RLVerification sharedInstance] registerDebugLogLabel:self.logLabel];
    [[RLVerification sharedInstance] setupSDK];
}

- (void)preGettedTokenBtnTapped:(UIButton *)button {
    INIT_WEAK_SELF();
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;//now
    _logLabel.now = now;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:now];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    
    _logLabel.text = [NSString stringWithFormat:@"预取号步骤:\n开始时间: %@.%lld",dateString,(((long long)(now*1000))%1000)];
    _logLabel.isWaitingLog = YES;
    
    [[RLVerification sharedInstance] registerDebugLogLabel:self.logLabel];
    [[RLVerification sharedInstance] getAccessCode2Login:^(RLResultModel *rlResult) {
    } failReason:^(RLResult * _Nonnull result) {
        [weakSelf.logLabel setText:[NSString stringWithFormat:@"%@,%@", result.code, result.message]];
    }];
}

- (void)fullScreenBtnTapped:(UIButton *)button {
//    ZDOperatorsType ot = [ZDNetworkTools zd_getOperatorsType];
//    if ((ot & 7) == 0) {
//        [self tip:@"调起授权页失败！\n请确保您的iPhone设备中安装了中国移动/联通/电信Sim卡，并且开启了4G蜂窝煤网络！" afterDelay:3.f];
//        return;
//    }
    INIT_WEAK_SELF();
    
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;//now
    _logLabel.now = now;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:now];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    
    _logLabel.text = [NSString stringWithFormat:@"拉起授权页-全屏步骤:\n开始时间: %@.%lld",dateString,(((long long)(now*1000))%1000)];
    _logLabel.isWaitingLog = YES;
    
    RLUIConfig *config = [self setupCustomUI];
    [RLVerification sharedInstance].uiConfig = config;
    //不添加 则使用默认配置
    [[RLVerification sharedInstance] registerDebugLogLabel:self.logLabel];
    [[RLVerification sharedInstance] doLogin:^(RLResultModel *rlResult) {
        NSString *token = rlResult.token;
        [[NetworkManager sharedInstance] requestMobileLoginQuery:nil token:token completion:^(NSDictionary * _Nonnull data) {
            NSLog(@"requestMobileLoginQuery:%@", data);
            NSString *sc = data[@"statusCode"];
            if (sc.integerValue == 0) {
//                NSString* mobile = data[@"mobile"];
                //APP服务端匹配
                [[RLVerification sharedInstance] dismissLoginWithCompletion:^{
                    [weakSelf.view addSubview:weakSelf.successView];
//                   [weakSelf tip:[NSString stringWithFormat:@"手机号%@登录成功",mobile]];
                }];
            } else {
                NSString *string = [self dictToJson:data];
                [[RLVerification sharedInstance] dismissLoginWithCompletion:^{
                    [weakSelf tip:[NSString stringWithFormat:@"容联服务请求失败 %@",string]];
                }];
            }
        }];
    } failReason:^(RLResult * _Nonnull result) {
        [weakSelf tip:[NSString stringWithFormat:@"%@,%@", result.code, result.message]];
    }];
}

- (void)popupBtnTapped:(UIButton *)button {
//    ZDOperatorsType ot = [ZDNetworkTools zd_getOperatorsType];
//    if ((ot & 7) == 0) {
//        [self tip:@"调起授权页失败！\n请确保您的iPhone设备中安装了中国移动/联通/电信Sim卡，并且开启了4G蜂窝煤网络！" afterDelay:3.f];
//        return;
//    }
    INIT_WEAK_SELF();
    
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;//now
    _logLabel.now = now;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:now];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    
    _logLabel.text = [NSString stringWithFormat:@"拉起授权页-弹窗步骤:\n开始时间: %@.%lld",dateString,(((long long)(now*1000))%1000)];
    _logLabel.isWaitingLog = YES;

//    RLUIConfig *config = [self setupCustomUI];
//    [RLVerification sharedInstance].uiConfig = config;
    //不添加 则使用默认配置
    [[RLVerification sharedInstance] registerDebugLogLabel:self.logLabel];
    [[RLVerification sharedInstance] doLoginPopup:^(RLResultModel *rlResult) {
        NSString *token = rlResult.token;
        [[NetworkManager sharedInstance] requestMobileLoginQuery:nil token:token completion:^(NSDictionary * _Nonnull data) {
            NSLog(@"requestMobileLoginQuery:%@",data);
            NSString *sc = data[@"statusCode"];
            if (sc.integerValue == 0) {
//                NSString* mobile = data[@"mobile"];
                //APP服务端匹配
                [[RLVerification sharedInstance] dismissLoginWithCompletion:^{
                    [weakSelf.view addSubview:weakSelf.successView];
//                   [weakSelf tip:[NSString stringWithFormat:@"手机号%@登录成功",mobile]];
                }];
            }else{
                NSString *string = [self dictToJson:data];
                [[RLVerification sharedInstance] dismissLoginWithCompletion:^{
                    [weakSelf tip:[NSString stringWithFormat:@"容联服务请求失败 %@",string]];
                }];
            }
        }];
    } failReason:^(RLResult * _Nonnull result) {
        [weakSelf tip:[NSString stringWithFormat:@"%@,%@", result.code, result.message]];
    }];
}

- (void)dealloc {
    [[RLVerification sharedInstance] unRegisterDebugLogLabel];
}

- (void)tip:(NSString*)content afterDelay:(NSTimeInterval)delay {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
     [self presentViewController:alert animated:YES completion:nil];
    //控制提示框显示的时间为3秒
     [self performSelector:@selector(dismiss:) withObject:alert afterDelay:delay];
}

- (void)didDoubleTapButton:(id)sender {
    [UIPasteboard generalPasteboard].string = self.logLabel.text;
    [self tip:@"已拷贝至粘贴板" afterDelay:3.f];
}

- (void)tip:(NSString*)content{
    [self tip:content afterDelay:3.f];
}

- (void)dismiss:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:YES completion:nil];
}

- (RLUIConfig *)setupCustomUI {
    RLUIConfig *config = [[RLUIConfig alloc] init];
    /* 需要定制化 在这里调整参数 */ //否则走默认参数
    return config;
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
- (void)userDidSwitchAccount{
    NSLog(@"用户界面 userDidSwitchAccount");
    
    [RLVerification.sharedInstance dismissLoginWithCompletion:nil];
    
    RLPhoneVerifyLoginVC *pvVC = [[RLPhoneVerifyLoginVC alloc] init];
    [self.navigationController pushViewController:pvVC animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat screenHeight = self.view.bounds.size.height;
    BOOL isLandscape = screenHeight<screenWidth;
    
    CGFloat width = 0.f;
    CGFloat height = 0.f;
    if (isLandscape) {
        width = screenWidth/2;
        height = screenHeight;
    }else {
        width = screenWidth;
        height = screenHeight/2;
    }
    
    [_imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset((isLandscape?44:64) + 50);
        make.leading.equalTo(self.view).offset(10);
        make.width.mas_equalTo(width-20);
        make.height.mas_equalTo(20);
    }];
    
    [_labelBackgroudView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageV.mas_bottom).offset(-8);
        make.leading.equalTo(self.view).offset(18);
        make.width.mas_equalTo(width-18*2);
        make.height.mas_equalTo(height-64-100+(isLandscape?10:40));
    }];
    
    [_logLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_labelBackgroudView);
        make.width.mas_equalTo(width-18*2-15*2);
        make.height.mas_equalTo(height-64-100-15*2+(isLandscape?10:40));
    }];
    
    if (isLandscape) {
        [_sdkInitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_centerX).offset(25);
            make.width.mas_equalTo(width-50);
            make.height.mas_equalTo(KphotoScale*50);
        }];
    }else{
        [_sdkInitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(width-50);
            make.height.mas_equalTo(KphotoScale*50);
        }];
    }
    [_preGettedTokenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sdkInitBtn.mas_bottom).offset(20);
        make.centerX.equalTo(_sdkInitBtn);
        make.width.mas_equalTo(width-50);
        make.height.mas_equalTo(KphotoScale*50);
    }];
    [_fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_preGettedTokenBtn.mas_bottom).offset(20);
        make.centerX.equalTo(_sdkInitBtn);
        make.width.mas_equalTo(width-50);
        make.height.mas_equalTo(KphotoScale*50);
    }];
    [_popupBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fullScreenBtn.mas_bottom).offset(20);
        make.centerX.equalTo(_sdkInitBtn);
        make.width.mas_equalTo(width-50);
        make.height.mas_equalTo(KphotoScale*50);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    if (_successView.superview) {
        [_successView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(0);
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(screenHeight);
        }];
    }
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
@end
