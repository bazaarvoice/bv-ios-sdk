//
//  BVIncludeType.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVInclude.h"

@interface BVIncludeType : NSObject <BVIncludeTypeProtocol>

+ (nonnull instancetype)includeTypeWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)__unavailable init;

@end
