//
//  BVSubmittedQuestion.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedQuestion.h"
#import "BVModelUtil.h"
#import "BVNullHelper.h"

@implementation BVSubmittedQuestion

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {

    if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.questionSummary, apiObject[@"QuestionSummary"])
    SET_IF_NOT_NULL(self.questionDetails, apiObject[@"QuestionDetails"])
    SET_IF_NOT_NULL(self.questionId, apiObject[@"QuestionId"])
    SET_IF_NOT_NULL(self.submissionId, apiObject[@"SubmissionId"])

    SET_IF_NOT_NULL(self.typicalHoursToPost, apiObject[@"TypicalHoursToPost"])
    SET_IF_NOT_NULL(self.sendEmailAlertWhenAnswered,
                    apiObject[@"SendEmailAlertWhenAnswered"])
    SET_IF_NOT_NULL(self.sendEmailAlertWhenPublished,
                    apiObject[@"SendEmailAlertWhenPublished"])

    self.submissionTime =
        [BVModelUtil convertTimestampToDatetime:apiObject[@"SubmissionTime"]];
  }
  return self;
}

@end
