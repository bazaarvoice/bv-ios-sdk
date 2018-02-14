//
//  BVReviewsSortOption.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewsSortOption.h"

@interface BVReviewsSortOption ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVReviewsSortOption

+ (nonnull NSString *)toSortOptionParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVReviewsSortOption sortOptionWithRawValue:rawValue].value;
}

+ (nonnull instancetype)sortOptionWithRawValue:(NSInteger)rawValue {
  return [[BVReviewsSortOption alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVReviewsSortOptionValueReviewId:
      self.value = @"Id";
      break;
    case BVReviewsSortOptionValueReviewAuthorId:
      self.value = @"AuthorId";
      break;
    case BVReviewsSortOptionValueReviewCampaignId:
      self.value = @"CampaignId";
      break;
    case BVReviewsSortOptionValueReviewContentLocale:
      self.value = @"ContentLocale";
      break;
    case BVReviewsSortOptionValueReviewHasComments:
      self.value = @"HasComments";
      break;
    case BVReviewsSortOptionValueReviewHasPhotos:
      self.value = @"HasPhotos";
      break;
    case BVReviewsSortOptionValueReviewHasTags:
      self.value = @"HasTags";
      break;
    case BVReviewsSortOptionValueReviewHasVideos:
      self.value = @"HasVideos";
      break;
    case BVReviewsSortOptionValueReviewHelpfulness:
      self.value = @"Helpfulness";
      break;
    case BVReviewsSortOptionValueReviewIsFeatured:
      self.value = @"IsFeatured";
      break;
    case BVReviewsSortOptionValueReviewIsRatingsOnly:
      self.value = @"IsRatingsOnly";
      break;
    case BVReviewsSortOptionValueReviewIsRecommended:
      self.value = @"IsRecommended";
      break;
    case BVReviewsSortOptionValueReviewIsSubjectActive:
      self.value = @"IsSubjectActive";
      break;
    case BVReviewsSortOptionValueReviewIsSyndicated:
      self.value = @"IsSyndicated";
      break;
    case BVReviewsSortOptionValueReviewLastModeratedTime:
      self.value = @"LastModeratedTime";
      break;
    case BVReviewsSortOptionValueReviewLastModificationTime:
      self.value = @"LastModificationTime";
      break;
    case BVReviewsSortOptionValueReviewProductId:
      self.value = @"ProductId";
      break;
    case BVReviewsSortOptionValueReviewRating:
      self.value = @"Rating";
      break;
    case BVReviewsSortOptionValueReviewSubmissionId:
      self.value = @"SubmissionId";
      break;
    case BVReviewsSortOptionValueReviewSubmissionTime:
      self.value = @"SubmissionTime";
      break;
    case BVReviewsSortOptionValueReviewTotalCommentCount:
      self.value = @"TotalCommentCount";
      break;
    case BVReviewsSortOptionValueReviewTotalFeedbackCount:
      self.value = @"TotalFeedbackCount";
      break;
    case BVReviewsSortOptionValueReviewTotalNegativeFeedbackCount:
      self.value = @"TotalNegativeFeedbackCount";
      break;
    case BVReviewsSortOptionValueReviewTotalPositiveFeedbackCount:
      self.value = @"TotalPositiveFeedbackCount";
      break;
    case BVReviewsSortOptionValueReviewUserLocation:
      self.value = @"UserLocation";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toSortOptionParameterString {
  return self.value;
}

- (nonnull instancetype)initWithReviewsSortOptionValue:
    (BVReviewsSortOptionValue)reviewsSortOptionValue {
  return [BVReviewsSortOption sortOptionWithRawValue:reviewsSortOptionValue];
}

@end
