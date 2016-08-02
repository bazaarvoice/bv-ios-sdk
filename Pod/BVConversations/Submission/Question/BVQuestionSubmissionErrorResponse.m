//
//  QuestionSubmissionErrorResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionSubmissionErrorResponse.h"

@implementation BVQuestionSubmissionErrorResponse

-(instancetype)initWithApiResponse:(nullable id)apiResponse {
    
    self = [super initWithApiResponse:apiResponse];
    
    if(self){
        NSDictionary* apiObject = apiResponse; // [super initWithApiResponse:] checks that this is nonnull and a dictionary
        self.question = [[BVSubmittedQuestion alloc] initWithApiResponse:apiObject[@"Question"]];
    }
    
    return self;
}

@end
