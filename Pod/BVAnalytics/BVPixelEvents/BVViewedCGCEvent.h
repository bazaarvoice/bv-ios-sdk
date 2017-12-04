//
//  BVViewedCGCEvent.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAnalyticEvent.h"
#import "BVPixelTypes.h"
#import <Foundation/Foundation.h>

#define VIEWED_CGC_SCHEMA @{@"cl" : @"Feature", @"type" : @"UsedViewedUGC"}

/**
 BVViewedCGCEvent should be used to indicate that UGC (User Generated Content)
 is visible on the screen and has been in the view for an designated amount of
 time. This event should only be fired once per lifetime of a ViewController.
 This differs from a BVInView event in that a delay should be provided
 (typically 5 seconds) to know that content is visible and readable on the
 screen.
 */
@interface BVViewedCGCEvent : NSObject <BVAnalyticEvent>

/**
 Used to create an event to indicate that CGC is visible on the screen and has
 been in the view for an designated amount of time. This event should only be
 fired once per lifetime of a ViewController.

 @param productId   Required - The product Id for which the UGC is assoicated.
 @param rootCategoryId   Optional - This value should be obtained from the
 product feed.
 @param categoryId  Optional - This value should be obtained from the product
 feed.
 @param bvProduct   Reuired - The product with API key being used.
 @param brand       Optional - The brand name of the product.
 @param params      Optional - Additional key/value pairs to be send along the
 request. Most cases this will be nil.

 @return The event object that can be used to submit to Bazaarvoice via the
 BVPixel API.
 */
- (nonnull id)initWithProductId:(nonnull NSString *)productId
             withRootCategoryID:(nullable NSString *)rootCategoryId
                 withCategoryId:(nullable NSString *)categoryId
                withProductType:(BVPixelProductType)bvProduct
                      withBrand:(nullable NSString *)brand
           withAdditionalParams:(nullable NSDictionary *)params;

- (nonnull instancetype)__unavailable init;

/// The product Id for product presented.
@property(nonnull, nonatomic, strong, readonly) NSString *productId;

/// The BV API used to request the product, as defined in the
/// BVPixelProductType.
@property(nonatomic, assign, readonly) BVPixelProductType bvProduct;

/// The category Id, if known, for the product presented.
@property(nullable, nonatomic, strong, readonly) NSString *categoryId;

/// The root category Id, if known, for the product presented.
@property(nullable, nonatomic, strong, readonly) NSString *rootCategoryId;

/// Brand name for the product being viewed.
@property(nullable, nonatomic, strong, readonly) NSString *brand;

@end
