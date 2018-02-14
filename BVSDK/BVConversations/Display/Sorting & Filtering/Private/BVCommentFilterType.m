//
//  BVCommentFilterValue.m
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentFilterType.h"

@interface BVCommentFilterType ()
@property(nonnull, nonatomic, readwrite) NSString *value;
@end

@implementation BVCommentFilterType

+ (nonnull NSString *)toFilterTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVCommentFilterType filterTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)filterTypeWithRawValue:(NSInteger)rawValue {
  return [[BVCommentFilterType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVCommentFilterValueCommentId:
      self.value = @"Id";
      break;
    case BVCommentFilterValueCommentAuthorId:
      self.value = @"AuthorId";
      break;
    case BVCommentFilterValueCommentCampaignId:
      self.value = @"CampaignId";
      break;
    case BVCommentFilterValueCommentCategoryAncestorId:
      self.value = @"CategoryAncestorId";
      break;
    case BVCommentFilterValueCommentContentLocale:
      self.value = @"ContentLocale";
      break;
    case BVCommentFilterValueCommentIsFeatured:
      self.value = @"IsFeatured";
      break;
    case BVCommentFilterValueCommentLastModeratedTime:
      self.value = @"LastModeratedTime";
      break;
    case BVCommentFilterValueCommentLastModificationTime:
      self.value = @"LastModificationTime";
      break;
    case BVCommentFilterValueCommentModeratorCode:
      self.value = @"ModeratorCode";
      break;
    case BVCommentFilterValueCommentProductId:
      self.value = @"ProductId";
      break;
    case BVCommentFilterValueCommentReviewId:
      self.value = @"ReviewId";
      break;
    case BVCommentFilterValueCommentSubmissionId:
      self.value = @"SubmissionId";
      break;
    case BVCommentFilterValueCommentSubmissionTime:
      self.value = @"SubmissionTime";
      break;
    case BVCommentFilterValueCommentTotalFeedbackCount:
      self.value = @"TotalFeedbackCount";
      break;
    case BVCommentFilterValueCommentTotalNegativeFeedbackCount:
      self.value = @"TotalNegativeFeedbackCount";
      break;
    case BVCommentFilterValueCommentTotalPositiveFeedbackCount:
      self.value = @"TotalPositiveFeedbackCount";
      break;
    case BVCommentFilterValueCommentUserLocation:
      self.value = @"UserLocation";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toFilterTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithCommentFilterValue:
    (BVCommentFilterValue)commentFilterValue {
  return [[BVCommentFilterType alloc]
      initWithCommentFilterValue:commentFilterValue];
}

@end
