//
//  BVAnswersSortOption.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswersSortOption.h"

@interface BVAnswersSortOption ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVAnswersSortOption

+ (nonnull NSString *)toSortOptionParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVAnswersSortOption sortOptionWithRawValue:rawValue].value;
}

+ (nonnull instancetype)sortOptionWithRawValue:(NSInteger)rawValue {
  return [[BVAnswersSortOption alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVAnswersSortOptionValueAnswerId:
      self.value = @"Id";
      break;
    case BVAnswersSortOptionValueAnswerAuthorId:
      self.value = @"AuthorId";
      break;
    case BVAnswersSortOptionValueAnswerCampaignId:
      self.value = @"CampaignId";
      break;
    case BVAnswersSortOptionValueAnswerContentLocale:
      self.value = @"ContentLocale";
      break;
    case BVAnswersSortOptionValueAnswerHasPhotos:
      self.value = @"HasPhotos";
      break;
    case BVAnswersSortOptionValueAnswerIsBestAnswer:
      self.value = @"IsBestAnswer";
      break;
    case BVAnswersSortOptionValueAnswerIsFeatured:
      self.value = @"IsFeatured";
      break;
    case BVAnswersSortOptionValueAnswerLastModeratedTime:
      self.value = @"LastModeratedTime";
      break;
    case BVAnswersSortOptionValueAnswerLastModificationTime:
      self.value = @"LastModificationTime";
      break;
    case BVAnswersSortOptionValueAnswerProductId:
      self.value = @"ProductId";
      break;
    case BVAnswersSortOptionValueAnswerQuestionId:
      self.value = @"QuestionId";
      break;
    case BVAnswersSortOptionValueAnswerSubmissionId:
      self.value = @"SubmissionId";
      break;
    case BVAnswersSortOptionValueAnswerSubmissionTime:
      self.value = @"SubmissionTime";
      break;
    case BVAnswersSortOptionValueAnswerTotalFeedbackCount:
      self.value = @"TotalFeedbackCount";
      break;
    case BVAnswersSortOptionValueAnswerTotalNegativeFeedbackCount:
      self.value = @"TotalNegativeFeedbackCount";
      break;
    case BVAnswersSortOptionValueAnswerTotalPositiveFeedbackCount:
      self.value = @"TotalPositiveFeedbackCount";
      break;
    case BVAnswersSortOptionValueAnswerUserLocation:
      self.value = @"UserLocation";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toSortOptionParameterString {
  return self.value;
}

- (nonnull instancetype)initWithAnswersSortOptionValue:
    (BVAnswersSortOptionValue)answersSortOptionValue {
  return [BVAnswersSortOption sortOptionWithRawValue:answersSortOptionValue];
}

@end
