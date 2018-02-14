//
//  BVSortOption.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVSort.h"

@interface BVSortOption : NSObject <BVSortOptionProtocol>

+ (nonnull instancetype)sortOptionWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)__unavailable init;

@end
