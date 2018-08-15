//
//  BVRecommendationsRequestOptionsUtil.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVRecommendationsRequestOptionsUtil.h"

@implementation BVRecommendationsRequestOptionsUtil

+ (nonnull NSString *)valueForRecommendationsRequestInclude:
    (BVRecommendationsRequestInclude)recommendationsRequestInclude {
  switch (recommendationsRequestInclude) {
  case BVRecommendationsRequestIncludeBrands:
    return @"brands";
    break;

  case BVRecommendationsRequestIncludeCategories:
    return @"category_recommendations";
    break;

  case BVRecommendationsRequestIncludeInterests:
    return @"interests";
    break;

  case BVRecommendationsRequestIncludeRecommendations:
    return @"recommendations";
    break;

  default:
    return @"";
    break;
  }
}

+ (nonnull NSString *)valueForRecommendationsRequestPurpose:
    (BVRecommendationsRequestPurpose)recommendationsRequestPurpose {
  switch (recommendationsRequestPurpose) {
  case BVRecommendationsRequestPurposeAds:
    return @"ads";
    break;

  case BVRecommendationsRequestPurposeCurations:
    return @"curations";
    break;

  default:
    return @"";
    break;
  }
}

@end
