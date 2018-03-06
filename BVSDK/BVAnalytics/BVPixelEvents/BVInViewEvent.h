//
//  BVInViewEvent.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAnalyticEvent.h"
#import "BVPixelTypes.h"
#import <Foundation/Foundation.h>

#define FEATURE_USED_INVIEW_SCHEMA                                             \
  @{@"cl" : @"Used", @"type" : @"Feature", @"name" : @"InView"}

@interface BVInViewEvent : NSObject <BVAnalyticEvent>

/**
 Data used to track when a view is visible to the user.

 @param productId   Required - Product external ID
 @param brand       Optional - The brand name of the product.
 @param bvProduct   Required - The product with API key being used.
 @param containerId Required - The name of the container on screen, e.g.
 ReviewsView
 @param params      Optional - Additional key/value pairs to be send along the
 request. Most cases this will be nil.

 @return the event object that can be used to submit to Bazaarvoice via the
 BVPixel API.
 */
- (nonnull id)initWithProductId:(nonnull NSString *)productId
                      withBrand:(nullable NSString *)brand
                withProductType:(BVPixelProductType)bvProduct
                withContainerId:(nonnull NSString *)containerId
           withAdditionalParams:(nullable NSDictionary *)params;

- (nonnull instancetype)__unavailable init;

/// The product Id for product presented.
@property(nonnull, nonatomic, strong, readonly) NSString *productId;

/// Brand name for the product being viewed.
@property(nullable, nonatomic, strong, readonly) NSString *brand;

/// The BV API used to request the product, as defined in the
/// BVPixelProductType.
@property(nonatomic, assign, readonly) BVPixelProductType bvProduct;

/// The name of the container on screen, e.g. ReviewsView
@property(nullable, nonatomic, strong, readonly) NSString *containerId;

@end
