//
//  RLPhoneVerifyLoginVC.m
//  RLAccountKit
//
//  Created by 刘义增 on 2020/9/18.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "RLPhoneVerifyLoginVC.h"
#import "ArgsDefine.h"
#import "UIColor+RL.h"
#import "NSString+Validate.h"
#import "NetworkManager.h"
#import "SuccessView.h"


#define VerifyCodeTimestemp @"RL_LastVerifyCodeSendedTimestempKey"
#define VerifyCodePeriod    (60 * 2) // 2分钟

@interface RLPhoneVerifyLoginVC () <UITextFieldDelegate> {
    NSInteger countTime;
    NSString *lastPhone;
    NSString *lastVerifyCode;
}

@property (nonatomic, strong) UIImageView *logoV;

@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) UITextField *verifyTF;

@property (nonatomic, strong) UIButton *sendVerifyBtn;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) NSTimer *downTimer;

@end

@implementation RLPhoneVerifyLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"验证码登录";
    self.restorationIdentifier = NSStringFromClass(self.class);
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self zd_setupUI];
    countTime = 60;
    lastPhone = @"";
    lastVerifyCode = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (_downTimer) {
        [self.downTimer invalidate];
        self.downTimer = nil;
    }
}

- (void)zd_setupUI {
    UIImage *bgImg = [UIImage imageNamed:@"bgview"];
    UIImageView *bgImgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgV.image = bgImg;
    bgImgV.contentMode = UIViewContentModeScaleAspectFill;
    // 图片可能会超出界面，所以切一下不会造成看起来的卡顿
    bgImgV.clipsToBounds = YES;
    [self.view addSubview:bgImgV];
    
    [self.view addSubview:self.logoV];
    [self.view addSubview:self.phoneTF];
    [self.view addSubview:self.verifyTF];
    [self.view addSubview:self.sendVerifyBtn];
    [self.view addSubview:self.loginBtn];
    
    [self.phoneTF addTarget:self action:@selector(zd_textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verifyTF addTarget:self action:@selector(zd_textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillLayoutSubviews {
    CGFloat rlMargin = 25;
    CGFloat effectWidth = kScreenWidth - 2*rlMargin;
    CGFloat topMargin = 160;
    CGFloat vSpacing = 20;
    CGFloat viewHeight = KphotoScale*50;
    
    CGFloat logoX = 3*rlMargin;
    CGFloat logoW = kScreenWidth - 6*rlMargin;
    CGFloat logoH = logoW / 5.f;
    self.logoV.frame = CGRectMake(logoX, topMargin, logoW, logoH);
    
    CGFloat phoneY = CGRectGetMaxY(self.logoV.frame) + vSpacing*4;
    self.phoneTF.frame = CGRectMake(rlMargin, phoneY, effectWidth, viewHeight);
    self.phoneTF.leftView.frame = CGRectMake(0, 0, 10.f, viewHeight);
    
    CGFloat verifyY = CGRectGetMaxY(self.phoneTF.frame) + vSpacing;
    CGFloat verifyBtn_W = 100;
    CGFloat verifyInnerSpacing = 20;
    CGFloat verifyTF_W = effectWidth - verifyBtn_W - verifyInnerSpacing;
    
    self.verifyTF.frame = CGRectMake(rlMargin, verifyY, verifyTF_W, viewHeight);
    self.verifyTF.leftView.frame = CGRectMake(0, 0, 10.f, viewHeight);
    
    self.sendVerifyBtn.frame = CGRectMake(CGRectGetMaxX(self.verifyTF.frame) + verifyInnerSpacing, verifyY, verifyBtn_W, viewHeight);
    
    CGFloat loginY = CGRectGetMaxY(self.verifyTF.frame) + vSpacing;
    self.loginBtn.frame = CGRectMake(rlMargin, loginY, effectWidth, viewHeight);
}

#pragma mark - 按钮绑定的事件
// 获取验证码
- (void)zd_sendVeryfyAction:(UIButton *)btn {
    NSString *phone = self.phoneTF.text;
    if (![phone zd_isValidPhone]) {
        [self zd_showTip:@"请输入正确的手机号！" afterDelay:1.f];
        return;
    }
    
    // 调用获取验证码的方法（请求后台
    [self zd_sendVerifyCodeMethod];
}

// 登录
- (void)zd_loginAction:(UIButton *)btn {
    NSString *phone = self.phoneTF.text;
    if (![phone zd_isValidPhone]) {
        [self zd_showTip:@"请输入正确的手机号！" afterDelay:1.f];
        return;
    }
    
    NSString *verifyStr = self.verifyTF.text;
    if (verifyStr.length < 4) {
        [self zd_showTip:@"请输入验证码！" afterDelay:1.f];
        return;
    }
    
    // 调用登录方法
    [self zd_loginMethod];
}

#pragma mark - 请求后台方法
// 获取验证码 请求后台
- (void)zd_sendVerifyCodeMethod {
    NSString *phone = self.phoneTF.text;
    INIT_WEAK_SELF();
    [NetworkManager.sharedInstance zd_sendVerifyCodeWithPhoneNumber:phone completion:^(NSDictionary * _Nullable resObj) {
//        NSLog(@"%@", resObj);
        // 处理
        if (resObj) {
            if ([resObj[@"statusCode"] integerValue] == 0) {
                /// 发送成功
                // 改变 获取验证码按钮 状态
                weakSelf.sendVerifyBtn.enabled = NO;
                [weakSelf.sendVerifyBtn setBackgroundColor:[UIColor colorWithRGB:0xaaaaaa alpha:0.8]];
                // 开始倒计时
                [self.downTimer fire];
                
                self->lastPhone = resObj[@"mobile"];
                self->lastVerifyCode = resObj[@"captcha"];
                NSTimeInterval ti = [[NSDate date] timeIntervalSince1970];
                // 存储发送时间
                [NSUserDefaults.standardUserDefaults setDouble:ti forKey:VerifyCodeTimestemp];
                [NSUserDefaults.standardUserDefaults synchronize];
            } else {
                [weakSelf zd_showTip:[NSString stringWithFormat:@"%@\n%@", resObj[@"statusCode"], resObj[@"statusMsg"]] afterDelay:1.5f];
            }
        } else {
            [weakSelf zd_showTip:@"验证码发送失败，请稍后重试！" afterDelay:1.5f];
        }
    }];
}

// 登录验证
- (void)zd_loginMethod {
    NSString *phone = self.phoneTF.text;
    NSString *verifyStr = self.verifyTF.text;
    
    // 手机号&验证码 正确
    if ([phone isEqualToString:lastPhone] &&
        [verifyStr isEqualToString:lastVerifyCode]) {
        
        NSTimeInterval ti = [NSUserDefaults.standardUserDefaults doubleForKey:VerifyCodeTimestemp];
        NSTimeInterval now = NSDate.date.timeIntervalSince1970;
        // 验证码有效期 2分钟
        if (now-ti > VerifyCodePeriod) {
            [self zd_showTip:@"验证码超时，请重新发送！" afterDelay:1.f];
            return;
        }
        
        // 登录成功
        [self zd_loginSuccess];
    } else {
        [self zd_showTip:@"验证码输入错误！" afterDelay:1.5f];
    }
}

// 按钮倒计时
- (void)zd_countDown {
    NSString *str = [NSString stringWithFormat:@"%ld S", (long)countTime];
    if (countTime <= 0) {
        self.sendVerifyBtn.enabled = YES;
        [self.sendVerifyBtn setBackgroundColor:[UIColor colorWithRGB:0x4169E1]];
        [self.sendVerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.downTimer invalidate];
        self.downTimer = nil;
        return;
    }
    [self.sendVerifyBtn setTitle:str forState:UIControlStateNormal];
    
    countTime -= 1;
}

// 登录成功，添加成功界面
- (void)zd_loginSuccess {
    SuccessView *sv = [[SuccessView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    sv.isForLogin = YES;
    
//    INIT_WEAK_SELF();
    [sv setCloseBlock:^{
//        weakSelf.phoneTF.text = @"";
//        weakSelf.verifyTF.text = @"";
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:sv];
    
    if (_downTimer) {
        countTime = 1;
    }
}

#pragma mark - UITextField Notification
- (void)zd_textFieldDidChange:(UITextField *)textField {
    NSInteger kMaxLength = 11;
    if (textField == self.verifyTF) {
        kMaxLength = 6;
    }
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { // 中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        else {//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}


#pragma mark - Lazy Load

- (UIImageView *)logoV {
    if (!_logoV) {
        _logoV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_white"]];
        _logoV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoV;
}

- (UITextField *)phoneTF {
    if (!_phoneTF) {
        _phoneTF = [UITextField new];
        _phoneTF.delegate = self;
        
        _phoneTF.borderStyle = UITextBorderStyleNone;
        _phoneTF.backgroundColor = [UIColor colorFromHexString:@"#eeeeee"];
        _phoneTF.layer.cornerRadius = 4.f;
        
        _phoneTF.textColor = UIColor.darkTextColor;
        _phoneTF.font = [UIFont systemFontOfSize:18];
        
        _phoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入11位手机号" attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:16],
            NSForegroundColorAttributeName: UIColor.lightGrayColor,
        }];
        
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
        _phoneTF.leftView = [[UIView alloc] init];
    }
    return _phoneTF;
}

- (UITextField *)verifyTF {
    if (!_verifyTF) {
        _verifyTF = [UITextField new];
        _verifyTF.delegate = self;
        
        _verifyTF.borderStyle = UITextBorderStyleNone;
        _verifyTF.backgroundColor = [UIColor colorFromHexString:@"#eeeeee"];
        _verifyTF.layer.cornerRadius = 4.f;
        
        _verifyTF.textColor = UIColor.darkTextColor;
        _verifyTF.font = [UIFont systemFontOfSize:18];
        
        _verifyTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:16],
            NSForegroundColorAttributeName: UIColor.lightGrayColor,
        }];
        
        _verifyTF.keyboardType = UIKeyboardTypeNumberPad;
        _verifyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _verifyTF.leftViewMode = UITextFieldViewModeAlways;
        _verifyTF.leftView = [[UIView alloc] init];
    }
    return _verifyTF;
}

- (UIButton *)sendVerifyBtn {
    if (!_sendVerifyBtn) {
        _sendVerifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendVerifyBtn setBackgroundColor:[UIColor colorWithRGB:0x4169E1]];
        
        [_sendVerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendVerifyBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_sendVerifyBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        [_sendVerifyBtn addTarget:self action:@selector(zd_sendVeryfyAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _sendVerifyBtn.layer.cornerRadius = 4.f;
    }
    return _sendVerifyBtn;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setBackgroundColor:[UIColor colorWithRGB:0x4169E1]];
        
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [_loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        [_loginBtn addTarget:self action:@selector(zd_loginAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _loginBtn.layer.cornerRadius = 4.f;
    }
    return _loginBtn;
}

- (NSTimer *)downTimer {
    if (!_downTimer) {
        countTime = 60;
        _downTimer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(zd_countDown) userInfo:nil repeats:YES];
        [NSRunLoop.currentRunLoop addTimer:_downTimer forMode:NSRunLoopCommonModes];
    }
    return _downTimer;
}

@end
