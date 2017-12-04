//
//  BVProductFilterType.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The allowable filter types for `BVProductDisplayPageRequest` requests.
 */
typedef NS_ENUM(NSInteger, BVProductFilterType) {
  BVProductFilterTypeId,
  BVProductFilterTypeAverageOverallRating,
  BVProductFilterTypeCategoryAncestorId,
  BVProductFilterTypeCategoryId,
  BVProductFilterTypeIsActive,
  BVProductFilterTypeIsDisabled,
  BVProductFilterTypeLastAnswerTime,
  BVProductFilterTypeLastQuestionTime,
  BVProductFilterTypeLastReviewTime,
  BVProductFilterTypeLastStoryTime,
  BVProductFilterTypeName,
  BVProductFilterTypeRatingsOnlyReviewCount,
  BVProductFilterTypeTotalAnswerCount,
  BVProductFilterTypeTotalQuestionCount,
  BVProductFilterTypeTotalReviewCount,
  BVProductFilterTypeTotalStoryCount
};

@interface BVProductFilterTypeUtil : NSObject

+ (nonnull NSString *)toString:(BVProductFilterType)filterOperator;

@end
