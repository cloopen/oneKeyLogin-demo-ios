#import <objc/runtime.h>
#import "UIView+RL.h"

@implementation UIView (RL)

#pragma mark Center

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterX:(CGFloat)x
{
    self.center = CGPointMake(x, self.center.y);
}

- (void)setCenterY:(CGFloat)y
{
    self.center = CGPointMake(self.center.x, y);
}

#pragma mark Frame

- (CGFloat)frameX
{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)frameMaxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)frameY
{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)frameMaxY
{
    return CGRectGetMaxY(self.frame);
}

- (CGPoint)frameOrigin
{
    return self.frame.origin;
}

- (void)setFrameX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setFrameY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setFrameOrigin:(CGPoint)frameOrigin
{
    CGRect frame = self.frame;
    frame.origin = frameOrigin;
    self.frame = frame;
}

- (CGFloat)frameWidth
{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)frameHeight
{
    return CGRectGetHeight(self.frame);
}

- (CGSize)frameSize
{
    return self.frame.size;
}

- (void)setFrameWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setFrameHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setFrameSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


-(void) setLeft:(CGFloat) left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

-(void) setRight:(CGFloat) right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

-(void) setTop:(CGFloat) top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

-(void) setBottom:(CGFloat) bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

-(CGFloat)left {
    return self.frame.origin.x;
}

-(CGFloat)top {
    return self.frame.origin.y;
}

-(CGFloat)right {
    return [self left] + [self frameWidth];
}

-(CGFloat)bottom {
    return [self top] + [self frameHeight];
}

#pragma mark Bounds

- (CGFloat)boundsX
{
    return CGRectGetMinX(self.bounds);
}

- (CGFloat)boundsY
{
    return CGRectGetMinY(self.bounds);
}

- (CGPoint)boundsOrigin
{
    return self.bounds.origin;
}

- (CGPoint)boundsCenter
{
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)setBoundsX:(CGFloat)x
{
    CGRect bounds = self.bounds;
    bounds.origin.x = x;
    self.bounds = bounds;
}

- (void)setBoundsY:(CGFloat)y
{
    CGRect bounds = self.bounds;
    bounds.origin.y = y;
    self.bounds = bounds;
}

- (void)setBoundsOrigin:(CGPoint)boundsOrigin
{
    CGRect bounds = self.bounds;
    bounds.origin = boundsOrigin;
    self.bounds = bounds;
}

- (CGFloat)boundsWidth
{
    return CGRectGetWidth(self.bounds);
}

- (CGFloat)boundsHeight
{
    return CGRectGetHeight(self.bounds);
}

- (CGSize)boundsSize
{
    return self.bounds.size;
}

- (void)setBoundsWidth:(CGFloat)width
{
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    self.bounds = bounds;
}

- (void)setBoundsHeight:(CGFloat)height
{
    CGRect bounds = self.bounds;
    bounds.size.height = height;
    self.bounds = bounds;
}

- (void)setBoundsSize:(CGSize)size
{
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}

#pragma mark Animation

+ (void)animate:(BOOL)animate
       duration:(NSTimeInterval)duration
          delay:(NSTimeInterval)delay
        options:(UIViewAnimationOptions)options
     animations:(void (^)(void))animations
     completion:(void (^)(BOOL finished))completion
{
    if (animate) {
        [UIView animateWithDuration:duration
                              delay:delay
                            options:options
                         animations:animations
                         completion:completion];
    } else {
        animations();
        if (completion) completion(YES);
    }
}

+ (void)animate:(BOOL)animate
       duration:(NSTimeInterval)duration
     animations:(void (^)(void))animations
     completion:(void (^)(BOOL finished))completion
{
    if (animate) {
        [UIView animateWithDuration:duration animations:animations completion:completion];
    } else {
        animations();
        if (completion) completion(YES);
    }
}

+ (void)animate:(BOOL)animate
       duration:(NSTimeInterval)duration
     animations:(void (^)(void))animations
{
    if (animate) {
        [UIView animateWithDuration:duration animations:animations];
    } else {
        animations();
    }
}

