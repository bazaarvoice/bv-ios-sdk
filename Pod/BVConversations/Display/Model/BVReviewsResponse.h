//
//  ReviewsResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVResponse.h"
#import "BVReview.h"

/*
 A response to a `BVReviewsResponse`. Contains one or multiple (up to 20) `BVReview` objects in the `results` array.
 Contains other response information like the current index of pagination (`offset` property), and how many total results
 are available (`totalResults` property).
 */
@interface BVReviewsResponse : NSObject<BVResponse>

@property NSNumber* _Nullable offset;
@property NSString* _Nullable locale;
@property NSArray<BVReview*>* _Nonnull results;
@property NSNumber* _Nullable totalResults;
@property NSNumber* _Nullable limit;

@end
