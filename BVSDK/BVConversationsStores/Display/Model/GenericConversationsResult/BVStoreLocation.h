//
//  BVStoreLocation.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import <Foundation/Foundation.h>

/**
 A BVStoreLocation object is used to define the geo-location attributes of a
 BVStore object.
 */
@interface BVStoreLocation : NSObject

@property(nullable) NSString *latitude;
@property(nullable) NSString *longitude;
@property(nullable) NSString *address;
@property(nullable) NSString *city;
@property(nullable) NSString *state;
@property(nullable) NSString *country;
@property(nullable) NSString *postalcode;
@property(nullable) NSString *phone;

- (nullable id)initWithStoreAtrributes:(nonnull NSDictionary *)attributes;

@end
