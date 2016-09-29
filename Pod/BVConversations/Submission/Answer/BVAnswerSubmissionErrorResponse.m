//
//  BVAnswerSubmissionErrorResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswerSubmissionErrorResponse.h"

@implementation BVAnswerSubmissionErrorResponse

-(instancetype)initWithApiResponse:(nullable id)apiResponse {
    
    self = [super initWithApiResponse:apiResponse];
    
    if(self){
        NSDictionary* apiObject = apiResponse; // [super initWithApiResponse:] checks that this is nonnull and a dictionary
        self.answer = [[BVSubmittedAnswer alloc] initWithApiResponse:apiObject[@"Answer"]];
    }
    
    return self;
}

@end
