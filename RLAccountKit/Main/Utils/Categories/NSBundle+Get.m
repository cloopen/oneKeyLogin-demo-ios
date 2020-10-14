//
//  NSBundle+Get.m
//  RLAccountKit
//
//  Created by Luan Chen on 2020/4/5.
//  Copyright © 2020 luanchen. All rights reserved.
//

#import "NSBundle+Get.h"

@implementation NSBundle (Get)
/**
 获取文件所在name，默认情况下podName和bundlename相同，传一个即可
 
 @param bundleName bundle名字，就是在resource_bundles里面的名字
 @param podName pod的名字
 @return bundle
 */
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName
                           podName:(NSString *)podName{
    if (bundleName == nil && podName == nil) {
        @throw @"bundleName和podName不能同时为空";
    }else if (bundleName == nil ) {
        bundleName = podName;
    }else if (podName == nil) {
        podName = bundleName;
    }
    
    
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:[NSBundle mainBundle];
}

+ (NSBundle *)bundleContainFileName:(NSString *)fileName
                        filePathExt:(NSString *)pathExt{
    NSBundle *containFileBundle = [NSBundle mainBundle];
    NSArray *bundlePaths = [containFileBundle pathsForResourcesOfType:@"bundle" inDirectory:nil];
    for (NSString *bundlePath in bundlePaths) {
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        BOOL inBundle = [bundle pathForResource:fileName ofType:pathExt].length;
        if (inBundle) {
            containFileBundle = bundle;
            break;
        }
    }
    return containFileBundle;
}
@end
