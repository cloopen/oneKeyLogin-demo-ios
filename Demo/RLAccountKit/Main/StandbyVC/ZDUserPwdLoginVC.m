//
//  ZDUserPwdLoginVC.m
//  RLAccountKit
//
//  Created by 刘义增 on 2020/8/28.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "ZDUserPwdLoginVC.h"
#import "ArgsDefine.h"
#import "UIColor+RL.h"
#import "ZDStandbyListVC.h"

@interface ZDUserPwdLoginVC ()

@property (nonatomic, strong) UITextField *userTF;

@property (nonatomic, strong) UITextField *pwdTF;

@end

@implementation ZDUserPwdLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户密码登录";
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view.
    [self zd_setupUI];
}

- (void)zd_setupUI {
    CGFloat lrMargin = 40;
    CGFloat tfWidth = kScreenWidth - 2*lrMargin;
    CGFloat tfHeight = 50;
    CGFloat tfVGap = 40;
    CGFloat tfTopY = kScreenHeight/2 - 2*tfHeight - 2*tfVGap;
    
    // 用户名
    UITextField *userTF = [[UITextField alloc] initWithFrame:CGRectMake(lrMargin, tfTopY, tfWidth, tfHeight)];
    userTF.borderStyle = UITextBorderStyleRoundedRect;
    userTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入账号(手机号)" attributes:@{
        NSForegroundColorAttributeName: UIColor.lightGrayColor,
        NSFontAttributeName: [UIFont systemFontOfSize:15],
    }];
    userTF.textColor = UIColor.darkTextColor;
    userTF.font = [UIFont systemFontOfSize:18];
    
//    UIImageView *userIconV = [[UIImageView alloc] init];
//    userIconV.backgroundColor = [UIColor orangeColor];
//    userTF.leftView = userIconV;
//    userTF.leftViewMode = UITextFieldViewModeAlways;
    
    userTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userTF = userTF;
    [self.view addSubview:userTF];
    
    // 密码
    UITextField *pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(lrMargin, CGRectGetMaxY(userTF.frame) + tfVGap, tfWidth, tfHeight)];
    pwdTF.borderStyle = UITextBorderStyleRoundedRect;
    pwdTF.secureTextEntry = YES;
    pwdTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{
        NSForegroundColorAttributeName: UIColor.lightGrayColor,
        NSFontAttributeName: [UIFont systemFontOfSize:15],
    }];
    pwdTF.textColor = UIColor.darkTextColor;
    pwdTF.font = [UIFont systemFontOfSize:18];
    
//    UIImageView *pwdIconV = [[UIImageView alloc] init];
//    pwdIconV.frame = CGRectMake(0, 0, 12, 12);
//    pwdIconV.backgroundColor = [UIColor orangeColor];
//    pwdTF.leftView = pwdIconV;
//    pwdTF.leftViewMode = UITextFieldViewModeAlways;
    
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTF = pwdTF;
    [self.view addSubview:pwdTF];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(lrMargin, CGRectGetMaxY(pwdTF.frame) + 100, SCREEN_WIDTH-2*lrMargin, KphotoScale*50);
    [loginBtn setBackgroundColor:[UIColor colorWithRGB:0x012161 alpha:1.0]];
    [loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [loginBtn setClipsToBounds:YES];
    [loginBtn.layer setCornerRadius:4];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)loginAction:(UIButton *)btn {
    NSString *phone = self.userTF.text;
    if (![self isPhoneNum:phone]) {
        [self zd_showTip:@"请输入正确的手机号" afterDelay:1.f];
        return;
    }
    
    NSString *pwd = self.pwdTF.text;
    if (![self isValidPassword:pwd]) {
        [self zd_showTip:@"请输入6-16位数字+字母" afterDelay:1.f];
    }
    
    if ([phone isEqualToString:@"18233156440"] &&
        [pwd isEqualToString:@"yjdl1234"]) {
        // 跳转主页
        ZDStandbyListVC *listVC = [[ZDStandbyListVC alloc] init];
        [self.navigationController pushViewController:listVC animated:YES];
        
        [zd_userDefault setBool:YES forKey:zd_standbyLoginKey];
        zd_udSync;
    } else {
        [self zd_showTip:@"账号或者密码错误" afterDelay:1.f];
    }
}

- (BOOL)isPhoneNum:(NSString*)str {
    NSString *reg = @"^1(3[0-9]|4[579]|5[0-35-9]|6[6]|7[0-35-9]|8[0-9]|9[89])\\d{8}$";
    NSPredicate *testmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [testmobile evaluateWithObject:str];
}

- (BOOL)isValidPassword:(NSString *)pwd {
    NSString *reg = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [test evaluateWithObject:pwd];
}

@end
