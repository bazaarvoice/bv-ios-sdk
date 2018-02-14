//
//  BVReviewIncludeType.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVIncludeType.h"
#import "BVReviewIncludeTypeValue.h"

@interface BVReviewIncludeType : BVIncludeType

- (nonnull instancetype)initWithReviewIncludeTypeValue:
    (BVReviewIncludeTypeValue)reviewIncludeTypeValue;

@end