#pragma mark Misc

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x,
                                   self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x,
                                   self.bounds.size.height * self.layer.anchorPoint.y);

    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);

    CGPoint position = self.layer.position;

    position.x -= oldPoint.x;
    position.x += newPoint.x;

    position.y -= oldPoint.y;
    position.y += newPoint.y;

    self.layer.position = position;
    self.layer.anchorPoint = anchorPoint;
}

- (void)alignToPixels
{
    self.frame = [UIView alignRectToPixels:self.frame];
}

+ (CGFloat)alignToPixels:(CGFloat)value
{
    CGFloat scale = [UIScreen mainScreen].scale;
    return roundf(value * scale) / scale;
}

+ (CGRect)alignRectToPixels:(CGRect)rect
{
    CGFloat scale = UIScreen.mainScreen.scale;
    return CGRectMake(round(rect.origin.x * scale) / scale,
                      round(rect.origin.y * scale) / scale,
                      ceil(rect.size.width * scale) / scale,
                      ceil(rect.size.height * scale) / scale);
}

- (CGRect)convertScreenRect:(CGRect)rect
{
    return [self convertRect:[self.window convertRect:rect fromWindow:nil] fromView:nil];
}

- (CGPoint)convertScreenPoint:(CGPoint)point
{
    return [self convertPoint:[self.window convertPoint:point fromWindow:nil] fromView:nil];
}

- (void)layoutNow
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)removeAllSubviews
{
    for (UIView *subview in self.subviews) [subview removeFromSuperview];
}

- (void)fadeIn
{
    [self fadeIn:.2];
}

- (void)fadeIn:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    }];
}

- (void)fadeInView:(UIView *)superview
{
    [self fadeInView:superview duration:.2];
}

- (void)fadeInView:(UIView *)superview duration:(CGFloat)duration
{
    self.alpha = 0;
    [superview addSubview:self];
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    }];
}

- (void)fadeOut
{
    [self fadeOut:.2];
}

- (void)fadeOut:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    }];
}

- (void)fadeOutAndRemove
{
    [self fadeOutAndRemove:.2];
}

- (void)fadeOutAndRemove:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    }                completion:^(BOOL finished) {
        if (self.alpha == 0) [self removeFromSuperview];
    }];
}

- (void)fadeTo:(CGFloat)alpha after:(CGFloat)delay
{
    [UIView animateWithDuration:.2 delay:delay options:0 animations:^{
        self.alpha = alpha;
    }                completion:nil];
}

- (UIView *)captureView
{
    return self;
}

- (UIView *)convertToCaptureView:(CGRect *)rect
{
    UIView *captureView = self.captureView;
    if (self != captureView) {
        if (rect) {
            *rect = [self convertRect:*rect toView:captureView];
        }
    }
    return captureView;
}

- (UIView *)capture
{
    return [self captureWithRect:self.captureRect];
}

- (UIView *)captureWithRect:(CGRect)rect
{
    return [self resizableSnapshotViewFromRect:rect
                            afterScreenUpdates:NO
                                 withCapInsets:UIEdgeInsetsZero];
}

- (UIImage *)captureImage
{
    return [self captureImageWithRect:self.captureRect backgroundColor:self.backgroundColor];
}

- (UIImage *)captureImageWithRect:(CGRect)rect
{
    return [self captureImageWithRect:rect backgroundColor:self.backgroundColor];
}

- (UIImage *)captureImageWithRect:(CGRect)rect backgroundColor:(UIColor *)backgroundColor
{
    return [self captureImageWithRect:rect
                                scale:1.0
                      backgroundColor:backgroundColor
                 forceRenderInContext:NO];
}

