//
//  BVBulkProductRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVBaseProductRequest.h"
#import "BVProductFilterType.h"

@interface BVBulkProductRequest : BVBaseSortableProductRequest

- (nonnull instancetype)addProductSort:(BVSortOptionProducts)option order:(BVSortOrder)order;
- (nonnull instancetype)addFilter:(BVProductFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value;
- (nonnull instancetype)addFilter:(BVProductFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString *> * _Nonnull)values;

@end
