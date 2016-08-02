//
//  ProductsResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductsResponse.h"
#import "BVProduct.h"
#import "BVConversationsInclude.h"
#import "BVNullHelper.h"

@implementation BVProductsResponse

-(id)initWithApiResponse:(NSDictionary *)apiResponse {
    
    self = [super init];
    if(self){
        
        SET_IF_NOT_NULL(self.limit, apiResponse[@"Limit"])
        SET_IF_NOT_NULL(self.totalResults, apiResponse[@"TotalResults"])
        SET_IF_NOT_NULL(self.locale, apiResponse[@"Locale"])
        SET_IF_NOT_NULL(self.offset, apiResponse[@"Offset"])
        
        NSDictionary* rawIncludes = apiResponse[@"Includes"];
        BVConversationsInclude* includes = [[BVConversationsInclude alloc] initWithApiResponse:rawIncludes];
        
        NSArray<NSDictionary*>* rawResults = apiResponse[@"Results"];
        if (rawResults != nil && [rawResults count] > 0) {
            self.result = [[BVProduct alloc] initWithApiResponse:rawResults.firstObject includes:includes];
        }
        
    }
    return self;
    
}

@end
