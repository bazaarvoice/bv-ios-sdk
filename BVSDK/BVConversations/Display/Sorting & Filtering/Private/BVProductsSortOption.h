//
//  BVProductsSortOption.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductsSortOptionValue.h"
#import "BVSortOption.h"

@interface BVProductsSortOption : BVSortOption

- (nonnull instancetype)initWithProductsSortOptionValue:
    (BVProductsSortOptionValue)productsSortOptionValue;

@end