- (UIImage *)captureImageWithRect:(CGRect)rect
                            scale:(CGFloat)scale
                  backgroundColor:(UIColor *)backgroundColor
             forceRenderInContext:(BOOL)force
{
    @autoreleasepool {
        if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
        UIView *captureView = [self convertToCaptureView:&rect];

        /* Rect should have integral height and width for making snapshot. Otherwise we will have
        * issue with transparent pixels in the image. We also don't want to lose any information of
        * snapshotted view, so we adjust scale factor a bit to make scaled image size integral.
        */
        CGRect scaledRect = CGRectApplyAffineTransform(rect,
                                                       CGAffineTransformMakeScale(scale, scale));
        scaledRect = CGRectMake(scaledRect.origin.x, scaledRect.origin.y,
                                round(scaledRect.size.width), round(scaledRect.size.height));
        CGFloat scaleWidth = scaledRect.size.width / rect.size.width;
        CGFloat scaleHeight = scaledRect.size.height / rect.size.height;
        rect = scaledRect;
        if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
        CGRect draw = rect;
        draw.origin.x = -rect.origin.x;
        draw.origin.y = -rect.origin.y;
        CGFloat alpha = 1.0;
        if (![backgroundColor getRed:NULL green:NULL blue:NULL alpha:&alpha]) {
            alpha = 0.0;
        }

        UIGraphicsBeginImageContextWithOptions(rect.size, alpha == 1.0, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, draw.origin.x, draw.origin.y);

        if (backgroundColor) {
            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
            CGContextFillRect(context, rect);
        }

        CGContextScaleCTM(context, scaleWidth, scaleHeight);

        BOOL hidden = captureView.hidden;
        captureView.hidden = NO;
        [self willCaptureView:captureView];
        if (!force) {
            force = ![captureView drawViewHierarchyInRect:captureView.bounds afterScreenUpdates:NO];
        }
        if (force) {
            [captureView.layer renderInContext:context];
        }
        [self didCaptureView:captureView];
        captureView.hidden = hidden;
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

- (void)willCaptureView:(UIView *)view
{
}

- (void)didCaptureView:(UIView *)view
{
}

- (CGRect)captureRect
{
    return self.bounds;
}

- (UIView *)subviewOfClassNamed:(char const *)className
{
    for (UIView *subview in self.subviews) {
        if (!strcmp(class_getName(subview.class), className)) return subview;
    }
    for (UIView *subview in self.subviews) {
        UIView *view = [subview subviewOfClassNamed:className];
        if (view) return view;
    }
    return nil;
}

- (CGFloat)keyboardHeightFromUserInfo:(NSDictionary *)info
{
    CGRect rect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    rect = [self convertRect:rect fromView:nil];
    /* Sometimes keyboard's size is bigger than what is actually shown on the screen.
     * For example if the hardware keyboard is connected to the iDevice it will show just
     * additional controls on the screen and will hide the keyboard contents, but will
     * report the size of the full keyboard.
     *
     * Other case is "floating split keyboard" in iPad, in this case just return the height of the actual keyboard.
     */
    return MIN(self.boundsHeight - rect.origin.y, rect.size.height);
}

- (NSArray *)enumerateAllSubViews:(BOOL)reversedOrder
{
    NSArray *allSubviews = [NSArray arrayWithObject:self];
    for (UIView *view in (reversedOrder ?
                          self.subviews.reverseObjectEnumerator :
                          self.subviews.objectEnumerator)) {
        allSubviews = [allSubviews arrayByAddingObjectsFromArray:[view enumerateAllSubViews:reversedOrder]];
    }
    return allSubviews;
}

- (BOOL)enumerateAllSubViews:(BOOL)reversedOrder
                   withBlock:(void (^)(UIView *view, BOOL *stop))block
{
//    AssertTrueOrReturnValue(block, YES, @"Block cannot be nil");
    BOOL stop = NO;
    for (UIView *view in (reversedOrder ?
                          self.subviews.reverseObjectEnumerator :
                          self.subviews.objectEnumerator)) {
        block(view, &stop);
        if (stop || [view enumerateAllSubViews:reversedOrder withBlock:block]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)allGestureRecognizersMatchesKind:(Class)classKind
{
    NSMutableArray *recognizers = [NSMutableArray array];

    for (UIView *view in [self enumerateAllSubViews:NO]) {
        for (UIGestureRecognizer *gesture in view.gestureRecognizers) {
            if ([gesture isKindOfClass:classKind]) {
                [recognizers addObject:gesture];
            }
        }
    }
    return recognizers;
}

@end
