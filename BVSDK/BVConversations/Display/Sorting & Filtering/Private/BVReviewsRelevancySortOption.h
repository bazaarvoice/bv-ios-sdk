//
//  BVReviewsRelevancySortOption.h
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

#import "BVReviewsRelevancySortOptionValue.h"
#import "BVSortOption.h"

@interface BVReviewsRelevancySortOption : BVSortOption

- (nonnull instancetype)initWithReviewsRelevancySortOptionValue:
    (BVReviewsRelevancySortOptionValue)reviewsRelevancySortOptionValue;

@end

