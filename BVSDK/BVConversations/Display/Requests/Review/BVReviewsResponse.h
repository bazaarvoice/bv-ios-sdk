//
//  ReviewsResponse.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDisplayResponse.h"
#import "BVReview.h"

/*
 A response to a `BVReviewsResponse`. Contains one or multiple (up to 20)
 `BVReview` objects in the `results` array.
 Contains other response information like the current index of pagination
 (`offset` property), and how many total results
 are available (`totalResults` property).
 */
@interface BVReviewsResponse : BVDisplayResultsResponse <BVReview *>

@end
