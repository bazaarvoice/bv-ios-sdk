//
//  BVProductTextSeachRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBaseProductRequest.h"
#import <Foundation/Foundation.h>

@interface BVProductTextSearchRequest : BVBaseProductsRequest

- (nonnull instancetype)initWithSearchText:(nullable NSString *)searchText;
- (nonnull instancetype)__unavailable init;

@end
