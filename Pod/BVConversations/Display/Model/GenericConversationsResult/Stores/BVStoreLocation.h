//
//  BVStoreLocation.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import <Foundation/Foundation.h>

/**
 A BVStoreLocation object is used to define the geo-location attributes of a BVStore object.
 */
@interface BVStoreLocation : NSObject

@property NSString* _Nullable latitude;
@property NSString* _Nullable longitude;
@property NSString* _Nullable address;
@property NSString* _Nullable city;
@property NSString* _Nullable state;
@property NSString* _Nullable country;
@property NSString* _Nullable postalcode;
@property NSString* _Nullable phone;
    
-(id _Nullable)initWithStoreAtrributes:(NSDictionary * _Nonnull)attributes;

@end
