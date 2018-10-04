//
//  BVPageViewEvent.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVPageViewEvent.h"
#import "BVAnalyticEventManager+Private.h"

@implementation BVPageViewEvent

@synthesize additionalParams;

- (nonnull id)initWithProductId:(nonnull NSString *)productId
         withBVPixelProductType:(BVPixelProductType)bvProduct
                      withBrand:(nullable NSString *)brand
                 withCategoryId:(nullable NSString *)categoryId
             withRootCategoryId:(nullable NSString *)rootCategoryId
           withAdditionalParams:(nullable NSDictionary *)params;
{
  NSAssert(productId, @"productId cannot be nil");

  if ((self = [super init])) {
    _productId = productId ?: @"unknown";
    _bvProduct = bvProduct;
    _brand = brand;
    _categoryId = categoryId;
    _rootCategoryId = rootCategoryId;
    self.additionalParams = params ?: [NSDictionary dictionary];
  }
  return self;
}

- (NSDictionary *)toRaw {
  NSMutableDictionary *eventDict = [NSMutableDictionary
      dictionaryWithObjectsAndKeys:self.productId, @"productId",
                                   [BVPixelProductTypeUtil
                                       toString:self.bvProduct],
                                   @"bvProduct", nil];

  // Add nullable values
  if (self.categoryId) {
    [eventDict addEntriesFromDictionary:@{@"categoryId" : self.categoryId}];
  }

  if (self.rootCategoryId) {
    [eventDict
        addEntriesFromDictionary:@{@"rootCategoryId" : self.rootCategoryId}];
  }

  if (self.brand) {
    [eventDict addEntriesFromDictionary:@{@"brand" : self.brand}];
  }

  // Common event values implied for schema...
  [eventDict addEntriesFromDictionary:self.additionalParams];
  [eventDict addEntriesFromDictionary:PRODUCT_PAGEVIEW_SCHEMA];
  [eventDict addEntriesFromDictionary:[[BVAnalyticEventManager sharedManager]
                                          getCommonAnalyticsDictAnonymous:NO]];

  return [NSDictionary dictionaryWithDictionary:eventDict];
}

@end
