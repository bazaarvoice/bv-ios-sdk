//
//  BVImpressionEvent.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVImpressionEvent.h"
#import "BVAnalyticEventManager+Private.h"

@implementation BVImpressionEvent

@synthesize additionalParams;

- (nonnull id)initWithProductId:(nonnull NSString *)productId
                  withContentId:(nonnull NSString *)contentId
                 withCategoryId:(nullable NSString *)categoryId
                withProductType:(BVPixelProductType)bvProduct
                withContentType:(BVPixelImpressionContentType)contentType
                      withBrand:(nullable NSString *)brand
           withAdditionalParams:(nullable NSDictionary *)params {
  if ((self = [super init])) {
    _productId = productId ? productId : @"unknown";
    _contentId = contentId ? contentId : @"unknown";
    _categoryId = categoryId;
    _bvProduct = bvProduct;
    _contentType = contentType;
    _brand = brand;
    self.additionalParams = params ? params : [NSDictionary dictionary];
  }
  return self;
}

- (NSDictionary *)toRaw {
  NSMutableDictionary *eventDict = [NSMutableDictionary
      dictionaryWithObjectsAndKeys:self.productId, @"productId", self.contentId,
                                   @"contentId",
                                   [BVPixelProductTypeUtil
                                       toString:self.bvProduct],
                                   @"bvProduct",
                                   [BVPixelImpressionContentTypeUtil
                                       toString:self.contentType],
                                   @"contentType", nil];

  // Add nullable values
  if (self.categoryId) {
    [eventDict addEntriesFromDictionary:@{@"categoryId" : self.categoryId}];
  }

  if (self.brand) {
    [eventDict addEntriesFromDictionary:@{@"brand" : self.brand}];
  }

  // Common event values implied for schema...
  [eventDict addEntriesFromDictionary:self.additionalParams];
  [eventDict addEntriesFromDictionary:UGC_IMPRESSION_SCHEMA];
  [eventDict addEntriesFromDictionary:[[BVAnalyticEventManager sharedManager]
                                          getCommonAnalyticsDictAnonymous:NO]];

  return [NSDictionary dictionaryWithDictionary:eventDict];
}
@end
