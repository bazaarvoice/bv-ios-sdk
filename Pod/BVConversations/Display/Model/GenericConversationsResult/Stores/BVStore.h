//
//  BVStore.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "BVGenericConversationsResult.h"
#import "BVBrand.h"
#import "BVReviewStatistics.h"
#import "BVQAStatistics.h"
#import "BVReview.h"
#import "BVQuestion.h"
#import "BVStoreLocation.h"

/**
 A BVStore object is found within the response objects: BVBulkStoresResponse and BVStoreReviewsResponse.
 Some commonly used data in a store:
    Product page URL is included in the `productPageUrl` property. This would be the icon to display the store in your app.
    Product image URL is included in the `imageUrl` property.
    Store review statistics are included in the `reviewStatistics` property, if requested in the original request object.
    The storeLocation provides additional attributes about the store, such as geo-location and phone number.
 */
@interface BVStore : NSObject<BVGenericConversationsResult>

@property BVBrand* _Nullable brand;
@property BVStoreLocation *_Nullable storeLocation;
@property NSString* _Nullable productDescription;
@property NSDictionary* _Nullable attributes;
@property NSString* _Nullable brandExternalId;
@property NSString* _Nullable productPageUrl;
@property NSString* _Nullable imageUrl;
@property NSString* _Nullable name;
@property NSString* _Nullable categoryId;
@property NSString* _Nullable identifier;
@property BVReviewStatistics* _Nullable reviewStatistics;
@property CLLocation * _Nullable deviceLocation;
@property NSDictionary * _Nonnull apiResponse;

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse;

/// Helper to construct a CLLoation object for a store, if the latitue and longitude were provided in the API response model.
- (CLLocation * _Nullable)getCLLocation;

/// Given a CLLocation object with latitude and longitude, get the distance in meters from the current store object. Returns -1 if the store does not have a location.
- (CLLocationDistance)distanceInMetersFromCurrentLocation;

/// Returns true of a valid latitude and longitude is present for this store in the BVStoreLocation object.
- (BOOL)hasGeoLoation;

@end
