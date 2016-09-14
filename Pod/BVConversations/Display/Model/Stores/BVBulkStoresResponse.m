//
//  BVBulkStoresResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkStoresResponse.h"
#import "BVConversationsInclude.h"
#import "BVNullHelper.h"
#import "BVStore.h"

@implementation BVBulkStoresResponse

-(id)initWithApiResponse:(NSDictionary *)apiResponse {
    
    self = [super init];
    if(self){
        
        SET_IF_NOT_NULL(self.limit, apiResponse[@"Limit"])
        SET_IF_NOT_NULL(self.totalResults, apiResponse[@"TotalResults"])
        SET_IF_NOT_NULL(self.locale, apiResponse[@"Locale"])
        SET_IF_NOT_NULL(self.offset, apiResponse[@"Offset"])
        
        NSDictionary* rawIncludes = apiResponse[@"Includes"];
        BVConversationsInclude* includes = [[BVConversationsInclude alloc] initWithApiResponse:rawIncludes];
        
        NSMutableArray<BVStore*>* tempResults = [NSMutableArray array];
        for(NSDictionary* rawResult in apiResponse[@"Results"]) {
            [tempResults addObject:[[BVStore alloc] initWithApiResponse:rawResult includes:includes]];
        }
        self.results = tempResults;
        
    }
    return self;
    
}

@end
