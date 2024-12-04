//
//  BVProductFeature.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVAverageRatingReviews.h"

@interface BVProductFeature : NSObject

@property(nullable) NSString *feature;
@property(nullable) NSString *featureID;
@property(nullable) NSNumber *percentPositive;
@property(nullable) NSString *nativeFeature;
@property(nullable) NSString *reviewsMentioned;
@property(nullable) BVAverageRatingReviews *averageRatingReviews;
@property(nullable) BVAverageRatingReviews *embedded;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end

