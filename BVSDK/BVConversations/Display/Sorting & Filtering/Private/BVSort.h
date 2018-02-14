//
//  Sorts.h
//  Conversations
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

@interface BVSort : NSObject

- (nonnull id)initWithSortOption:(nonnull id<BVSortOptionProtocol>)sortOption
                       sortOrder:(nonnull id<BVSortOrderProtocol>)sortOrder;
- (nonnull id)initWithSortOptionString:(nonnull NSString *)sortOptionString
                             sortOrder:
                                 (nonnull id<BVSortOrderProtocol>)sortOrder;
- (nonnull NSString *)toParameterString;

@end
