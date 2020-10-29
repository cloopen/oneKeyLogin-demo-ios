//
//  LocalViewController.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/4.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "LocalViewController.h"
#import <Masonry/Masonry.h>
#import "UIAlertController+Toast.h"
#import "UIColor+RL.h"

#import <RLVerification/RLVerification.h>

#import "NetworkManager.h"
#import "SuccessView.h"

@interface LocalViewController ()

@property (nonatomic, strong) UITextField* textField;
@property(nonatomic, strong) SuccessView *successView;
@property(nonatomic, strong) UIImageView *imageV;
@property(nonatomic, strong) UIButton *goBtn;
@property(nonatomic, strong) UILabel* label;

@end

@implementation LocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restorationIdentifier = NSStringFromClass(self.class);
    self.title = @"本机号码验证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    self.successView = [[SuccessView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UIImage *bgImage = [UIImage imageNamed:@"image_name"];
    self.view.layer.contents = (__bridge id)(bgImage.CGImage);
    // resize           拉伸填充
    // resizeAspect     比例缩放，可能有未填充
    // resizeAspectFill 比例缩放，可能会被裁剪
    self.view.layer.contentsGravity = @"resizeAspect";
    self.view.layer.contentsScale = bgImage.scale;
}

- (void)initUI {
    ///
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    [imageV setImage:[UIImage imageNamed:@"demo_logo"]];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageV];
    _imageV = imageV;
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, KphotoScale*50)];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.layer.borderWidth= 1.0;
    self.textField.textColor = [UIColor blackColor];
    self.textField.backgroundColor = [UIColor colorWithRGB:0xEEEEEE];
    self.textField.layer.borderColor= [UIColor lightGrayColor].CGColor;
    self.textField.layer.cornerRadius = KphotoScale*50/2.0;
    self.textField.keyboardType = UIKeyboardTypePhonePad;
    self.textField.text = @"";
    
    CGRect frame = self.textField.frame;
    frame.size.width = KphotoScale*50/2.0 - 5;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = leftview;
    
    NSString * text = @"请输入手机号码";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:text];
    [placeholder addAttribute:NSForegroundColorAttributeName
                  value:[UIColor lightGrayColor]
                  range:NSMakeRange(0, text.length)];
    self.textField.attributedPlaceholder = placeholder;
    [self.view addSubview:self.textField];
    
    
    
    UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goBtn.frame = CGRectMake(50, CGRectGetMaxY(self.textField.frame) + KphotoScale*30, SCREEN_WIDTH-100, KphotoScale*50);
//    UIImage *gradient1 = [HomeViewController ImageFromGradientColors:@[(id)[HomeViewController rgbColor:@"0033FF" andAlpha:1.0].CGColor, (id)[HomeViewController rgbColor:@"0033FF" andAlpha:1.0].CGColor] Frame:CGRectMake(0, 0, goBtn.frame.size.width, goBtn.frame.size.height)];
//    [goBtn setBackgroundImage:gradient1 forState:UIControlStateNormal];
    [goBtn setBackgroundColor:[UIColor colorWithRGB:0x0033FF alpha:1.0]];
    [goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goBtn setTitle:@"本机号码一键认证" forState:UIControlStateNormal];
    [goBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [goBtn setClipsToBounds:YES];
    [goBtn.layer setCornerRadius:KphotoScale*50/2];
    [goBtn addTarget:self action:@selector(goAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBtn];
    _goBtn = goBtn;
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 2;//行间距
    NSDictionary* dict = @{
        NSFontAttributeName:[UIFont systemFontOfSize:14],//字体
        NSForegroundColorAttributeName:[UIColor grayColor],//前景
        NSParagraphStyleAttributeName:style
    };
    NSAttributedString* attribute = [[NSAttributedString alloc]initWithString:@"点击本机号码一键认证，即代表您已同意并授权容联通过国内三大运营商为您校验手机号码认证。" attributes:dict];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(50+10 ,CGRectGetMaxY(goBtn.frame)+10 , SCREEN_WIDTH-100-10*2, 70)];
    label.attributedText = attribute;
    [label setNumberOfLines:0];
    [self.view addSubview:label];
    _label = label;
    
    
}

- (void)goAuth {
    [self.textField resignFirstResponder];
    NSString *phoneNum = self.textField.text;
    if (![self isPhoneNum:phoneNum]) {
        [UIAlertController showToastWithTitle:nil andMessage:@"手机号不正确!" inViewController:self duration:.75];
        return;
    }
    INIT_WEAK_SELF();
    [[RLVerification sharedInstance] mobileAuthWithMobile:phoneNum listener:^(RLResultModel *rlResult) {
        NSString *token = rlResult.token;
        [[NetworkManager sharedInstance] requestMobileVerify:nil token:token mobile:phoneNum completion:^(NSDictionary * _Nonnull data) {
            NSLog(@"requestMobileVerify:%@", data);
            NSString *serCode = data[@"statusCode"];
            if (serCode.integerValue == 0) {
                NSString *status = data[@"result"];
                if ([status intValue] == 0) {
                    [weakSelf.successView updateVerifyResult:[status intValue]];
                    [weakSelf.view addSubview:weakSelf.successView];
                    [weakSelf tip:@"是"];
                }else if ([status intValue] == 1){
                    [weakSelf.successView updateVerifyResult:[status intValue]];
                    [weakSelf.view addSubview:weakSelf.successView];
                    [weakSelf tip:@"非"];
                }else{
                    [weakSelf tip:@"未知"];
                }
            }else{
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:0];
                NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [weakSelf tip:dataStr afterDelay:5.f];
            }
        }];
        
    } failReason:^(RLResult * _Nonnull result) {
        [weakSelf tip:[NSString stringWithFormat:@"%@, %@", result.code, result.message]];
    }];
}

- (void)tip:(NSString*)content afterDelay:(NSTimeInterval)delay {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
     [self presentViewController:alert animated:YES completion:nil];
    //控制提示框显示的时间为3秒
     [self performSelector:@selector(dismiss:) withObject:alert afterDelay:delay];
}

- (void)tip:(NSString *)content {
    [self tip:content afterDelay:.75];
}

- (void)dismiss:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isPhoneNum:(NSString*)str {
    NSString *MOBILE = @"^1(3[0-9]|4[579]|5[0-35-9]|6[6]|7[0-35-9]|8[0-9]|9[89])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:str];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat screenHeight = self.view.bounds.size.height;
    
    CGFloat imageAlignTop = screenWidth>screenHeight ? 70 : 100 ;
    [_imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageAlignTop);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(50);
    }];
    
    CGFloat buttonWidth = MIN(screenWidth, screenHeight)-100;
    [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(_imageV.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(KphotoScale*50);
    }];
    
    [_goBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textField.mas_bottom).offset(KphotoScale*30);
         make.centerX.equalTo(self.view);
         make.width.mas_equalTo(buttonWidth);
         make.height.mas_equalTo(KphotoScale*50);
     }];
    
    [_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_goBtn.mas_bottom).offset(KphotoScale*10);
         make.centerX.equalTo(self.view);
         make.width.mas_equalTo(buttonWidth);
         make.height.mas_equalTo(KphotoScale*70);
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

@end
