//
//  SubmittedAnswer.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedAnswer.h"
#import "BVModelUtil.h"
#import "BVNullHelper.h"

@implementation BVSubmittedAnswer

-(nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
    self = [super init];
    if(self){
        
        if(apiResponse == nil || ![apiResponse isKindOfClass:[NSDictionary class]]){
            return nil;
        }
        
        NSDictionary* apiObject = apiResponse;
        
        SET_IF_NOT_NULL(self.answerText, apiObject[@"AnswerText"])
        SET_IF_NOT_NULL(self.submissionId, apiObject[@"SubmissionId"])
        SET_IF_NOT_NULL(self.typicalHoursToPost, apiObject[@"TypicalHoursToPost"])
        SET_IF_NOT_NULL(self.answerId, apiObject[@"AnswerId"])
        
        self.submissionTime = [BVModelUtil convertTimestampToDatetime:apiObject[@"SubmissionTime"]];
        
        NSNumber* emailAlert = apiObject[@"SendEmailAlertWhenAnswered"];
        if(emailAlert != nil) {
            self.sendEmailAlertWhenAnswered = [emailAlert boolValue];
        }
    }
    return self;
}

@end
