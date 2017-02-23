//
//  BVImpressionEvent.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVAnalyticEvent.h"
#import "BVPixelTypes.h"

#define UGC_IMPRESSION_SCHEMA   @{@"cl": @"Impression",@"type": @"UGC"}

@interface BVImpressionEvent : NSObject <BVAnalyticEvent>

/**
 @param productId   Required - Product external ID
 @param contentId   Required - The identifier for the unique piece of user-generated content
 @param categoryId  Optional - Id of the CGC content
 @param bvProduct   Required - The product with API key being used.
 @param contentType Required - The type of content being requested by the API call.
 @param brand       Optional - Brand name of what the content (review, question, etc) is about.
 @param params      Optional - Additional key/value pairs to be send along the request. Most cases this will be nil.
 
 @return the event object that can be used to submit to Bazaarvoice via the BVPixel API.
 */
-(id _Nonnull)initWithProductId:(NSString * _Nonnull)productId
                  withContentId:(NSString * _Nonnull)contentId
                 withCategoryId:(NSString * _Nullable)categoryId
         withProductType:(BVPixelProductType)bvProduct
                withContentType:(BVPixelImpressionContentType)contentType
                      withBrand:(NSString * _Nullable)brand
           withAdditionalParams:(NSDictionary * _Nullable)params;

- (nonnull instancetype) __unavailable init;

/// The product Id for product presented.
@property (nonatomic, strong, readonly) NSString* _Nonnull productId;

/// The identifier for the unique piece of user-generated content
@property (nonatomic, strong, readonly) NSString* _Nonnull contentId;

/// The BV API used to request the product, as defined in the BVPixelProductType.
@property (nonatomic, assign, readonly) BVPixelProductType  bvProduct;

/// The category Id, if known, for the product presented.
@property (nonatomic, strong, readonly) NSString* _Nullable categoryId;

/// Brand name for the product being viewed.
@property (nonatomic, strong, readonly) NSString * _Nullable brand;

/// The individual piece of content viewed
@property (nonatomic, assign, readonly) BVPixelImpressionContentType  contentType;

@end
