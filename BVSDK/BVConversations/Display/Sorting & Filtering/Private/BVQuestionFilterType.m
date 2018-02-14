//
//  BVQuestionFilterType.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionFilterType.h"

@interface BVQuestionFilterType ()
@property(nonnull, nonatomic, readwrite) NSString *value;
@end

@implementation BVQuestionFilterType

+ (nonnull NSString *)toFilterTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVQuestionFilterType filterTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)filterTypeWithRawValue:(NSInteger)rawValue {
  return [[BVQuestionFilterType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVQuestionFilterValueQuestionId:
      self.value = @"Id";
      break;
    case BVQuestionFilterValueQuestionAuthorId:
      self.value = @"AuthorId";
      break;
    case BVQuestionFilterValueQuestionCampaignId:
      self.value = @"CampaignId";
      break;
    case BVQuestionFilterValueQuestionCategoryAncestorId:
      self.value = @"CategoryAncestorId";
      break;
    case BVQuestionFilterValueQuestionCategoryId:
      self.value = @"CategoryId";
      break;
    case BVQuestionFilterValueQuestionContentLocale:
      self.value = @"ContentLocale";
      break;
    case BVQuestionFilterValueQuestionHasAnswers:
      self.value = @"HasAnswers";
      break;
    case BVQuestionFilterValueQuestionHasBestAnswer:
      self.value = @"HasBestAnswer";
      break;
    case BVQuestionFilterValueQuestionHasBrandAnswers:
      self.value = @"HasBrandAnswers";
      break;
    case BVQuestionFilterValueQuestionHasPhotos:
      self.value = @"HasPhotos";
      break;
    case BVQuestionFilterValueQuestionHasStaffAnswers:
      self.value = @"HasStaffAnswers";
      break;
    case BVQuestionFilterValueQuestionHasTags:
      self.value = @"HasTags";
      break;
    case BVQuestionFilterValueQuestionHasVideos:
      self.value = @"HasVideos";
      break;
    case BVQuestionFilterValueQuestionIsFeatured:
      self.value = @"IsFeatured";
      break;
    case BVQuestionFilterValueQuestionIsSubjectActive:
      self.value = @"IsSubjectActive";
      break;
    case BVQuestionFilterValueQuestionLastApprovedAnswerSubmissionTime:
      self.value = @"LastApprovedAnswerSubmissionTime";
      break;
    case BVQuestionFilterValueQuestionLastModeratedTime:
      self.value = @"LastModeratedTime";
      break;
    case BVQuestionFilterValueQuestionLastModificationTime:
      self.value = @"LastModificationTime";
      break;
    case BVQuestionFilterValueQuestionModeratorCode:
      self.value = @"ModeratorCode";
      break;
    case BVQuestionFilterValueQuestionProductId:
      self.value = @"ProductId";
      break;
    case BVQuestionFilterValueQuestionSubmissionId:
      self.value = @"SubmissionId";
      break;
    case BVQuestionFilterValueQuestionSubmissionTime:
      self.value = @"SubmissionTime";
      break;
    case BVQuestionFilterValueQuestionSummary:
      self.value = @"Summary";
      break;
    case BVQuestionFilterValueQuestionTotalAnswerCount:
      self.value = @"TotalAnswerCount";
      break;
    case BVQuestionFilterValueQuestionTotalFeedbackCount:
      self.value = @"TotalFeedbackCount";
      break;
    case BVQuestionFilterValueQuestionTotalNegativeFeedbackCount:
      self.value = @"TotalNegativeFeedbackCount";
      break;
    case BVQuestionFilterValueQuestionTotalPositiveFeedbackCount:
      self.value = @"TotalPositiveFeedbackCount";
      break;
    case BVQuestionFilterValueQuestionUserLocation:
      self.value = @"UserLocation";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toFilterTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithQuestionFilterValue:
    (BVQuestionFilterValue)questionFilterValue {
  return [BVQuestionFilterType filterTypeWithRawValue:questionFilterValue];
}

@end
