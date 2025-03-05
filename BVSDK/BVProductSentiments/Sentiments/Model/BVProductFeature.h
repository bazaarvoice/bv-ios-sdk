//
//  BVProductFeature.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVAverageRatingReviews.h"
#import "BVQuotes.h"
#import "BVProductSentimentsResult.h"

@class BVAverageRatingReviews;
@class BVQuotes;

@interface BVProductFeature : BVProductSentimentsResult

@property(nullable) NSString *feature;
@property(nullable) NSString *featureID;
@property(nullable) NSNumber *percentPositive;
@property(nullable) NSString *nativeFeature;
@property(nullable) BVAverageRatingReviews *reviewsMentioned;
@property(nullable) BVAverageRatingReviews *averageRatingReviews;
@property(nullable) BVQuotes *embedded;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end

