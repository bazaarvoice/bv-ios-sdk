//
//  BVCommentSubmissionErrorResponse.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentSubmissionErrorResponse.h"

@implementation BVCommentSubmissionErrorResponse


-(instancetype)initWithApiResponse:(nullable id)apiResponse {
    
    self = [super initWithApiResponse:apiResponse];
    
    if(self){
        NSDictionary* apiObject = apiResponse; // [super initWithApiResponse:] checks that this is nonnull and a dictionary
        self.comment = [[BVSubmittedComment alloc] initWithApiResponse:apiObject[@"Comment"]];
    }
    
    return self;
}

@end
