//
//  BVSortOptionProducts.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSortOptionProducts.h"

@implementation BVSortOptionProductsUtil

+ (nonnull NSString *)toString:(BVSortOptionProducts)BVSortOptionProducts {

  switch (BVSortOptionProducts) {

  case BVSortOptionProductsId:
    return @"Id";
  case BVSortOptionProductsAverageOverallRating:
    return @"AverageOverallRating";
  case BVSortOptionProductsRating:
    return @"Rating";
  case BVSortOptionProductsCategoryId:
    return @"CategoryId";
  case BVSortOptionProductsIsActive:
    return @"IsActive";
  case BVSortOptionProductsIsDisabled:
    return @"IsDisabled";
  case BVSortOptionProductsLastAnswerTime:
    return @"LastAnswerTime";
  case BVSortOptionProductsLastQuestionTime:
    return @"LastQuestionTime";
  case BVSortOptionProductsLastReviewTime:
    return @"LastReviewTime";
  case BVSortOptionProductsLastStoryTime:
    return @"LastStoryTime";
  case BVSortOptionProductsName:
    return @"Name";
  case BVSortOptionProductsRatingsOnlyReviewCount:
    return @"RatingsOnlyReviewCount";
  case BVSortOptionProductsTotalAnswerCount:
    return @"TotalAnswerCount";
  case BVSortOptionProductsTotalQuestionCount:
    return @"TotalQuestionCount";
  case BVSortOptionProductsTotalReviewCount:
    return @"TotalReviewCount";
  case BVSortOptionProductsTotalStoryCount:
    return @"TotalStoryCount";
  case BVSortOptionProductsHelpfulness:
    return @"Helpfulness";
  }
}

@end
