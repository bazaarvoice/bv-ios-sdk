//
//  BVRecommendationsPrivate.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#ifndef BVRecommendationsPrivate_h
#define BVRecommendationsPrivate_h

#include "BVShopperProfile.h"
#include "BVGetShopperProfile.h"

NS_ASSUME_NONNULL_BEGIN

// Type of info to include in user's profile
typedef NS_OPTIONS(NSUInteger, BVProfileFilterOptions) {
    eOptionRecommendations  = (1 << 0),
    eOptionInterests        = (1 << 1),
    eOptionBrands           = (1 << 2),
    eOptionReviews          = (1 << 3)
};


// This class is for internal use only.
@protocol BVGetShopperProfileBase


// Internal use only!
- (void)_privateFetchShopperProfile:(NSString * __nullable)productId
                             withCategoryId:(NSString * __nullable)categoryId
                             withProfileOptions:(BVProfileFilterOptions)profileOptions
                               withLimit:(NSUInteger)limit
                       completionHandler:(void (^)(BVShopperProfile * __nullable profile, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END

#endif /* BVRecommendationsPrivate_h */
