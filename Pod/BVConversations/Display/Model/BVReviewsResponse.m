//
//  ReviewsResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewsResponse.h"
#import "BVReview.h"
#import "BVConversationsInclude.h"
#import "BVNullHelper.h"

@implementation BVReviewsResponse

-(id)createResult:(NSDictionary *)raw includes:(BVConversationsInclude *)includes {
    return [[BVReview alloc] initWithApiResponse:raw includes:includes];
}

@end
