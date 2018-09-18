//
//  BVStore.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#import "BVBrand.h"
#import "BVGenericConversationsResult.h"
#import "BVQAStatistics.h"
#import "BVQuestion.h"
#import "BVReview.h"
#import "BVReviewStatistics.h"
#import "BVStoreLocation.h"

/**
 A BVStore object is found within the response objects: BVBulkStoresResponse and
 BVStoreReviewsResponse.
 Some commonly used data in a store:
    Product page URL is included in the `productPageUrl` property. This would be
 the icon to display the store in your app.
    Product image URL is included in the `imageUrl` property.
    Store review statistics are included in the `reviewStatistics` property, if
 requested in the original request object.
    The storeLocation provides additional attributes about the store, such as
 geo-location and phone number.
 */
@interface BVStore : BVGenericConversationsResult

@property(nullable) BVBrand *brand;
@property(nullable) BVStoreLocation *storeLocation;
@property(nullable) NSString *productDescription;
@property(nullable) NSDictionary *attributes;
@property(nullable) NSString *brandExternalId;
@property(nullable) NSString *productPageUrl;
@property(nullable) NSString *imageUrl;
@property(nullable) NSString *name;
@property(nullable) NSString *categoryId;
@property(nullable) NSString *identifier;
@property(nullable) BVReviewStatistics *reviewStatistics;
@property(nullable) CLLocation *deviceLocation;
@property(nonnull) NSDictionary *apiResponse;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

/// Helper to construct a CLLoation object for a store, if the latitue and
/// longitude were provided in the API response model.
- (nullable CLLocation *)getCLLocation;

/// Given a CLLocation object with latitude and longitude, get the distance in
/// meters from the current store object. Returns -1 if the store does not have
/// a location.
- (CLLocationDistance)distanceInMetersFromCurrentLocation;

/// Returns true of a valid latitude and longitude is present for this store in
/// the BVStoreLocation object.
- (BOOL)hasGeoLoation;

@end
