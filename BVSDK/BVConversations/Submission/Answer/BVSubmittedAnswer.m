//
//  BVSubmittedAnswer.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedAnswer.h"
#import "BVModelUtil.h"
#import "BVNullHelper.h"

@implementation BVSubmittedAnswer

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {

    if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.answerText, apiObject[@"AnswerText"])
    SET_IF_NOT_NULL(self.submissionId, apiObject[@"SubmissionId"])
    SET_IF_NOT_NULL(self.typicalHoursToPost, apiObject[@"TypicalHoursToPost"])
    SET_IF_NOT_NULL(self.answerId, apiObject[@"AnswerId"])

    self.submissionTime =
        [BVModelUtil convertTimestampToDatetime:apiObject[@"SubmissionTime"]];

    NSNumber *emailAlert = apiObject[@"SendEmailAlertWhenAnswered"];
    if (emailAlert) {
      self.sendEmailAlertWhenAnswered = [emailAlert boolValue];
    }
  }
  return self;
}

@end
