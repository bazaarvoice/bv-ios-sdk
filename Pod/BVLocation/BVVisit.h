//
//  BVVisit.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface BVVisit : NSObject

- (id)initWithName:(NSString *)name
           address:(NSString *)address
              city:(NSString *)city
             state:(NSString *)state
           zipCode:(NSString *)zipCode
           storeId:(NSString *)storeId
       arrivalDate:(NSDate *)arrivalDate
     departureDate:(NSDate *)departureDate;

@property(nonatomic, strong, readonly) NSString *name;
@property(nonatomic, strong, readonly) NSString *address;
@property(nonatomic, strong, readonly) NSString *city;
@property(nonatomic, strong, readonly) NSString *state;
@property(nonatomic, strong, readonly) NSString *zipCode;
@property(nonatomic, strong, readonly) NSString *storeId;
@property(nonatomic, strong, readonly) NSDate *arrivalDate;
@property(nonatomic, strong, readonly) NSDate *departureDate;

@end
