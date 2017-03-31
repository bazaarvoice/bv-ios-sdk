//
//  ReviewsRequest.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVCore.h"
#import "BVCommaUtil.h"
#import "BVReviewsRequest.h"
#import "BVFilter.h"
#import "BVSort.h"

@implementation BVReviewsRequest

- (nonnull instancetype)initWithProductId:(NSString * _Nonnull)productId limit:(int)limit offset:(int)offset {
    return self = [super initWithID:productId limit:limit offset:offset];
}

-(NSString*)productId {
    return self.ID;
}

-(id<BVResponse>)createResponse:(NSDictionary *)raw {
    return [[BVReviewsResponse alloc]initWithApiResponse:raw];
}

@end
