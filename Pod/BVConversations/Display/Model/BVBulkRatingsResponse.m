//
//  BVBulkRatingsResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingsResponse.h"
#import "BVNullHelper.h"

@implementation BVBulkRatingsResponse

-(id)initWithApiResponse:(NSDictionary *)apiResponse {
    self = [super init];
    if(self){
        SET_IF_NOT_NULL(self.limit, apiResponse[@"Limit"])
        SET_IF_NOT_NULL(self.totalResults, apiResponse[@"TotalResults"])
        SET_IF_NOT_NULL(self.locale, apiResponse[@"Locale"])
        SET_IF_NOT_NULL(self.offset, apiResponse[@"Offset"])
        
        NSMutableArray* tempValues = [NSMutableArray array];
        for(NSDictionary* rawResult in apiResponse[@"Results"]) {
            [tempValues addObject:[[BVProductStatistics alloc] initWithApiResponse: rawResult]];
        }
        self.results = tempValues;
    }
    return self;
}

@end
