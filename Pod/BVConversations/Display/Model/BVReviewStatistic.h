//
//  BVReviewStatistic.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 A set of statistics about reviews. Used in `BVProductStatistics`. 
 */
@interface BVReviewStatistic : NSObject

@property NSNumber* _Nullable totalReviewCount;
@property NSNumber* _Nullable averageOverallRating;
@property NSNumber* _Nullable overallRatingRange;

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse;

@end
