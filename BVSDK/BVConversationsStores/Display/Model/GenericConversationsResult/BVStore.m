//
//  BVStore.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#import "BVConversationsInclude.h"
#import "BVNullHelper.h"
#import "BVStore.h"

@implementation BVStore

- (id)initWithApiResponse:(NSDictionary *)apiResponse
                 includes:(BVConversationsInclude *)includes {
  return [self initWithApiResponse:apiResponse];
}

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  self = [super init];
  if (self) {
    _apiResponse = apiResponse;
    self.brand = [[BVBrand alloc] initWithApiResponse:apiResponse[@"Brand"]];

    SET_IF_NOT_NULL(self.productDescription, apiResponse[@"Description"])
    SET_IF_NOT_NULL(self.brandExternalId, apiResponse[@"BrandExternalId"])
    SET_IF_NOT_NULL(self.productPageUrl, apiResponse[@"ProductPageUrl"])
    SET_IF_NOT_NULL(self.name, apiResponse[@"Name"])
    SET_IF_NOT_NULL(self.categoryId, apiResponse[@"CategoryId"])
    SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])
    SET_IF_NOT_NULL(self.imageUrl, apiResponse[@"ImageUrl"])
    SET_IF_NOT_NULL(self.attributes, apiResponse[@"Attributes"])

    if (self.attributes) {
      self.storeLocation =
          [[BVStoreLocation alloc] initWithStoreAtrributes:self.attributes];
    }

    self.reviewStatistics = [[BVReviewStatistics alloc]
        initWithApiResponse:apiResponse[@"ReviewStatistics"]];
  }
  return self;
}

- (nullable CLLocation *)getCLLocation {
  CGFloat storeLongitude = 0.0;
  CGFloat storeLatitute = 0.0;
  CLLocation *location = nil;

  if (self.storeLocation != nil) {
    storeLongitude = [self.storeLocation.longitude floatValue];
    storeLatitute = [self.storeLocation.latitude floatValue];
  }

  if (storeLongitude != 0.0 && storeLatitute != 0.0) {
    location = [[CLLocation alloc] initWithLatitude:storeLatitute
                                          longitude:storeLongitude];
  }

  return location;
}

- (CLLocationDistance)distanceInMetersFromCurrentLocation {
  CLLocationDistance distanceMeters = -1.0;

  CLLocation *storeLocation = [self getCLLocation];

  if (storeLocation && self.deviceLocation) {
    distanceMeters = [storeLocation distanceFromLocation:self.deviceLocation];
  }

  return distanceMeters;
}

- (BOOL)hasGeoLoation {
  BOOL hasLocation = NO;

  if (self.storeLocation != nil && self.storeLocation.longitude != nil &&
      self.storeLocation.latitude != nil) {
    hasLocation = YES;
  }

  return hasLocation;
}

@end
