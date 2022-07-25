//
//  BVSortOrder.h
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
//

#import "BVSort.h"

@interface BVSortType : NSObject <BVSortTypeProtocol>

+ (nonnull instancetype)sortTypeWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)__unavailable init;

@end
