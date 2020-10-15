//
//  NSBundle+Get.h
//  RLAccountKit
//
//  Created by Luan Chen on 2020/4/5.
//  Copyright © 2020 luanchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define vcInitUseNib \
- (instancetype)initWithNibName:(NSString *)nibNameOrNil  bundle:(NSBundle *)nibBundleOrNil \
{\
    NSString *classname = nibNameOrNil? nibNameOrNil: NSStringFromClass(self.class);\
    NSBundle *bundle = [NSBundle bundleContainFileName:classname filePathExt:@"nib"];\
    return [super initWithNibName:classname bundle:bundle];\
}

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Get)

+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName
                           podName:(NSString *)podName;


/**
 根据文件名和文件的后缀，返回包含该文件的bundle

 @param fileName 文件名
 @param pathExt 文件类型后缀 eg: .nib , .png
 @return 返回包含该文件的bundle
 */
+ (NSBundle *)bundleContainFileName:(NSString *)fileName
                        filePathExt:(NSString *)pathExt;
@end

NS_ASSUME_NONNULL_END
