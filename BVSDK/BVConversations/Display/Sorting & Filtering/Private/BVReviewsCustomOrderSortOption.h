//
//  BVReviewsCustomOrderCustomOrderSortOption.h
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

#import "BVReviewsCustomOrderSortOptionValue.h"
#import "BVSortOption.h"

@interface BVReviewsCustomOrderSortOption : BVSortOption

- (nonnull instancetype)initWithReviewsSortOptionValue:
    (BVReviewsCustomOrderSortOptionValue)reviewsSortOptionValue;

@end
