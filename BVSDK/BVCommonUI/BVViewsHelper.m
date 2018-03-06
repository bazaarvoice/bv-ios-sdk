//
//  BVViewsHelper.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVViewsHelper.h"

@implementation BVViewsHelper

+ (void)checkButtonsInSubviews:(NSArray *)subviews
                    withTarget:(id)target
                  withSelector:(SEL)targetSelector {
  for (UIView *subview in subviews) {
    if ([subview isKindOfClass:[UIButton class]]) {
      UIButton *button = (UIButton *)subview;
      [button addTarget:self
                    action:@selector(selector)
          forControlEvents:UIControlEventTouchUpInside];
    }
    [self checkButtonsInSubviews:subview.subviews
                      withTarget:target
                    withSelector:targetSelector];
  }
}

+ (void)checkGestureRecognizers:(NSArray *)gestureRecognizers {
  for (UIGestureRecognizer *recognizer in gestureRecognizers) {
    if ([recognizer isKindOfClass:[UIGestureRecognizer class]]) {
      UIGestureRecognizer *tapRecognizer = (UIGestureRecognizer *)recognizer;

      if ([tapRecognizer cancelsTouchesInView]) {
        NSAssert(false, @"UIGestureRecognizer must have "
                        @"`cancelsTouchesInView` set to false for the "
                        @"BVSDK to properly function.");
      }
    }
  }
}

+ (NSString *)formatIndex:(NSIndexPath *)indexPath {
  return
      [NSString stringWithFormat:@"%lu:%lu", (unsigned long)indexPath.section,
                                 (unsigned long)indexPath.row];
}

@end
