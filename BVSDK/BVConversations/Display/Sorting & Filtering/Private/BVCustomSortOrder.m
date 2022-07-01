//
//  BVCustomSortOrder.m
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

#import "BVCustomSortOrder.h"
#import "BVCommaUtil.h"

@interface BVCustomSortOrder ()
@property(nonnull, nonatomic, strong) NSString *value;
@end

@implementation BVCustomSortOrder

+ (nonnull NSString *)toCustomSortOrderParameterStringWithValues:(nonnull NSArray<NSString *> *)values
{
    return [BVCustomSortOrder customSortOrderWithValues:values].value;
}

+ (nonnull instancetype)customSortOrderWithValues:(nonnull NSArray<NSString *> *)values {
  return [[BVCustomSortOrder alloc] initWithCustomSortOrderValues:values];
}

- (nonnull NSString *)toCustomSortOrderParameterString {
    return self.value;
}

- (nonnull instancetype)initWithCustomSortOrderValues:
(nonnull NSArray<NSString *> *)values {
    if ((self = [super init])) {
        self.value = [[BVCommaUtil escapeMultiple:values] componentsJoinedByString:@","];
    }
    return self;
}

@end
