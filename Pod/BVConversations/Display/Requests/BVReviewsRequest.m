//
//  ReviewsRequest.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewsRequest.h"
#import "BVCommaUtil.h"
#import "BVCommon.h"
#import "BVFilter.h"
#import "BVSort.h"

@implementation BVReviewsRequest

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                                    limit:(int)limit
                                   offset:(int)offset {
  return self = [super initWithID:productId limit:limit offset:offset];
}

- (NSString *)productId {
  return self.ID;
}

- (id<BVResponse>)createResponse:(NSDictionary *)raw {
  return [[BVReviewsResponse alloc] initWithApiResponse:raw];
}

@end
