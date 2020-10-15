//
//  ZDStandbyListVC.m
//  RLAccountKit
//
//  Created by 刘义增 on 2020/8/28.
//  Copyright © 2020 ccop. All rights reserved.
//

#import "ZDStandbyListVC.h"
#import "ArgsDefine.h"
#import "ZDWebViewVC.h"
#import "UIColor+RL.h"

@interface ZDStandbyListVC () <UITableViewDelegate, UITableViewDataSource>
 
@property (nonatomic, strong) UITableView *tableV;

@property (nonatomic, strong) NSArray <NSArray *>*dataSource;

@end

@implementation ZDStandbyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    self.view.backgroundColor = UIColor.whiteColor;
    // 隐藏返回按钮，这样删除登录界面时候，不会有  返回按钮从有到无 的现象
    [self.navigationItem setHidesBackButton:YES animated:NO];
    // Do any additional setup after loading the view.
    
    [self zd_setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *navVCs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in navVCs) {
        if ([vc isKindOfClass:NSClassFromString(@"ZDUserPwdLoginVC")]) {
            [navVCs removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = navVCs;
}

- (void)zd_setupUI {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wunguarded-availability-new"
    CGFloat tableH = kScreenHeight - zd_statusAndNavbarH - zd_safeBottomH;
    self.tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, zd_statusAndNavbarH, kScreenWidth, tableH) style:UITableViewStyleGrouped];
#pragma clang diagnostic pop
    if (@available(iOS 11.0, *)) {
        self.tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableV.backgroundColor = [UIColor colorFromHexString:@"#EEEEEE"];
    
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.rowHeight = 56.f;
    [self.view addSubview:self.tableV];
}





#pragma mark - UItableView Delegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sec = indexPath.section;
    NSInteger row = indexPath.row;
    if (sec == 0) {
        switch (row) {
            case 0:
                [self zd_openUrl:@"https://www.yuntongxun.com" withIndexPath:indexPath];
                break;
            case 1:
                [self zd_openUrl:@"https://www.yuntongxun.com/aboutus" withIndexPath:indexPath];
                break;
            case 2:
                [self zd_openUrl:@"https://www.yuntongxun.com/honor" withIndexPath:indexPath];
                break;
            case 3:
                [self zd_openUrl:@"https://www.yuntongxun.com/bigEvent" withIndexPath:indexPath];
                break;
            case 4:
                [self zd_openUrl:@"https://www.yuntongxun.com/mediaReport" withIndexPath:indexPath];
                break;
            case 5:
                [self zd_openUrl:@"https://aim-mobileauth.yuntongxun.com/okl/okl.html" withIndexPath:indexPath];
                break;
            default:
                break;
        }
    }
    else if (sec == 1) {
        switch (row) {
            case 0:
                [self zd_openUrl:@"http://doc.yuntongxun.com/p/5a670e3b3b8496dd00dd5577" withIndexPath:indexPath];
                break;
            case 1:
                [self zd_openUrl:@"https://doc.yuntongxun.com/p/5a509b683b8496dd00dcdd88" withIndexPath:indexPath];
                break;
            case 2:
                [self zd_openUrl:@"http://doc.yuntongxun.com/space/5a50fb203b8496dd00dcddd0" withIndexPath:indexPath];
                break;
            case 3:
                [self zd_openUrl:@"" withIndexPath:indexPath];
                break;
            default:
                break;
        }
    }
    else if (sec == 2) {
        switch (row) {
            case 0:
                [self zd_openUrl:@"http://m.yuntongxun.com/contact.html" withIndexPath:indexPath];
                break;
            case 1:
                [self zd_openUrl:@"https://hr.yuntongxun.com/apply/yuntongxun" withIndexPath:indexPath];
                break;
            case 2:
                [self zd_callUs];
                break;
            default:
                break;
        }
    }
}

- (void)zd_openUrl:(NSString *)url withIndexPath:(NSIndexPath *)idxpath {
    ZDWebViewVC *webVC = [[ZDWebViewVC alloc] init];
    NSString *navTitle = self.dataSource[idxpath.section][idxpath.row];
    webVC.title = navTitle;
    webVC.urlStr = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)zd_callUs {
    NSURL *url =[NSURL URLWithString:@"tel://400-610-1019"];
    UIApplication *app = UIApplication.sharedApplication;
    if ([app canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [app openURL:url options:@{} completionHandler:^(BOOL success) {}];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


- (NSArray<NSArray *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[
            @[@"官网", @"公司介绍", @"企业荣誉", @"大事记", @"媒体报道", @"隐私条款"],
            @[@"接入与验证", @"短信快速入门", @"IM快速入门"],
            @[@"关注我们", @"加入我们", @"联系我们"],
        ];
    }
    return _dataSource;
}


@end
