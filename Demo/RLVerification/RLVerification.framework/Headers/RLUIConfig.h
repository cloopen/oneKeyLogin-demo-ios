//
//  RLUIConfig.h
//  RLAccountKit
//
//  Created by Luan Chen on 2020/6/4.
//  Copyright © 2020 ccop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RLUIConfig : NSObject

#pragma mark - Navigation/导航
/**
 导航栏标题
 默认：一键登录
 */
@property (nonatomic, strong) NSString *navText;
/**
 导航栏标题字体大小
 默认：18
 */
@property (nonatomic, assign) CGFloat navTextSize;
/**
 导航栏标题颜色
 默认：黑色
 */
@property (nonatomic, strong) UIColor *navTextColor;
/**
 授权页导航的背景颜色
 默认：白色
 */
@property (nullable, nonatomic, strong) UIColor *naviBgColor;
/**
 授权页导航左边的返回按钮的图片
 默认黑色系统样式返回图片
 */
@property (nullable, nonatomic, strong) UIImage *naviBackImage;


#pragma mark - Logo/图标
/**
 授权页面上展示的图标。
 默认为 "容联·云通讯" 图标
 */
@property (nullable, nonatomic, strong) UIImage *logoImage;
/**
 LOGO图片Y偏移量
 该控件顶部（top）相对于屏幕（safeArea）的顶部（top）的距离 （下同）
 默认：40
 */
@property (nonatomic, assign) CGFloat logoOffsetY;
/**
 LOGO宽度
 默认：250
 */
@property (nonatomic, assign) CGFloat logoWidth;
/**
 LOGO高度
 默认：50
 */
@property (nonatomic, assign) CGFloat logoHeight;


#pragma mark - 号码框设置
/**
 号码框Y偏移量
 默认：100
 */
@property (nonatomic, assign) CGFloat numberOffsetY;
/**
 号码框字体颜色
 默认：darkTextColor
 */
@property (nonatomic, strong) UIColor *numberColor;
/**
 号码框字体大小
 默认：26
 */
@property (nonatomic, assign) CGFloat numberTextSize;


#pragma mark - Slogan
/**
 Slogan（标语） Y偏移量
 默认：160
 */
@property (nonatomic, assign) CGFloat sloganOffsetY;
/**
 Slogan 文字颜色
 默认：lightGrayColor
 */
@property (nonatomic, strong) UIColor *sloganTextColor;
/**
 Slogan字号
 默认：12
 */
@property (nonatomic, assign) CGFloat sloganTextSize;


#pragma mark - 一键登录 按钮设置
// 无圆角设置，因为移动CMCC中只给了设置frame，没有圆角设置属性
/**
 登录按钮文本
 默认：一键登录
 */
@property (nonatomic, strong) NSString *authButtonText;
/**
 登录按钮文本颜色
 默认：白色
 */
@property (nonatomic, strong) UIColor *authButtonTextColor;
/**
 登录按钮字体大小
 默认：18
 */
@property (nonatomic, assign) CGFloat authButtonTextSize;
/**
 登录按钮宽度
 默认：280
 */
@property (nonatomic, assign) CGFloat authButtonWidth;
/**
 登录按钮高度
 默认：46
 */
@property (nonatomic, assign) CGFloat authButtonHeight;
/**
 登录按钮 Y偏移量
 默认：230
 */
@property (nonatomic, assign) CGFloat authButtonOffsetY;
/**
 授权页认证按钮的背景图片数组， @[正常状态的背景图片, 不可用状态的背景图片, 高亮状态的背景图片]。
 默认正常状态为蓝色纯色，不可用状态的背景图片时为灰色，高亮状态为灰蓝色。
 */
@property (nullable, nonatomic, strong) NSArray<UIImage *> *authButtonImages;


#pragma mark - Switch Button/切换按钮
/**
 授权页切换账号按钮的文案
 默认：其他登录方式
 */
@property (nullable, nonatomic, copy) NSString *switchButtonText;
/**
 授权页切换账号按钮的颜色
 默认：systemBlueColor
 */
@property (nullable, nonatomic, strong) UIColor *switchButtonColor;
/**
 授权页切换账号的字体
 默认：15
 */
@property (nonatomic, assign) CGFloat switchButtonSize;
/**
 授权页切换账号按钮 Y偏移量
 默认：285
 */
@property (nonatomic, assign) CGFloat switchButtonOffsetY;
/**
 切换账号按钮隐藏状态
 默认：不隐藏
 */
@property (nonatomic, assign) BOOL switchButtonHidden;


#pragma mark - 第三方登录方式：默认居中
/**
 是否显示第三方登录按钮组
 如果显示，就是固定的 -- Apple、QQ、微信
 默认：NO，不隐藏
 */
@property (nonatomic, assign) BOOL thirdpartyHidden;


#pragma mark - 隐私条款设置
/**
 授权页面上条款勾选框大小
 默认：16x16
 */
@property (nonatomic, assign) CGSize privacyCheckedBoxSize;
/**
 授权页面上勾选框默认状态
 默认：NO，不选中
 */
@property (nonatomic, assign) BOOL privacyCheckedBoxDefaultState;
/**
 授权页面上勾选框勾选的图标
 默认为蓝色图标，推荐尺寸为12x12
 */
@property (nullable, nonatomic, strong) UIImage *privacyCheckedImage;
/**
 授权页面上勾选框未勾选的图标
 默认为白色图标，推荐尺寸为12x12
 */
@property (nullable, nonatomic, strong) UIImage *privacyUncheckedImage;
/**
 授权页面上运营商隐私协议名称的颜色
 默认：systemGreenColor
 */
@property (nonatomic, strong) UIColor *privacyMobileNameColor;
/**
 授权页面上除了运营商&合作商外，其他文字的颜色
 默认：lightGrayColor
 */
@property (nonatomic, strong) UIColor *privacyOtherTextColor;
/**
 授权页面上合作方用户协议文字
 默认：《用户协议》
 */
@property (nonatomic, strong) NSString *privacyPartnerLabelText;
/**
 授权页面上合作方用户协议URL
 授权页面上合作方可传入用户协议的URL，用户点击协议后，SDK加载打开协议页面
 默认：https://www.apple.com/legal/privacy/szh/
 Apple 隐私政策
 */
@property (nonatomic, strong) NSString *privacyPartnerUrl;
/**
 授权页面上隐私协议标签Y偏移量
 授权页面上该控件底部（bottom）相对于屏幕（safeArea）底部（bottom）的距离
 默认：10，距离底部 10
 */
@property (nonatomic, assign) CGFloat privacyLabelBottomOffsetY;
/**
 授权页面上隐私协议标签字体大小
 默认：12
 */
@property (nonatomic, assign) CGFloat privacyLabelTextSize;


#pragma mark - WebViewController Navigation/服务条款页面导航栏
/**
 服务条款页面导航的标题
 默认："用户协议"
 */
@property (nullable, nonatomic, strong) NSString *webNaviTitleText;


#pragma mark - 弹窗设置
/**
 是否为弹窗模式
 默认：NO
 */
@property (nonatomic, assign) BOOL isPopup;




/** 检查设置的值的合法性 */
- (RLUIConfig *)checkConfig;

@end
NS_ASSUME_NONNULL_END
