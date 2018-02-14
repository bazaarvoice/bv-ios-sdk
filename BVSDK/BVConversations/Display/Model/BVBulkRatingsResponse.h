//
//  BVBulkRatingsResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBaseConversationsResponse.h"
#import "BVProductStatistics.h"
#import "BVResponse.h"
#import <Foundation/Foundation.h>
/*
 A response to a `BVBulkRatingsRequest`. Contains one or multiple (up to 50)
 `BVProductStatistics` in the `results` array.
 Contains other response information like the current index of pagination
 (`offset` property), and how many total results
 are available (`totalResults` property).
 */
@interface BVBulkRatingsResponse
    : BVBaseConversationsResultsResponse <BVProductStatistics *>

@end
