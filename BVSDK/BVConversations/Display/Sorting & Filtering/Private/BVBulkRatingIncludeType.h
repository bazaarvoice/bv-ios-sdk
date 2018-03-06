//
//  BVBulkRatingIncludeType.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingIncludeTypeValue.h"
#import "BVIncludeType.h"

@interface BVBulkRatingIncludeType : BVIncludeType

- (nonnull instancetype)initWithBulkRatingIncludeTypeValue:
    (BVBulkRatingIncludeTypeValue)bulkRatingIncludeTypeValue;

@end
