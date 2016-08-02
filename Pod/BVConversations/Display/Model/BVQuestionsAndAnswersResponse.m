//
//  QuestionsAndAnswersResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionsAndAnswersResponse.h"
#import "BVConversationsInclude.h"
#import "BVQuestion.h"
#import "BVNullHelper.h"

@implementation BVQuestionsAndAnswersResponse

-(id)initWithApiResponse:(NSDictionary *)apiResponse {
    self = [super init];
    if(self){
                
        SET_IF_NOT_NULL(self.limit, apiResponse[@"Limit"])
        SET_IF_NOT_NULL(self.totalResults, apiResponse[@"TotalResults"])
        SET_IF_NOT_NULL(self.locale, apiResponse[@"Locale"])
        SET_IF_NOT_NULL(self.offset, apiResponse[@"Offset"])
        
        NSDictionary* rawIncludes = apiResponse[@"Includes"];
        BVConversationsInclude* includes = [[BVConversationsInclude alloc] initWithApiResponse:rawIncludes];
        
        NSMutableArray<BVQuestion*>* tempResults = [NSMutableArray array];
        NSArray<NSDictionary*>* rawResults = apiResponse[@"Results"];
        for(NSDictionary* rawResult in rawResults){
            BVQuestion* question = [[BVQuestion alloc] initWithApiResponse:rawResult includes:includes];
            [tempResults addObject:question];
        }
        self.results = tempResults;

    }
    return self;
}

@end
