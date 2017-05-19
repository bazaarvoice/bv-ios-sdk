//
//  BVBaseConversationsResponse.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBaseConversationsResponse.h"
#import "BVNullHelper.h"

@implementation BVBaseConversationsResponse

-(id)initWithApiResponse:(NSDictionary *)apiResponse {
    self = [super init];
    if(self){
        
        SET_IF_NOT_NULL(self.limit, apiResponse[@"Limit"])
        SET_IF_NOT_NULL(self.totalResults, apiResponse[@"TotalResults"])
        SET_IF_NOT_NULL(self.locale, apiResponse[@"Locale"])
        SET_IF_NOT_NULL(self.offset, apiResponse[@"Offset"])
    }
    
    return self;
}

-(BVConversationsInclude*)getIncludes:(NSDictionary*)apiResponse {
    NSDictionary* rawIncludes = apiResponse[@"Includes"];
    BVConversationsInclude* includes = [[BVConversationsInclude alloc] initWithApiResponse:rawIncludes];
    return includes;
}


-(id)createResult:(NSDictionary *)raw includes:(BVConversationsInclude *)includes {
    NSAssert(NO, @"createResult method should be overridden");
    return nil;
}

@end

@implementation BVBaseConversationsResultResponse

-(id)initWithApiResponse:(NSDictionary *)apiResponse {
    self = [super initWithApiResponse:apiResponse];
    if(self){
        NSArray<NSDictionary*>* results = apiResponse[@"Results"];
        if (results.count) {
            _result = [self createResult:results.firstObject includes:[self getIncludes:apiResponse]];
        }
    }
    
    return self;
}

@end

@implementation BVBaseConversationsResultsResponse

-(id)initWithApiResponse:(NSDictionary *)apiResponse {
    self = [super initWithApiResponse:apiResponse];
    if(self){
        
        NSArray<NSDictionary*>* apiResults = apiResponse[@"Results"];
        BVConversationsInclude *includes = [self getIncludes:apiResponse];
        NSMutableArray *results = [NSMutableArray new];
        for (NSDictionary *result in apiResults) {
            [results addObject:[self createResult:result includes:includes]];
        }
        
        _results = [NSArray arrayWithArray:results];
    }
    
    return self;
}

@end
