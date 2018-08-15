//
//  BVProductRecommendationView.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVProductRecommendationView.h"
#import "BVRecommendedProduct.h"
#import "BVRecsAnalyticsHelper.h"

@implementation BVRecommendationCollectionViewCell

- (void)setBvRecommendedProduct:(BVRecommendedProduct *)bvRecommendedProduct {

  _bvRecommendedProduct = bvRecommendedProduct;
}

- (void)recommendationViewClicked {

  [self.bvRecommendedProduct recordTap];
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];

  [self checkButtonsInSubviews:self.subviews];
  [self checkGestureRecognizers];
}

- (void)checkButtonsInSubviews:(NSArray *)subviews {

  for (UIView *subview in subviews) {
    if ([subview isKindOfClass:[UIButton class]]) {

      UIButton *button = (UIButton *)subview;
      [button addTarget:self
                    action:@selector(recommendationViewClicked)
          forControlEvents:UIControlEventTouchUpInside];
    }
    [self checkButtonsInSubviews:subview.subviews];
  }
}

- (void)checkGestureRecognizers {

  for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
    if ([recognizer isKindOfClass:[UIGestureRecognizer class]]) {
      UIGestureRecognizer *tapRecognizer = (UIGestureRecognizer *)recognizer;

      if ([tapRecognizer cancelsTouchesInView]) {

        [NSException
             raise:@"InvalidViewConfiguration"
            format:@"UIGestureRecognizer must have `cancelsTouchesInView` set "
                   @"to false for the BVSDK to properly function."];
      }
    }
  }
}

@end

@implementation BVRecommendationTableViewCell

- (void)setBvRecommendedProduct:(BVRecommendedProduct *)bvRecommendedProduct {

  _bvRecommendedProduct = bvRecommendedProduct;
}

- (void)recommendationViewClicked {

  [self.bvRecommendedProduct recordTap];
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];

  [self checkButtonsInSubviews:self.subviews];
  [self checkGestureRecognizers];
}

- (void)checkButtonsInSubviews:(NSArray *)subviews {

  for (UIView *subview in subviews) {
    if ([subview isKindOfClass:[UIButton class]]) {

      UIButton *button = (UIButton *)subview;
      [button addTarget:self
                    action:@selector(recommendationViewClicked)
          forControlEvents:UIControlEventTouchUpInside];
    }
    [self checkButtonsInSubviews:subview.subviews];
  }
}

- (void)checkGestureRecognizers {

  for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
    if ([recognizer isKindOfClass:[UIGestureRecognizer class]]) {
      UIGestureRecognizer *tapRecognizer = (UIGestureRecognizer *)recognizer;

      if ([tapRecognizer cancelsTouchesInView]) {

        [NSException
             raise:@"InvalidViewConfiguration"
            format:@"UIGestureRecognizer must have `cancelsTouchesInView` set "
                   @"to false for the BVSDK to properly function."];
      }
    }
  }
}

@end

@implementation BVProductRecommendationView

- (void)setBvRecommendedProduct:(BVRecommendedProduct *)bvRecommendedProduct {

  _bvRecommendedProduct = bvRecommendedProduct;
}

- (void)recommendationViewClicked {

  [_bvRecommendedProduct recordTap];
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];

  [self checkButtonsInSubviews:self.subviews];
  [self checkGestureRecognizers];
}

- (void)checkButtonsInSubviews:(NSArray *)subviews {

  for (UIView *subview in subviews) {
    if ([subview isKindOfClass:[UIButton class]]) {

      UIButton *button = (UIButton *)subview;
      [button addTarget:self
                    action:@selector(recommendationViewClicked)
          forControlEvents:UIControlEventTouchUpInside];
    }
    [self checkButtonsInSubviews:subview.subviews];
  }
}

- (void)checkGestureRecognizers {

  for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
    if ([recognizer isKindOfClass:[UIGestureRecognizer class]]) {
      UIGestureRecognizer *tapRecognizer = (UIGestureRecognizer *)recognizer;

      if ([tapRecognizer cancelsTouchesInView]) {

        [NSException
             raise:@"InvalidViewConfiguration"
            format:@"UIGestureRecognizer must have `cancelsTouchesInView` set "
                   @"to false for the BVSDK to properly function."];
      }
    }
  }
}

@end
