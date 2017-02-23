//
//  BVFeatureUsedEvent.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVAnalyticEvent.h"
#import "BVPixelTypes.h"

#define USED_FEATURE_SCHEMA   @{@"cl": @"Feature",@"type": @"Used"}

@interface BVFeatureUsedEvent : NSObject <BVAnalyticEvent>

/**
 Creates a Feature Used event for Bazaarvoice Mobile Analytics
 
 @param productId   Required - The product ID used to request the display content. In the event a product Id is not availble, use the contentId, or "none" if no product id was used to display the data.
 @prarm brand       Optional - Brand of the product for which the user in interacting with
 @param bvProduct   Required - The product with API key being used.
 @param eventName   Required - The actual user interaction that casued this event to be created.
 @param params      Optional - Additional key/value pairs to be send along the request. Most cases this will be nil.
 
 @return the event object that can be used to submit to Bazaarvoice via the BVPixel API.
 */
-(id _Nonnull)initWithProductId:(NSString * _Nonnull)productId
                    withBrand:(NSString * _Nullable)brand
         withProductType:(BVPixelProductType)bvProduct
            withEventName:(BVPixelFeatureUsedEventName)eventName
           withAdditionalParams:(NSDictionary * _Nullable)params;

- (nonnull instancetype) __unavailable init;


/// The product Id for product presented.
@property (nonatomic, strong, readonly) NSString* _Nonnull productId;

/// Brand name for the product being viewed.
@property (nonatomic, strong, readonly) NSString * _Nullable brand;

/// The BV API used to request the product, as defined in the BVPixelProductType.
@property (nonatomic, assign, readonly) BVPixelProductType  bvProduct;

/// The name of the user interaction that invoked the event.
@property (nonatomic, assign, readonly) BVPixelFeatureUsedEventName eventName;

@end
