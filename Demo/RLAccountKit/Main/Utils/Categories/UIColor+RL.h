@interface UIColor (RL)

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (UIColor *)colorWithRGB:(NSUInteger)rgbValue;
+ (UIColor *)colorWithRGB:(NSUInteger)rgbValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithARGB:(NSUInteger)argbValue;

// Return the color formatted as #aarrggbb
- (NSString *)hexString;

// Returns result of alpha blending receiver with color.
- (UIColor *)blendWith:(UIColor *)color;

// Parse colors formatted as #rrggbb or #aarrggbb
// Return nil in case of invalid format
+ (UIColor *)colorFromHexString:(NSString *)string;
+ (UIColor *)colorFromHexString:(NSString *)string alpha:(CGFloat)alpha;

// 适配iOS13 暗黑模式
+ (UIColor *)dynamicColorWithLightColor:(NSString *)hexStr;

@end

