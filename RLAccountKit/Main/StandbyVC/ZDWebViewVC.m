//
//  ZDWebViewVC.m
//  RLAccountKit
//
//  Created by 刘义增 on 2020/8/28.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "ZDWebViewVC.h"
#import "ArgsDefine.h"
#import <WebKit/WebKit.h>

@interface ZDWebViewVC ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ZDWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.webView];
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *wkWVConfig = [[WKWebViewConfiguration alloc] init];
        wkWVConfig.userContentController = [[WKUserContentController alloc] init];
        WKPreferences *preferences = [[WKPreferences alloc] init];
        wkWVConfig.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, zd_statusAndNavbarH, kScreenWidth, kScreenHeight - zd_statusAndNavbarH - zd_safeBottomH) configuration:wkWVConfig];
    }
    return _webView;
}

- (void)setUrlStr:(NSString *)urlStr {
    if (!self.webView.superview) {
        [self.view addSubview:self.webView];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

@end
