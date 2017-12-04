//
//  BVPlaceAttributes.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVPlaceAttributes.h"

@implementation BVPlaceAttributes

+ (PlaceType)typeFromString:(NSString *)typeString {
  if ([typeString isEqualToString:@"geofence"]) {
    return PlaceTypeGeofence;
  } else if ([typeString isEqualToString:@"beacon"]) {
    return PlaceTypeBeacon;
  } else {
    return PlaceTypeUnkown;
  }
}

@end
