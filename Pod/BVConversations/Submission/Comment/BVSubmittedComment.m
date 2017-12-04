//
//  BVSubmittedComment.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedComment.h"
#import "BVModelUtil.h"
#import "BVNullHelper.h"

@implementation BVSubmittedComment

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
  self = [super init];
  if (self) {

    if (apiResponse == nil ||
        ![apiResponse isKindOfClass:[NSDictionary class]]) {
      return nil;
    }

    NSDictionary *apiObject = apiResponse;

    SET_IF_NOT_NULL(_commentText, apiObject[@"CommentText"])
    SET_IF_NOT_NULL(_title, apiObject[@"Title"])
    SET_IF_NOT_NULL(_submissionId, apiObject[@"SubmissionId"])
    SET_IF_NOT_NULL(_typicalHoursToPost, apiObject[@"TypicalHoursToPost"])
    SET_IF_NOT_NULL(_commentId, apiObject[@"CommentId"])

    _submissionTime =
        [BVModelUtil convertTimestampToDatetime:apiObject[@"SubmissionTime"]];

    NSNumber *emailAlert = apiObject[@"SendEmailAlertWhenAnswered"];
    if (emailAlert != nil) {
      _sendEmailAlertWhenAnswered = [emailAlert boolValue];
    }
  }
  return self;
}

@end
