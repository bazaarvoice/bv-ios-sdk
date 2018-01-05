//
//  BVFilterType.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVFilter.h"

@interface BVFilterType : NSObject <BVFilterTypeProtocol>

+ (nonnull instancetype)filterTypeWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)__unavailable init;

@end
