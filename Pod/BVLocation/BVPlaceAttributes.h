//
//  BVPlaceAttributes.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLACE_TYPE_KEY @"type"
#define PLACE_CLIENT_ID @"clientId"
#define PLACE_NAME @"name"
#define PLACE_CITY @"city"
#define PLACE_STATE @"state"
#define PLACE_ZIP @"zip"
#define PLACE_STORE_ID @"storeId"
#define PLACE_ADDRESS @"address"
#define ARRIVAL_DATE @"arrivalDate"
#define DEPARTURE_DATE @"departureDate"

typedef enum { PlaceTypeGeofence, PlaceTypeBeacon, PlaceTypeUnkown } PlaceType;

@interface BVPlaceAttributes : NSObject

+ (PlaceType)typeFromString:(NSString *)typeString;

@end
