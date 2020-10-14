/**
 * Helpers and other useful stuff for UIImage.
 */
@interface UIImage (RL)

/**
 * Returns a new UIImage that has been scaled to the specified size.
 *
 * @param size The size of the new image, in points.
 * @param opaque Ignores the alpha channel if set to YES.
 */
- (UIImage *)scaleToSize:(CGSize)size opaque:(BOOL)opaque;

/**
 * Saves an image to the disk at specified path.
 *
 * @param path Path to save the image to.
 */
- (void)saveToFile:(NSString *)path;

/**
 * Loads and returns the image at the supplied path from Bream.
 *
 * This method does not look for a @2x version or similar, but do set the
 * content scale factor to 2.0 on retina devices.
 *
 * @warning This method does not cache the image object.
 * @param path The path to the image file, supplied by Bream.
 */
+ (UIImage *)imageFromBreamPath:(NSString *)path;

/**
 * Loads, scales and returns the image at the supplied path from Bream.
 *
 * This method does not look for a @2x version or similar, but do set the
 * content scale factor to 2.0 on retina devices and uses all the pixel data
 * of the original image when scaling on both retina and non-retina.
 *
 * @warning This method does not cache the image object.
 * @param path The path to the image file, supplied by Bream.
 * @param size The size of the image, in points.
 */
+ (UIImage *)imageFromBreamPath:(NSString *)path withSize:(CGSize)size;

/**
 * Creates a copy from image with transparent 2px (or 1px) border.
 * It is necessary to have smooth edges w/o offscreen-rendering penalty when the image is rotated.
 *
 * @warning the result image will be bigger than the original one.
 * @param originalImage image to add borders to.
 */
+ (UIImage *)imageWithTransparentBorder:(UIImage *)originalImage;

+ (void)asyncLoadFromURL:(NSURL *)url callback:(void (^)(UIImage *image))callback;

- (void)forceLoad;

+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize;
- (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize;
+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize corner:(UIRectCorner)corner cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)itemImageWithName:(NSString *)imageName itemSize:(CGSize)itemSize;
- (UIImage *)itemImageSize:(CGSize)itemSize;


/**
 去各个bundle包里面查找图片，找到返回图片对象

 @param name 图片名字
 @param imgType 图片类型 eg: png  , jpg
 @return 图片对象
 */
+ (UIImage *)imageNamed:(NSString *)name
                imgType:(NSString *)imgType;

+ (UIImage *)imageNamed:(NSString *)imageName inBundleName:(NSString *)bundleName;
+ (UIImage *)grayImage:(UIImage *)sourceImage;

+ (UIImage*)imageFromGradientColors:(NSArray*)colors frame:(CGRect)frame;
@end
