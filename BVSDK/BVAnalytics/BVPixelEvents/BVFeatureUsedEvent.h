//
//  BVFeatureUsedEvent.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAnalyticEvent.h"
#import "BVPixelTypes.h"
#import <Foundation/Foundation.h>

#define USED_FEATURE_SCHEMA @{@"cl" : @"Feature", @"type" : @"Used"}

@interface BVFeatureUsedEvent : NSObject <BVAnalyticEvent>

/**
 Creates a Feature Used event for Bazaarvoice Mobile Analytics

 @param productId   Required - The product ID used to request the display
 content. In the event a product Id is not availble, use the contentId, or
 "none" if no product id was used to display the data.
 @prarm brand       Optional - Brand of the product for which the user in
 interacting with
 @param bvProduct   Required - The product with API key being used.
 @param eventName   Required - The actual user interaction that casued this
 event to be created.
 @param params      Optional - Additional key/value pairs to be send along the
 request. Most cases this will be nil.

 @return the event object that can be used to submit to Bazaarvoice via the
 BVPixel API.
 */
- (nonnull id)initWithProductId:(nonnull NSString *)productId
                      withBrand:(nullable NSString *)brand
                withProductType:(BVPixelProductType)bvProduct
                  withEventName:(BVPixelFeatureUsedEventName)eventName
           withAdditionalParams:(nullable NSDictionary *)params;

- (nonnull instancetype)__unavailable init;

/// The product Id for product presented.
@property(nonnull, nonatomic, strong, readonly) NSString *productId;

/// Brand name for the product being viewed.
@property(nullable, nonatomic, strong, readonly) NSString *brand;

/// The BV API used to request the product, as defined in the
/// BVPixelProductType.
@property(nonatomic, assign, readonly) BVPixelProductType bvProduct;

/// The name of the user interaction that invoked the event.
@property(nonatomic, assign, readonly) BVPixelFeatureUsedEventName eventName;

@end
