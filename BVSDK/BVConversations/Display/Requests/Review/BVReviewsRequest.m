//
//  ReviewsRequest.m
//  BVSDK
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
                                    limit:(NSUInteger)limit
                                   offset:(NSUInteger)offset {
    return self = [super initWithID:productId limit:limit offset:offset primaryFilter: BVReviewFilterValueProductId];
}

- (nonnull instancetype)initWithId:(nonnull NSString *)Id
                         andFilter:(BVReviewFilterValue)filter
                             limit:(NSUInteger)limit
                            offset:(NSUInteger)offset {
    return self = [super initWithID:Id limit:limit offset:offset primaryFilter: filter];
}

- (NSString *)productId {
  return self.ID;
}

- (BVDisplayResponse *)createResponse:(NSDictionary *)raw {
  return [[BVReviewsResponse alloc] initWithApiResponse:raw];
}

@end
