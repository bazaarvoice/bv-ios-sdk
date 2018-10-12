//
//  BVReviewFilterType.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewFilterType.h"

@interface BVReviewFilterType ()
@property(nonnull, nonatomic, readwrite) NSString *value;
@end

@implementation BVReviewFilterType

+ (nonnull NSString *)toFilterTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVReviewFilterType filterTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)filterTypeWithRawValue:(NSInteger)rawValue {
  return [[BVReviewFilterType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVReviewFilterValueId:
      self.value = @"Id";
      break;
    case BVReviewFilterValueAuthorId:
      self.value = @"AuthorId";
      break;
    case BVReviewFilterValueCampaignId:
      self.value = @"CampaignId";
      break;
    case BVReviewFilterValueCategoryAncestorId:
      self.value = @"CategoryAncestorId";
      break;
    case BVReviewFilterValueContentLocale:
      self.value = @"ContentLocale";
      break;
    case BVReviewFilterValueHasComments:
      self.value = @"HasComments";
      break;
    case BVReviewFilterValueHasPhotos:
      self.value = @"HasPhotos";
      break;
    case BVReviewFilterValueHasTags:
      self.value = @"HasTags";
      break;
    case BVReviewFilterValueHasVideos:
      self.value = @"HasVideos";
      break;
    case BVReviewFilterValueIsFeatured:
      self.value = @"IsFeatured";
      break;
    case BVReviewFilterValueIsRatingsOnly:
      self.value = @"IsRatingsOnly";
      break;
    case BVReviewFilterValueIsRecommended:
      self.value = @"IsRecommended";
      break;
    case BVReviewFilterValueIsSubjectActive:
      self.value = @"IsSubjectActive";
      break;
    case BVReviewFilterValueIsSyndicated:
      self.value = @"IsSyndicated";
      break;
    case BVReviewFilterValueLastModeratedTime:
      self.value = @"LastModeratedTime";
      break;
    case BVReviewFilterValueLastModificationTime:
      self.value = @"LastModificationTime";
      break;
    case BVReviewFilterValueModeratorCode:
      self.value = @"ModeratorCode";
      break;
    case BVReviewFilterValueProductId:
      self.value = @"ProductId";
      break;
    case BVReviewFilterValueRating:
      self.value = @"Rating";
      break;
    case BVReviewFilterValueSubmissionId:
      self.value = @"SubmissionId";
      break;
    case BVReviewFilterValueSubmissionTime:
      self.value = @"SubmissionTime";
      break;
    case BVReviewFilterValueTotalCommentCount:
      self.value = @"TotalCommentCount";
      break;
    case BVReviewFilterValueTotalFeedbackCount:
      self.value = @"TotalFeedbackCount";
      break;
    case BVReviewFilterValueTotalNegativeFeedbackCount:
      self.value = @"TotalNegativeFeedbackCount";
      break;
    case BVReviewFilterValueTotalPositiveFeedbackCount:
      self.value = @"TotalPositiveFeedbackCount";
      break;
    case BVReviewFilterValueUserLocation:
      self.value = @"UserLocation";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toFilterTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithReviewFilterValue:
    (BVReviewFilterValue)reviewFilterValue {
  return [BVReviewFilterType filterTypeWithRawValue:reviewFilterValue];
}

@end
