//
//  BVStoreLocation.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVStoreLocation.h"

@implementation BVStoreLocation

- (nullable id)initWithStoreAtrributes:(nonnull NSDictionary *)attributes {

  self = [super init];
  if (self) {
    self.longitude =
        [self getValueForKey:@"Longitude" withDictionary:attributes];
    self.latitude = [self getValueForKey:@"Latitude" withDictionary:attributes];
    self.country = [self getValueForKey:@"Country" withDictionary:attributes];
    self.city = [self getValueForKey:@"City" withDictionary:attributes];
    self.postalcode =
        [self getValueForKey:@"PostalCode" withDictionary:attributes];
    self.phone = [self getValueForKey:@"Phone" withDictionary:attributes];
    self.address = [self getValueForKey:@"Address" withDictionary:attributes];
    self.state = [self getValueForKey:@"State" withDictionary:attributes];
  }
  return self;
}

- (nullable NSString *)getValueForKey:(NSString *)key
                       withDictionary:(NSDictionary *)dict {
  NSString *value;

  if ([dict objectForKey:key]) {
    NSArray *valuesArray = [[dict objectForKey:key] objectForKey:@"Values"];
    if (valuesArray && valuesArray.count) {
      value = [valuesArray[0] objectForKey:@"Value"];
    }
  }

  return value;
}

@end
