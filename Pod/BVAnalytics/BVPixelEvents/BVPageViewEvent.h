//
//  BVPageViewEvent.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVAnalyticEvent.h"
#import "BVPixelTypes.h"

#define PRODUCT_PAGEVIEW_SCHEMA @{@"cl" : @"PageView", @"type" : @"Product"}

@interface BVPageViewEvent : NSObject <BVAnalyticEvent>

/**
 @param productId  Required - Product external ID
 @param bvProduct  Required - The product with API key being used.
 @param brand      Optional - Brand name for which the PageView is about.
 @param categoryId Optional - The category Id for the product, e.g.
'Electronics_Helmet_Cameras'
 @param rootCategoryId Optional - Root cateogry for the product, e.g.
'electronics'
 @param params     Optional - Additional key/value pairs to be send along the
request. Most cases this will be nil.

@return the event object that can be used to submit to Bazaarvoice via the
BVPixel API.
 */
- (nonnull id)initWithProductId:(nonnull NSString *)productId
         withBVPixelProductType:(BVPixelProductType)bvProduct
                      withBrand:(nullable NSString *)brand
                 withCategoryId:(nullable NSString *)categoryId
             withRootCategoryId:(nullable NSString *)rootCategoryId
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
