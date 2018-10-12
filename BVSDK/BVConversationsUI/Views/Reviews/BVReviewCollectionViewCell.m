//
//  BVReviewCollectionViewCell.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewCollectionViewCell.h"
#import "BVViewsHelper.h"

@implementation BVReviewCollectionViewCell

- (void)setReview:(BVReview *)review {

  _review = review;
}

- (void)didMoveToSuperview {

  [super didMoveToSuperview];
  [BVViewsHelper checkGestureRecognizers:self.gestureRecognizers];
}

@end
