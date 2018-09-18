//
//  Filters.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BVFilterTypeProtocol
+ (nonnull NSString *)toFilterTypeParameterStringWithRawValue:
    (NSInteger)rawValue;
- (nonnull NSString *)toFilterTypeParameterString;
@end

@protocol BVFilterOperatorProtocol
+ (nonnull NSString *)toFilterOperatorParameterStringWithRawValue:
    (NSInteger)rawValue;
- (nonnull NSString *)toFilterOperatorParameterString;
@end

@interface BVFilter : NSObject

- (nonnull id)initWithFilterType:(nonnull id<BVFilterTypeProtocol>)filterType
                  filterOperator:
                      (nonnull id<BVFilterOperatorProtocol>)filterOperator
                          values:(nonnull NSArray<NSString *> *)values;
- (nonnull id)initWithFilterType:(nonnull id<BVFilterTypeProtocol>)filterType
                  filterOperator:
                      (nonnull id<BVFilterOperatorProtocol>)filterOperator
                           value:(nonnull NSString *)value;
- (nonnull id)initWithString:(nonnull NSString *)string
              filterOperator:
                  (nonnull id<BVFilterOperatorProtocol>)filterOperator
                      values:(nonnull NSArray<NSString *> *)values;
- (nonnull NSString *)toParameterString;

@end
