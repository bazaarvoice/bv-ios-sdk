//
//  BVBulkRatingFilterType.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingFilterValue.h"
#import "BVFilterType.h"

@interface BVBulkRatingFilterType : BVFilterType

- (nonnull instancetype)initWithBulkRatingFilterValue:
    (BVBulkRatingFilterValue)bulkRatingFilterValue;

@end
