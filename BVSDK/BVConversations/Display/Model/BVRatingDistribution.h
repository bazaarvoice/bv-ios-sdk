//
//  RatingDistribution.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The number of ratings for each star count. For example, 12 one-star reviews, 53
 five-star reviews.
 */
@interface BVRatingDistribution : NSObject

@property(nonnull) NSNumber *oneStarCount;
@property(nonnull) NSNumber *twoStarCount;
@property(nonnull) NSNumber *threeStarCount;
@property(nonnull) NSNumber *fourStarCount;
@property(nonnull) NSNumber *fiveStarCount;
@property(nonnull) NSArray *rawDistribution;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
