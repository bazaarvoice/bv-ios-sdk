//
//  BVBulkProductRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBaseProductRequest.h"
#import "BVConversationDisplay.h"

@interface BVBulkProductRequest : BVBaseSortableProductRequest

- (nonnull instancetype)
sortByProductsSortOptionValue:(BVProductsSortOptionValue)productsSortOptionValue
      monotonicSortOrderValue:
          (BVMonotonicSortOrderValue)monotonicSortOrderValue;
- (nonnull instancetype)
   filterOnProductFilterValue:(BVProductFilterValue)productFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value;
- (nonnull instancetype)
   filterOnProductFilterValue:(BVProductFilterValue)productFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                       values:(nonnull NSArray<NSString *> *)values;

@end
