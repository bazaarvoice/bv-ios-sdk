//
//  BVProductFilterType.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFilterType.h"
#import "BVProductFilterValue.h"

@interface BVProductFilterType : BVFilterType

- (nonnull instancetype)initWithProductFilterValue:
    (BVProductFilterValue)productFilterValue;

@end
