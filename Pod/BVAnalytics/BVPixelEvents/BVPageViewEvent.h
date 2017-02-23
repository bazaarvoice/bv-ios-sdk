//
//  BVPageViewEvent.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVPixelTypes.h"
#import "BVAnalyticEvent.h"

#define PRODUCT_PAGEVIEW_SCHEMA   @{@"cl": @"PageView",@"type": @"Product"}

@interface BVPageViewEvent : NSObject <BVAnalyticEvent>

/**
 @param productId  Required - Product external ID
 @param bvProduct  Required - The product with API key being used.
 @param brand      Optional - Brand name for which the PageView is about.
 @param categoryId Optional - The category Id for the product, e.g. 'Electronics_Helmet_Cameras'
 @param rootCategoryId Optional - Root cateogry for the product, e.g. 'electronics'
 @param params     Optional - Additional key/value pairs to be send along the request. Most cases this will be nil.

@return the event object that can be used to submit to Bazaarvoice via the BVPixel API.
 */
-(id _Nonnull)initWithProductId:(NSString * _Nonnull)productId
         withBVPixelProductType:(BVPixelProductType)bvProduct
                      withBrand:(NSString * _Nullable)brand
                 withCategoryId:(NSString * _Nullable)categoryId
             withRootCategoryId:(NSString * _Nullable)rootCategoryId
           withAdditionalParams:(NSDictionary * _Nullable)params;

- (nonnull instancetype) __unavailable init;

/// The product Id for product presented.
@property (nonatomic, strong, readonly) NSString* _Nonnull productId;

/// The BV API used to request the product, as defined in the BVPixelProductType.
@property (nonatomic, assign, readonly) BVPixelProductType  bvProduct;

/// The category Id, if known, for the product presented.
@property (nonatomic, strong, readonly) NSString* _Nullable categoryId;

/// The root category Id, if known, for the product presented.
@property (nonatomic, strong, readonly) NSString* _Nullable rootCategoryId;

/// Brand name for the product being viewed.
@property (nonatomic, strong, readonly) NSString * _Nullable brand;

@end
