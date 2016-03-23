//
//  BVGetShopperProfile.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "BVCore.h"
#import "BVRecommendations.h"
#import "BVGetShopperProfileBase.h"

NS_ASSUME_NONNULL_BEGIN


/**
 *  The shopper profile contains product recommendations for a single user, based on a user's profile information, IDFA (if allowed) and provides the ability to filter by a user's interest. This class provides a convenience wrapper for fetching the product recommendations and handling analytic event handling to help shape the shopper profile. For user authentication, please see the BVAuthticatedUser class.
 */
@interface BVGetShopperProfile : NSObject <BVGetShopperProfileBase>

/**
 *  Set the default cache duration, in seconds, for Shopper Profile API requests. Set to 0 for no caching. Default is 60 seconds.
 *
 *  @availability BVSDK 3.0.1 and later
 */
@property (nonatomic, assign) NSInteger maxCacheAge;

@property (readonly) NSString* _Nullable productId;
@property (readonly) NSString* _Nullable categoryId;
@property (readonly) NSUInteger limit;

/*!
    Gets a user's profile associted with the IDFA of the user's iOS device. The user's profile is fetched asynchronously with the result returned in the completion handler. Implementation should check for a non-nil NSError response and non-nil BVShopperProfile, either of which indicate an API failure.
 
    If the device settings under Advertising has "Limit Ad Tracking" enabled, the API will return generic recommendations without using the device IDFA.
 *
 *  @param limit             Number of product recommendations to return. Default is 20, Max is 50.
 *  @param completionHandler Completion handler with BVShopperProfile containing product recommendations. If an error occurs, error will be non-nil in the completionHandler.
 */
- (void)fetchProductRecommendations:(NSUInteger)limit
              withCompletionHandler:(void (^)(BVShopperProfile * __nullable profile, NSError * __nullable error))completionHandler;


/**
 *  Get product recommendations for a user, based on the context of a product identifier. This recommendation strategy is useful for making product recommendations in the context of a product page.
 *
 *  @param productId         The product id (or key) comprised of the <client>/<product id>
 *  @param limit             The maximum number of recommendations to return. Default is 20, max is 50.
 *  @param completionHandler Completion handler with BVShopperProfile containing product recommendations. If an error occurs, error will be non-nil in the completionHandler.
 *
 *  @availability 3.0.1 and later
 */
- (void)fetchProductRecommendationsForProduct:(NSString *)productId
                                    withLimit:(NSUInteger)limit
              withCompletionHandler:(void (^)(BVShopperProfile * __nullable profile, NSError * __nullable error))completionHandler;


/**
 *  Get product recommendations for a user, based on the context of product category id.
 *
 *  @param categoryId        The category Id supplied by the client. Comprised of <cliend id>/<category id>
 *  @param limit             The maximum number of recommendations to return. Default is 20, max is 50.
 *  @param completionHandler Completion handler with BVShopperProfile containing product recommendations. If an error occurs, error will be non-nil in the completionHandler.
 *
 *  @availability 3.0.1 and later
 */
- (void)fetchProductRecommendationsForCategory:(NSString *)categoryId
                                    withLimit:(NSUInteger)limit
                        withCompletionHandler:(void (^)(BVShopperProfile * __nullable profile, NSError * __nullable error))completionHandler;


@end


NS_ASSUME_NONNULL_END
