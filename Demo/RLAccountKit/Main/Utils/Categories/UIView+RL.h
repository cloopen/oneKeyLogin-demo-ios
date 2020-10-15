//
//  UIView+RL.h
//  RLAccountKit
//
//  Created by Luan Chen on 2020/4/5.
//  Copyright © 2020 luanchen. All rights reserved.
//

static NSTimeInterval const kAnimationShort = .2;
static NSTimeInterval const kAnimationDefault = .3;
static NSTimeInterval const kAnimationSpring = .4; // For bouncy animations we need some more time, otherwise they will look faster by default.
static NSTimeInterval const kAnimationLong = .5;

@interface UIView (RL)

#pragma mark Center
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

#pragma mark Frame
// Reminder: frame is undefined if a non-indentity transform is applied!
@property (nonatomic) CGFloat frameX;
@property (nonatomic, readonly) CGFloat frameMaxX;
@property (nonatomic) CGFloat frameY;
@property (nonatomic, readonly) CGFloat frameMaxY;
@property (nonatomic) CGPoint frameOrigin;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;
@property (nonatomic) CGSize frameSize;;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

#pragma mark Bounds
@property (nonatomic) CGFloat boundsX;
@property (nonatomic) CGFloat boundsY;
@property (nonatomic) CGPoint boundsOrigin;
@property (nonatomic, readonly) CGPoint boundsCenter;

@property (nonatomic) CGFloat boundsWidth;
@property (nonatomic) CGFloat boundsHeight;
@property (nonatomic) CGSize boundsSize;

#pragma mark Animation
/// If animate is YES then this method just passes the parameter on to UIView's
/// equivalent method. Otherwise it executes the animation block directly.
+ (void)animate:(BOOL)animate duration:(NSTimeInterval)duration animations:(void (^)(void))animations;

/// If animate is YES then this method just passes the parameter on to UIView's
/// equivalent method. Otherwise it executes both blocks directly (finished == YES).
+ (void)animate:(BOOL)animate duration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

/// If animate is YES then this method just passes the parameter on to UIView's
/// equivalent method. Otherwise it executes both blocks directly (finished == YES).
+ (void)animate:(BOOL)animate duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

#pragma mark Misc

// Sets the anchorpoint of the view's layer and moves the position accordingly
- (void)setAnchorPoint:(CGPoint)anchorPoint;

/**
 * Adjusts the view's frame so that the frame boundary ends up on physical
 * screen pixels (not necessarily points) to avoid blurry graphics.
 * @warning This method assumes properly aligned super view and no transform.
 * @warning Use with caution in code that could end up animated, consider using
 *          alignRectToPixels via an intermediate frame rect in these cases.
 */
- (void)alignToPixels;

/**
 * Snaps the supplied float to the nearest pixel position. This in practice
 * means runding to nearest integer value on non-retina and to nearest half
 * integer value on non-retina.
 */
+ (CGFloat)alignToPixels:(CGFloat)value;

/// @see alignToPixels
+ (CGRect)alignRectToPixels:(CGRect)rect;

/**
 * Converts rectangle from screen coordinates to coordinate system of this view.
 */
- (CGRect)convertScreenRect:(CGRect)rect;

/**
 * Converts point from screen coordinates to coordinate system of this view.
 */
- (CGPoint)convertScreenPoint:(CGPoint)point;

- (void)layoutNow;
- (void)removeAllSubviews;
// all fade methods without the duration argument use 200 ms
- (void)fadeIn;
- (void)fadeIn:(CGFloat)duration;
- (void)fadeInView:(UIView *)superview;
- (void)fadeInView:(UIView *)superview duration:(CGFloat)duration;
- (void)fadeOut;
- (void)fadeOut:(CGFloat)duration;
- (void)fadeOutAndRemove;
- (void)fadeOutAndRemove:(CGFloat)duration;
- (void)fadeTo:(CGFloat)alpha after:(CGFloat)delay;

/**
 * View from which snapshot will be taken.
 */
- (UIView *)captureView;

/**
 * Converts rectangle from self view to self.captureView rectangle.
 */
- (UIView *)convertToCaptureView:(CGRect *)rect;

/**
 * Captures view contents as snapshot view.
 */
- (UIView *)capture;

/**
 * Captures part of view contents as snapshot view.
 */
- (UIView *)captureWithRect:(CGRect)rect;

/**
 * Captures view contents as UIImage.
 */
- (UIImage *)captureImage;

/**
 * Captures part of view contents as UIImage.
 */
- (UIImage *)captureImageWithRect:(CGRect)rect;

/**
 * Captures part of view contents as UIImage with backgroundColor.
 */
- (UIImage *)captureImageWithRect:(CGRect)rect backgroundColor:(UIColor *)backgroundColor;

/**
 * Captures view's rectangle, with option to choose rendering method, scale and background color.
 *
 * Note: It's the best method to override in custom view to handle all captureImage calls.
 */
- (UIImage *)captureImageWithRect:(CGRect)rect
                            scale:(CGFloat)scale
                  backgroundColor:(UIColor *)backgroundColor
             forceRenderInContext:(BOOL)force;


/**
 * Calculates rectangle to use in order to capture contents of the whole view.
 */
- (CGRect)captureRect;

- (UIView *)subviewOfClassNamed:(char const *)className;

- (CGFloat)keyboardHeightFromUserInfo:(NSDictionary *)info;

/**
 * Returns list of all sub views (including current view).
 */
- (NSArray *)enumerateAllSubViews:(BOOL)reversedOrder;

- (BOOL)enumerateAllSubViews:(BOOL)reversedOrder
                   withBlock:(void (^)(UIView *view, BOOL *stop))block;

/**
 * Returns all gesture recognizers that matches classKind
 * (from all sub views including current view).
 */
- (NSArray *)allGestureRecognizersMatchesKind:(Class)classKind;

@end
