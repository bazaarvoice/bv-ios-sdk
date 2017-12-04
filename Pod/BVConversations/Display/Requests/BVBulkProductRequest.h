//
//  BVBulkProductRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBaseProductRequest.h"
#import "BVProductFilterType.h"
#import <Foundation/Foundation.h>

@interface BVBulkProductRequest : BVBaseSortableProductRequest

- (nonnull instancetype)addProductSort:(BVSortOptionProducts)option
                                 order:(BVSortOrder)order;
- (nonnull instancetype)addFilter:(BVProductFilterType)type
                   filterOperator:(BVFilterOperator)filterOperator
                            value:(nonnull NSString *)value;
- (nonnull instancetype)addFilter:(BVProductFilterType)type
                   filterOperator:(BVFilterOperator)filterOperator
                           values:(nonnull NSArray<NSString *> *)values;

@end
