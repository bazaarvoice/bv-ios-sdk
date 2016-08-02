//
//  QuestionSubmissionResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionSubmissionResponse.h"

@implementation BVQuestionSubmissionResponse

-(nonnull instancetype)initWithApiResponse:(NSDictionary*)apiResponse {
    
    self = [super initWithApiResponse:apiResponse];
    
    if(self){
        self.question = [[BVSubmittedQuestion alloc] initWithApiResponse:apiResponse[@"Question"]];
    }
    
    return self;
}

@end