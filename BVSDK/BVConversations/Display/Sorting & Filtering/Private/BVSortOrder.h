//
//  BVSortOrder.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVSort.h"

@interface BVSortOrder : NSObject <BVSortOrderProtocol>

+ (nonnull instancetype)sortOrderWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)__unavailable init;

@end
