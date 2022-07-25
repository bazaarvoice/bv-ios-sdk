//
//  BVRelevancySortType.h
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
//

#import "BVRelevancySortTypeValue.h"
#import "BVSortType.h"

@interface BVRelevancySortType : BVSortType

- (nonnull instancetype)initWithRelevancySortTypeValue:
    (BVRelevancySortTypeValue)relevancySortTypeValue;

@end
