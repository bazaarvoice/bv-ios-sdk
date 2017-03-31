//
//  BVProductTextSeachRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVBaseProductRequest.h"

@interface BVProductTextSearchRequest : BVBaseProductsRequest

- (nonnull instancetype)initWithSearchText:(NSString * _Nullable)searchText;
- (nonnull instancetype) __unavailable init;

@end
