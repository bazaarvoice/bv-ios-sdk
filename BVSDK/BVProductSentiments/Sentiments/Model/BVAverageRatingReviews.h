//
//  BVAverageRatingReviews.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#ifndef BVAverageRatingReviews_h
#define BVAverageRatingReviews_h

#import "BVProductSentimentsResult.h"

@interface BVAverageRatingReviews : BVProductSentimentsResult

@property(nullable) NSNumber *positive;
@property(nullable) NSNumber *negative;
@property(nullable) NSNumber *incentivized;
@property(nullable) NSNumber *total;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end

#endif /* BVAverageRatingReviews_h */
