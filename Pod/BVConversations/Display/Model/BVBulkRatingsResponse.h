//
//  BVBulkRatingsResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVResponse.h"
#import "BVProductStatistics.h"

/*
 A response to a `BVBulkRatingsRequest`. Contains one or multiple (up to 50) `BVProductStatistics` in the `results` array.
 Contains other response information like the current index of pagination (`offset` property), and how many total results
 are available (`totalResults` property).
 */
@interface BVBulkRatingsResponse : NSObject<BVResponse>

@property NSNumber* _Nullable offset;
@property NSString* _Nullable locale;
@property NSNumber* _Nullable totalResults;
@property NSNumber* _Nullable limit;
@property NSArray<BVProductStatistics*>* _Nonnull results;

@end
