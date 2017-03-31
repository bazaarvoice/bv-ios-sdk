//
//  BVBulkRatingsResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingsResponse.h"
#import "BVNullHelper.h"

@implementation BVBulkRatingsResponse

-(id)createResult:(NSDictionary *)raw includes:(BVConversationsInclude *)includes {
    return [[BVProductStatistics alloc] initWithApiResponse: raw];
}

@end
