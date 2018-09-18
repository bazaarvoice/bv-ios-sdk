//
//  BVCommentsSortOption.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentsSortOption.h"

@interface BVCommentsSortOption ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVCommentsSortOption

+ (nonnull NSString *)toSortOptionParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVCommentsSortOption sortOptionWithRawValue:rawValue].value;
}

+ (nonnull instancetype)sortOptionWithRawValue:(NSInteger)rawValue {
  return [[BVCommentsSortOption alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVCommentsSortOptionValueCommentId:
      self.value = @"Id";
      break;
    case BVCommentsSortOptionValueCommentAuthorId:
      self.value = @"AuthorId";
      break;
    case BVCommentsSortOptionValueCommentCampaignId:
      self.value = @"CampaignId";
      break;
    case BVCommentsSortOptionValueCommentContentLocale:
      self.value = @"ContentLocale";
      break;
    case BVCommentsSortOptionValueCommentIsFeatured:
      self.value = @"IsFeatured";
      break;
    case BVCommentsSortOptionValueCommentLastModeratedTime:
      self.value = @"LastModeratedTime";
      break;
    case BVCommentsSortOptionValueCommentLastModificationTime:
      self.value = @"LastModificationTime";
      break;
    case BVCommentsSortOptionValueCommentProductId:
      self.value = @"ProductId";
      break;
    case BVCommentsSortOptionValueCommentReviewId:
      self.value = @"ReviewId";
      break;
    case BVCommentsSortOptionValueCommentSubmissionId:
      self.value = @"SubmissionId";
      break;
    case BVCommentsSortOptionValueCommentSubmissionTime:
      self.value = @"SubmissionTime";
      break;
    case BVCommentsSortOptionValueCommentTotalFeedbackCount:
      self.value = @"TotalFeedbackCount";
      break;
    case BVCommentsSortOptionValueCommentTotalNegativeFeedbackCount:
      self.value = @"TotalNegativeFeedbackCount";
      break;
    case BVCommentsSortOptionValueCommentTotalPositiveFeedbackCount:
      self.value = @"TotalPositiveFeedbackCount";
      break;
    case BVCommentsSortOptionValueCommentUserLocation:
      self.value = @"UserLocation";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toSortOptionParameterString {
  return self.value;
}

- (nonnull instancetype)initWithSortOptionCommentsValue:
    (BVCommentsSortOptionValue)commentsSortOptionValue {
  return [BVCommentsSortOption sortOptionWithRawValue:commentsSortOptionValue];
}

@end
