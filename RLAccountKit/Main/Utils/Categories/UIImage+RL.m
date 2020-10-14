#import <CoreText/CoreText.h>

#import "UIImage+RL.h"
#import "NSBundle+Get.h"

@implementation UIImage (RL)

- (UIImage *)scaleToSize:(CGSize)size opaque:(BOOL)opaque
{
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0);
        CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh); // Expose as parameter?
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return res;
    }
}

+ (UIImage *)imageFromBreamPath:(NSString *)path
{
    @autoreleasepool {
        UIImage *image = [UIImage imageWithContentsOfFile:[[UIImage appBasePath] stringByAppendingPathComponent:path]];
        if (image != nil && [UIScreen mainScreen].scale == 2) {
            return [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        }
        return image;
    }
}

+ (UIImage *)imageFromBreamPath:(NSString *)path withSize:(CGSize)size
{
    @autoreleasepool {
        UIImage *image = [UIImage imageWithContentsOfFile:[[UIImage appBasePath] stringByAppendingPathComponent:path]];
        return [image scaleToSize:size opaque:NO];
    }
}

+ (UIImage *)imageWithTransparentBorder:(UIImage *)originalImage
{
    const CGFloat scale = UIScreen.mainScreen.scale;
    const CGRect imageRect = CGRectMake(0, 0, originalImage.size.width * scale, originalImage.size.height * scale);

    UIGraphicsBeginImageContext(imageRect.size);
    [originalImage drawInRect:CGRectInset(imageRect, scale, scale)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void)saveToFile:(NSString *)path
{
    NSData *data = UIImagePNGRepresentation(self);
    [data writeToFile:path atomically:YES];
}

+ (void)asyncLoadFromURL:(NSURL *)url callback:(void (^)(UIImage *image))callback
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        @autoreleasepool {
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                    @autoreleasepool {
                        UIImage *image = [UIImage imageWithData:imageData];
                        callback(image);
                    }
                });
        }
    });
}

- (void)forceLoad
{
    const CGImageRef cgImage = self.CGImage;
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    const CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
    const CGContextRef context = CGBitmapContextCreate(NULL, /* Where to store the data. NULL = don’t care */
            width,
            height,
            8,
            width * 4,
            colorSpace,
            kCGImageAlphaNoneSkipFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(context);
}


/**
 *  填充色绘制图片
 *
 *  @param color 填充色
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 填充色绘制带圆角的图片

 @param color 填充色
 @param cornerRadius 圆角
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize corner:(UIRectCorner)corner cornerRadius:(CGFloat)cornerRadius {
    CGRect rect = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 *  重新绘制图片
 *
 *  @param color 填充色
 *
 *  @return UIImage
 */
- (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize {
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, imageSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)itemImageWithName:(NSString *)imageName itemSize:(CGSize)itemSize{
    
    UIImage *icon = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)itemImageSize:(CGSize)itemSize
{
    UIImage *icon = self;
    UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)imageNamed:(NSString *)name
                imgType:(NSString *)imgType
{
    if (!name) {
        return nil;
    }
    UIImage *img = [UIImage imageNamed:name];
    if (img) {
        return img;
    }
    if (!imgType) {
        imgType = @"png";
    }
    NSBundle *imgBundle = [NSBundle bundleContainFileName:name filePathExt:imgType];
    NSString *path = [imgBundle pathForResource:name ofType:imgType];
    if (!path) {
        return nil;
    }
    img = [UIImage imageWithContentsOfFile:path];
    return img;
}

+ (UIImage *)imageNamed:(NSString *)imageName inBundleName:(NSString *)bundleName{
    UIImage *img = [UIImage imageNamed:imageName];
    if (img) {
        return img;
    }
    NSURL *url = [NSBundle.mainBundle URLForResource:bundleName withExtension:@"bundle"];
    if (!url) {
        return [UIImage new];
    }
    NSBundle *targetBundle = [NSBundle bundleWithURL:url];
    img = [UIImage imageNamed:imageName
                     inBundle:targetBundle
compatibleWithTraitCollection:nil];
    return img;
}

+ (UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil, width, height, 8, 0, colorSpace, bitmapInfo);// bits per component
    CGColorSpaceRelease(colorSpace);
    if (context ==NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0,0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

+ (UIImage*)imageFromGradientColors:(NSArray*)colors frame:(CGRect)frame{
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace((CGColorRef)[colors lastObject]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, NULL);
    CGPoint start;
    CGPoint end;

    start = CGPointMake(0.0, 0.0);
    end = CGPointMake(frame.size.width, 0.0);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
+ (NSString *)appBasePath
{
    static NSString *appBasePath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *fm = [NSFileManager defaultManager];
        NSURL *supportDirectory = [fm URLsForDirectory:NSApplicationSupportDirectory
                                             inDomains:NSUserDomainMask][0];
        appBasePath = [[supportDirectory URLByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] path];
    });
    return appBasePath;
}
@end
