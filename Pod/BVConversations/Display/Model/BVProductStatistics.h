//
//  ProductStatistics.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVReviewStatistic.h"

/*
 Statistics about a product - included in `BVBulkRatingsResponse`.
 */
@interface BVProductStatistics : NSObject

@property NSString* _Nullable productId;
@property BVReviewStatistic* _Nullable reviewStatistics;
@property BVReviewStatistic* _Nullable nativeReviewStatistics;

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse;

@end
