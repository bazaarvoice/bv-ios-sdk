//
//  BVRelationalFilterOperator.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVFilterOperator.h"
#import "BVRelationalFilterOperatorValue.h"

@interface BVRelationalFilterOperator : BVFilterOperator

- (nonnull instancetype)initWithRelationalFilterValue:
    (BVRelationalFilterOperatorValue)relationalFilterValue;

@end
