//
//  Sorts.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BVSortOptionProtocol
+ (nonnull NSString *)toSortOptionParameterStringWithRawValue:
    (NSInteger)rawValue;
- (nonnull NSString *)toSortOptionParameterString;
@end

@protocol BVSortOrderProtocol
+ (nonnull NSString *)toSortOrderParameterStringWithRawValue:
    (NSInteger)rawValue;
- (nonnull NSString *)toSortOrderParameterString;
@end

@protocol BVCustomSortOrderProtocol
+ (nonnull NSString *)toCustomSortOrderParameterStringWithValues:
    (nonnull NSArray<NSString *> *)values;
- (nonnull NSString *)toCustomSortOrderParameterString;
@end

@interface BVSort : NSObject

- (nonnull id)initWithSortOption:(nonnull id<BVSortOptionProtocol>)sortOption
                       sortOrder:(nonnull id<BVSortOrderProtocol>)sortOrder;
- (nonnull id)initWithSortOptionString:(nonnull NSString *)sortOptionString
                             sortOrder:
                                 (nonnull id<BVSortOrderProtocol>)sortOrder;
- (nonnull id)initWithCustomOrderSortOption:(nonnull id<BVSortOptionProtocol>)customOrderSortOption
                       customSortOrder:(nonnull id<BVCustomSortOrderProtocol>)customSortOrder;
- (nonnull NSString *)toParameterString;

@end
