//
//  SuccessView.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/14.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "SuccessView.h"
#import <Masonry/Masonry.h>
#import "UIColor+RL.h"
#import "ArgsDefine.h"

#define MOBILE @"400 610 1019"

@interface SuccessView()

@property(nonatomic, strong) UIImageView *successView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *closeButton;

@property(nonatomic, strong) UILabel *descriptionLabel;
@property(nonatomic, strong) UILabel *subDescriptionLabel;

@end

@implementation SuccessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavAndStatusBarHeight + 10, SCREEN_WIDTH, SCREEN_HEIGHT * 0.7)];
    [imageV setImage:[UIImage imageNamed:@"success"]];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageV];
    _successView = imageV;
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.7, SCREEN_WIDTH, 70)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:22];
    label.text = @"登录成功";
    label.textColor = UIColor.blackColor;
    [self addSubview:label];
    _titleLabel = label;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(25, SCREEN_HEIGHT-KphotoScale*50*6, SCREEN_WIDTH-50, KphotoScale*50);
    [button setBackgroundColor:[UIColor colorWithRGB:0x4169E1 alpha:1.0]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"再次体验" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [button setClipsToBounds:YES];
    [button.layer setCornerRadius:KphotoScale*50/2.0];
    [button addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _closeButton = button;
    
    UILabel* descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 ,0 , SCREEN_WIDTH, 20)];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    descriptionLabel.text = [NSString stringWithFormat:@"24小时客服: %@", MOBILE];
    [self addSubview:descriptionLabel];
    descriptionLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serviceTelephoneTapAction:)];
    [descriptionLabel addGestureRecognizer:tap];
    _descriptionLabel = descriptionLabel;
    
    UILabel* subDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 ,0 , SCREEN_WIDTH, 26)];
    subDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    subDescriptionLabel.font = [UIFont systemFontOfSize:12];
    subDescriptionLabel.textColor = [UIColor lightGrayColor];
    subDescriptionLabel.text = @"欢迎咨询了解产品";
    [self addSubview:subDescriptionLabel];
    _subDescriptionLabel = subDescriptionLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat screenWidth = self.bounds.size.width;
    CGFloat screenHeight = self.bounds.size.height;
    BOOL isLandscape = screenHeight<screenWidth;
    
    CGFloat imageViewHeight = 40;
    if (_isForLogin) {
        imageViewHeight = screenHeight * 0.5;
        _successView.alpha = 1;
        _descriptionLabel.alpha = 0;
        _subDescriptionLabel.alpha = 0;
    } else {
        imageViewHeight = 0;
        _successView.alpha = 0;
        _descriptionLabel.alpha = 1;
        _subDescriptionLabel.alpha = 1;
    }
    [_successView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset((isLandscape ? 44 : kNavAndStatusBarHeight)+10);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(imageViewHeight);
    }];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_successView.mas_bottom);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(70);
    }];
    [_closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(0);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(MIN(screenWidth,screenHeight)-25*2);
        make.height.mas_equalTo(KphotoScale*50);
    }];
    [_descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_closeButton.mas_bottom).offset(20);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(20);
    }];
    [_subDescriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descriptionLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(16);
    }];
    
}

- (void)closeButtonTapped:(UIButton *)button {
    NSLog(@"closeButtonTapped");
    [self removeFromSuperview];
}
- (void)updateVerifyResult:(NSInteger)result {
    if (result == 0) {
        self.titleLabel.text = @"手机号码与本机号一致";
    } else {
        self.titleLabel.text = @"手机号码与本机号不一致";
    }
}


- (void)serviceTelephoneTapAction:(UITapGestureRecognizer *)tap {
    UIApplication *app = UIApplication.sharedApplication;
    NSURL *url = [NSURL URLWithString:@"tel://400-610-1019"];
    if ([app canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [app openURL:url options:@{} completionHandler:^(BOOL success) {}];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


@end
