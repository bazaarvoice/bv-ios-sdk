//
//  RatingDistribution.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The number of ratings for each star count. For example, 12 one-star reviews, 53 five-star reviews.
 */
@interface BVRatingDistribution : NSObject

@property NSNumber* _Nonnull oneStarCount;
@property NSNumber* _Nonnull twoStarCount;
@property NSNumber* _Nonnull threeStarCount;
@property NSNumber* _Nonnull fourStarCount;
@property NSNumber* _Nonnull fiveStarCount;

-(id _Nullable)initWithApiResponse:(id _Nullable)apiRepsonse;

@end
