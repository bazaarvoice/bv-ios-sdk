//
//  BVRecommendationsRequestOptions.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVRECOMMENDATIONSREQUESTOPTIONS_H
#define BVRECOMMENDATIONSREQUESTOPTIONS_H

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BVRecommendationsRequestInclude) {
  BVRecommendationsRequestIncludeBrands,
  BVRecommendationsRequestIncludeCategories,
  BVRecommendationsRequestIncludeInterests,
  BVRecommendationsRequestIncludeRecommendations
};

typedef NS_ENUM(NSUInteger, BVRecommendationsRequestPurpose) {
  BVRecommendationsRequestPurposeAds,
  BVRecommendationsRequestPurposeCurations
};

#endif /* BVRECOMMENDATIONSREQUESTOPTIONS_H */
