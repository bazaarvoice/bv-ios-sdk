//
//  BVStoreReviewsResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStoreReviewsResponse.h"
#import "BVReview.h"
#import "BVConversationsInclude.h"
#import "BVNullHelper.h"
#import "BVStore.h"

@implementation BVStoreReviewsResponse

-(id)initWithApiResponse:(NSDictionary *)apiResponse {
    
    self = [super init];
    if(self){
        
        SET_IF_NOT_NULL(self.limit, apiResponse[@"Limit"])
        SET_IF_NOT_NULL(self.totalResults, apiResponse[@"TotalResults"])
        SET_IF_NOT_NULL(self.locale, apiResponse[@"Locale"])
        SET_IF_NOT_NULL(self.offset, apiResponse[@"Offset"])
        
        // BVStore object retrieved from "Includes"
        NSDictionary* rawIncludes = apiResponse[@"Includes"];
        BVConversationsInclude* includes = [[BVConversationsInclude alloc] initWithApiResponse:rawIncludes];
        
        self.store = [self extractStoreFromIncludes:rawIncludes];
        
        NSMutableArray<BVReview*>* tempResults = [NSMutableArray array];
        for(NSDictionary* rawResult in apiResponse[@"Results"]) {
            [tempResults addObject:[[BVReview alloc] initWithApiResponse:rawResult includes:includes]];
        }
        
        self.results = tempResults;
        
    }
    return self;
    
}

- (BVStore *)extractStoreFromIncludes:(NSDictionary *)includesDict{
    
    NSDictionary* productsDict = includesDict[@"Products"];
    for(NSString* key in productsDict){
        // We limit the initial request to only one store, so we just pick out the first store.
        NSDictionary *storeDict = [productsDict objectForKey:key];

        return [[BVStore alloc] initWithApiResponse:storeDict];
    }
    
    // If there are no reviews in the response, the Products dictionary holding the stores will be empty.
    return nil;
    
}

@end
