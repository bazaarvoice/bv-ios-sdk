//
//  BVGetShopperProfile.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//


#ifndef BVGetShopperProfile_h
#define BVGetShopperProfile_h

#import <Foundation/Foundation.h>

#import "BVCore.h"
#import "BVRecommendations.h"
#import "BVGetShopperProfileBase.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  The shopper profile contains product recommendations for a single user, based on a user's profile information, IDFA (if allowed) and provides the ability to filter by a user's interest. This class provides a convenience wrapper for fetching the product recommendations and handling analytic event handling to help shape the shopper profile. For user authentication, please see the BVAuthticatedUser class.
 */
@interface BVGetShopperProfile : NSObject <BVGetShopperProfileBase>

/*!
    Gets a user's profile associted with the IDFA of the user's iOS device. The user's profile is fetched asynchronously with the result returned in the completion handler. Implementation should check for a non-nil NSError response and non-nil BVShopperProfile, either of which indicate an API failure.
 
    If the device settings under Advertising has "Limit Ad Tracking" enabled, the API will return generic recommendations without using the device IDFA.
 *
 *  @param limit             Number of product recommendations to return. Default is 20. Max is 50.
 *  @param interest          Interest to filter on.
 *  @param completionHandler Completion handler with BVShopperProfile containing product recommendations. If an error occurs, error will be non-nil in the completionHandler.
 */
- (void)fetchProductRecommendations:(NSUInteger)limit
              withCompletionHandler:(void (^)(BVShopperProfile * __nullable profile, NSError * __nullable error))completionHandler;


@end

NS_ASSUME_NONNULL_END

#endif