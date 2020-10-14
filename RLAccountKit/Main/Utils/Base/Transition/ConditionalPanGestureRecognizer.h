/**
 *  ConditionalPanGestureRecognizer is a subclass of UIPanGestureRecognizer that
 *  prevents the recognizer from receiving -touchesMoved:withEvent: until `shouldReceiveTouchesBlock`
 *  returns YES.
 *
 *  This means that you can use ConditionalPanGestureRecognizer in cases where you don't want
 *  to start receiving events from the recognizer until a certain condition is met.
 */
@interface ConditionalPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, copy) BOOL (^shouldReceiveTouchesBlock)(void);

@end
