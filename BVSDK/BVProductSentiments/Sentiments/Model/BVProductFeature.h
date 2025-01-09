//
//  BVProductFeature.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVAverageRatingReviews.h"
#import "BVQuote.h"
#import "BVProductSentimentsResult.h"

@class BVAverageRatingReviews;
@class BVQuote;

@interface BVProductFeature : BVProductSentimentsResult

@property(nullable) NSString *feature;
@property(nullable) NSString *featureID;
@property(nullable) NSNumber *percentPositive;
@property(nullable) NSString *nativeFeature;
@property(nullable) BVAverageRatingReviews *reviewsMentioned;
@property(nullable) BVAverageRatingReviews *averageRatingReviews;
@property(nullable) BVQuote *embedded;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end

