//
//  BVInViewEvent.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVInViewEvent.h"
#import "BVAnalyticEventManager.h"
#import "BVPixelTypes.h"

@implementation BVInViewEvent

@synthesize additionalParams;

- (nonnull id)initWithProductId:(nonnull NSString *)productId
                      withBrand:(nullable NSString *)brand
                withProductType:(BVPixelProductType)bvProduct
                withContainerId:(nonnull NSString *)containerId
           withAdditionalParams:(nullable NSDictionary *)params {
  self = [super init];

  if (self) {
    _productId = productId ? productId : @"unknown";
    _brand = brand;
    _bvProduct = bvProduct;
    _containerId = containerId;
    self.additionalParams = params ? params : [NSDictionary dictionary];
  }

  return self;
}

- (NSDictionary *)toRaw {
  NSMutableDictionary *eventDict = [NSMutableDictionary
      dictionaryWithObjectsAndKeys:self.productId, @"productId",
                                   [BVPixelProductTypeUtil
                                       toString:self.bvProduct],
                                   @"bvProduct", self.containerId, @"component",
                                   nil];

  // Add nullable values
  if (self.brand != nil) {
    [eventDict addEntriesFromDictionary:@{@"brand" : self.brand}];
  }

  // Common event values implied for schema...
  [eventDict addEntriesFromDictionary:self.additionalParams];
  [eventDict addEntriesFromDictionary:FEATURE_USED_INVIEW_SCHEMA];
  [eventDict addEntriesFromDictionary:[[BVAnalyticEventManager sharedManager]
                                          getCommonAnalyticsDictAnonymous:NO]];

  return [NSDictionary dictionaryWithDictionary:eventDict];
}

@end
