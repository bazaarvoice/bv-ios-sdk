//
//  BVQuestionsSortOption.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionsSortOption.h"

@interface BVQuestionsSortOption ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVQuestionsSortOption

+ (nonnull NSString *)toSortOptionParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVQuestionsSortOption sortOptionWithRawValue:rawValue].value;
}

+ (nonnull instancetype)sortOptionWithRawValue:(NSInteger)rawValue {
  return [[BVQuestionsSortOption alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVQuestionsSortOptionValueQuestionId:
      self.value = @"Id";
      break;
    case BVQuestionsSortOptionValueQuestionAuthorId:
      self.value = @"AuthorId";
      break;
    case BVQuestionsSortOptionValueQuestionCampaignId:
      self.value = @"CampaignId";
      break;
    case BVQuestionsSortOptionValueQuestionContentLocale:
      self.value = @"ContentLocale";
      break;
    case BVQuestionsSortOptionValueQuestionHasAnswers:
      self.value = @"HasAnswers";
      break;
    case BVQuestionsSortOptionValueQuestionHasBestAnswer:
      self.value = @"HasBestAnswer";
      break;
    case BVQuestionsSortOptionValueQuestionHasPhotos:
      self.value = @"HasPhotos";
      break;
    case BVQuestionsSortOptionValueQuestionHasStaffAnswers:
      self.value = @"HasStaffAnswers";
      break;
    case BVQuestionsSortOptionValueQuestionIsFeatured:
      self.value = @"IsFeatured";
      break;
    case BVQuestionsSortOptionValueQuestionIsSubjectActive:
      self.value = @"IsSubjectActive";
      break;
    case BVQuestionsSortOptionValueQuestionLastApprovedAnswerSubmissionTime:
      self.value = @"LastApprovedAnswerSubmissionTime";
      break;
    case BVQuestionsSortOptionValueQuestionLastModeratedTime:
      self.value = @"LastModeratedTime";
      break;
    case BVQuestionsSortOptionValueQuestionLastModificationTime:
      self.value = @"LastModificationTime";
      break;
    case BVQuestionsSortOptionValueQuestionModeratorCode:
      self.value = @"ModeratorCode";
      break;
    case BVQuestionsSortOptionValueQuestionProductId:
      self.value = @"ProductId";
      break;
    case BVQuestionsSortOptionValueQuestionSubmissionId:
      self.value = @"SubmissionId";
      break;
    case BVQuestionsSortOptionValueQuestionSubmissionTime:
      self.value = @"SubmissionTime";
      break;
    case BVQuestionsSortOptionValueQuestionSummary:
      self.value = @"Summary";
      break;
    case BVQuestionsSortOptionValueQuestionTotalAnswerCount:
      self.value = @"TotalAnswerCount";
      break;
    case BVQuestionsSortOptionValueQuestionTotalFeedbackCount:
      self.value = @"TotalFeedbackCount";
      break;
    case BVQuestionsSortOptionValueQuestionTotalNegativeFeedbackCount:
      self.value = @"TotalNegativeFeedbackCount";
      break;
    case BVQuestionsSortOptionValueQuestionTotalPositiveFeedbackCount:
      self.value = @"TotalPositiveFeedbackCount";
      break;
    case BVQuestionsSortOptionValueQuestionUserLocation:
      self.value = @"UserLocation";
      break;
    case BVQuestionsSortOptionValueQuestionHasVideos:
      self.value = @"HasVideos";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toSortOptionParameterString {
  return self.value;
}

- (nonnull instancetype)initWithQuestionsSortOptionValue:
    (BVQuestionsSortOptionValue)questionsSortOptionValue {
  return
      [BVQuestionsSortOption sortOptionWithRawValue:questionsSortOptionValue];
}

@end
