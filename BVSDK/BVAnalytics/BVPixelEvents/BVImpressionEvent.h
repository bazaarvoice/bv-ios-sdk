//
//  BVImpressionEvent.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAnalyticEvent.h"
#import "BVPixelTypes.h"
#import <Foundation/Foundation.h>

#define UGC_IMPRESSION_SCHEMA @{@"cl" : @"Impression", @"type" : @"UGC"}

@interface BVImpressionEvent : NSObject <BVAnalyticEvent>

/**
 @param productId   Required - Product external ID
 @param contentId   Required - The identifier for the unique piece of
 user-generated content
 @param categoryId  Optional - Id of the CGC content
 @param bvProduct   Required - The product with API key being used.
 @param contentType Required - The type of content being requested by the API
 call.
 @param brand       Optional - Brand name of what the content (review, question,
 etc) is about.
 @param params      Optional - Additional key/value pairs to be send along the
 request. Most cases this will be nil.

 @return the event object that can be used to submit to Bazaarvoice via the
 BVPixel API.
 */
- (nonnull id)initWithProductId:(nonnull NSString *)productId
                  withContentId:(nonnull NSString *)contentId
                 withCategoryId:(nullable NSString *)categoryId
                withProductType:(BVPixelProductType)bvProduct
                withContentType:(BVPixelImpressionContentType)contentType
                      withBrand:(nullable NSString *)brand
           withAdditionalParams:(nullable NSDictionary *)params;

- (nonnull instancetype)__unavailable init;

/// The product Id for product presented.
@property(nonnull, nonatomic, strong, readonly) NSString *productId;

/// The identifier for the unique piece of user-generated content
@property(nonnull, nonatomic, strong, readonly) NSString *contentId;

/// The BV API used to request the product, as defined in the
/// BVPixelProductType.
@property(nonatomic, assign, readonly) BVPixelProductType bvProduct;

/// The category Id, if known, for the product presented.
@property(nullable, nonatomic, strong, readonly) NSString *categoryId;

/// Brand name for the product being viewed.
@property(nullable, nonatomic, strong, readonly) NSString *brand;

/// The individual piece of content viewed
@property(nonatomic, assign, readonly) BVPixelImpressionContentType contentType;

@end
