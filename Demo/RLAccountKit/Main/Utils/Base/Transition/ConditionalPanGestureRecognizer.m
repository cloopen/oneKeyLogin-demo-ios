#import "ConditionalPanGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation ConditionalPanGestureRecognizer

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.shouldReceiveTouchesBlock && self.shouldReceiveTouchesBlock()) {
        [super touchesMoved:touches withEvent:event];
    }
}

@end
