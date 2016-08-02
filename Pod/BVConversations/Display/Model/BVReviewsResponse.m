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

-(id)initWithApiResponse:(NSDictionary *)apiResponse {
    
    self = [super init];
    if(self){
        
        SET_IF_NOT_NULL(self.limit, apiResponse[@"Limit"])
        SET_IF_NOT_NULL(self.totalResults, apiResponse[@"TotalResults"])
        SET_IF_NOT_NULL(self.locale, apiResponse[@"Locale"])
        SET_IF_NOT_NULL(self.offset, apiResponse[@"Offset"])
        
        NSDictionary* rawIncludes = apiResponse[@"Includes"];
        BVConversationsInclude* includes = [[BVConversationsInclude alloc] initWithApiResponse:rawIncludes];
        
        NSMutableArray<BVReview*>* tempResults = [NSMutableArray array];
        for(NSDictionary* rawResult in apiResponse[@"Results"]) {
            [tempResults addObject:[[BVReview alloc] initWithApiResponse:rawResult includes:includes]];
        }
        self.results = tempResults;
        
    }
    return self;
    
}

@end
