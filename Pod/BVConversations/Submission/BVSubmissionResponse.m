//
//  SubmissionResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionResponse.h"
#import "BVNullHelper.h"

@implementation BVSubmissionResponse

-(nonnull instancetype)initWithApiResponse:(NSDictionary*)apiResponse {
    self = [super init];
    if(self){
        
        SET_IF_NOT_NULL(self.locale, apiResponse[@"Locale"])
        SET_IF_NOT_NULL(self.submissionId, apiResponse[@"SubmissionId"])
        SET_IF_NOT_NULL(self.typicalHoursToPost, apiResponse[@"TypicalHoursToPost"])
        SET_IF_NOT_NULL(self.authorSubmissionToken, apiResponse[@"AuthorSubmissionToken"])
        
    }
    return self;
}

@end