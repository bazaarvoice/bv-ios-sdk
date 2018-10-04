//
//  BVSubmittedReview.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedReview.h"
#import "BVModelUtil.h"
#import "BVNullHelper.h"

@implementation BVSubmittedReview

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {

    if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    SET_IF_NOT_NULL(self.title, apiObject[@"Title"])
    SET_IF_NOT_NULL(self.reviewText, apiObject[@"ReviewText"])
    SET_IF_NOT_NULL(self.rating, apiObject[@"Rating"])
    SET_IF_NOT_NULL(self.reviewId, apiObject[@"Id"])

    SET_IF_NOT_NULL(self.submissionId, apiObject[@"SubmissionId"])
    SET_IF_NOT_NULL(self.isRecommended, apiObject[@"IsRecommended"])
    SET_IF_NOT_NULL(self.typicalHoursToPost, apiObject[@"TypicalHoursToPost"])

    self.submissionTime =
        [BVModelUtil convertTimestampToDatetime:apiObject[@"SubmissionTime"]];

    self.sendEmailAlertWhenCommented =
        apiObject[@"SendEmailAlertWhenCommented"];
    self.sendEmailAlertWhenPublished =
        apiObject[@"SendEmailAlertWhenPublished"];
  }
  return self;
}

@end
