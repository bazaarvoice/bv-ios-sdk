//
//  BVCustomSortOrder.h
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
//
#import "BVSort.h"

@interface BVCustomSortOrder : NSObject <BVCustomSortOrderProtocol>

+ (nonnull instancetype)customSortOrderWithValues:(nonnull NSArray<NSString *> *)values;
- (nonnull instancetype)initWithCustomSortOrderValues:
    (nonnull NSArray<NSString *> *)values;
- (nonnull instancetype)__unavailable init;


@end
