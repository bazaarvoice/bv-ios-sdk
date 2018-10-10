//
//  ReviewsResponse.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewsResponse.h"
#import "BVConversationsInclude.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVNullHelper.h"
#import "BVReview.h"

@implementation BVReviewsResponse

- (id)createResult:(NSDictionary *)raw
          includes:(BVConversationsInclude *)includes {
  return [[BVReview alloc] initWithApiResponse:raw includes:includes];
}

@end
