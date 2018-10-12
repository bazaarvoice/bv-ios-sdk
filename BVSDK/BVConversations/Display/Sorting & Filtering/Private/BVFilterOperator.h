//
//  FilterOperator.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFilter.h"

@interface BVFilterOperator : NSObject <BVFilterOperatorProtocol>

+ (nonnull instancetype)filterOperatorWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue;
- (nonnull instancetype)__unavailable init;

@end
