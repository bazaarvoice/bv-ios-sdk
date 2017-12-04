//
//  BVSortOptionAnswers.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSortOptionAnswers.h"

@implementation BVSortOptionAnswersUtil

+ (nonnull NSString *)toString:(BVSortOptionAnswers)BVSortOptionAnswers {

  switch (BVSortOptionAnswers) {

  case BVSortOptionAnswersId:
    return @"Id";
  case BVSortOptionAnswersAuthorId:
    return @"AuthorId";
  case BVSortOptionAnswersCampaignId:
    return @"CampaignId";
  case BVSortOptionAnswersContentLocale:
    return @"ContentLocale";
  case BVSortOptionAnswersHasPhotos:
    return @"HasPhotos";
  case BVSortOptionAnswersIsBestAnswer:
    return @"IsBestAnswer";
  case BVSortOptionAnswersIsFeatured:
    return @"IsFeatured";
  case BVSortOptionAnswersLastModeratedTime:
    return @"LastModeratedTime";
  case BVSortOptionAnswersLastModificationTime:
    return @"LastModificationTime";
  case BVSortOptionAnswersProductId:
    return @"ProductId";
  case BVSortOptionAnswersQuestionId:
    return @"QuestionId";
  case BVSortOptionAnswersSubmissionId:
    return @"SubmissionId";
  case BVSortOptionAnswersSubmissionTime:
    return @"SubmissionTime";
  case BVSortOptionAnswersTotalFeedbackCount:
    return @"TotalFeedbackCount";
  case BVSortOptionAnswersTotalNegativeFeedbackCount:
    return @"TotalNegativeFeedbackCount";
  case BVSortOptionAnswersTotalPositiveFeedbackCount:
    return @"TotalPositiveFeedbackCount";
  case BVSortOptionAnswersUserLocation:
    return @"UserLocation";
  }
}

@end
