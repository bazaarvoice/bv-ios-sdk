//
//  BVMonotonicSortOrder.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVMonotonicSortOrderValue.h"
#import "BVSortOrder.h"

@interface BVMonotonicSortOrder : BVSortOrder

- (nonnull instancetype)initWithMonotonicSortOrderValue:
    (BVMonotonicSortOrderValue)monotonicSortOrderValue;

@end
