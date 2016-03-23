//
//  Transaction.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVTransactionItem.h"


/// Container class with convenience initializer for required parameters for Transactional Conversion events as well as custom parameters
@interface BVTransaction : NSObject

/**
    @param orderId Required - The unique Id of the order.
    @param total Required - The total amount of the order.
    @param items Required - [BVTransactionItem] -An array of the individual items in the order.
    @param params Optional - Used to define any other transaction parameters such as user email.
 */
-(id _Nonnull)initWithOrderId:( NSString* _Nonnull )orderId orderTotal:(double)total orderItems:(NSArray* _Nonnull)items andOtherParams:(NSDictionary* _Nullable)params;


/// The unique Id of the order.
@property (nonatomic, strong, readonly) NSString* _Nonnull orderId;


/// The total amount of the order.
@property (nonatomic, assign, readonly) double total;


/// [BVTransactionItem] - An array of the individual items in the order.
@property (nonatomic, strong, readonly) NSArray<BVTransactionItem*>* _Nonnull items;


/// Other transaction parameters such as user email.
@property (nonatomic, strong, readonly) NSDictionary* _Nullable otherParams;


/// The tax amount of the order.
@property (nonatomic, assign) double tax;


/// The shipping cost of the order.
@property (nonatomic, assign) double shipping;


/// The user's city
@property (nonatomic, strong) NSString* _Nullable city;


/// The user's state
@property (nonatomic, strong) NSString* _Nullable state;


/// The user's country
@property (nonatomic, strong) NSString* _Nullable country;


/// The currency used of the order.
/// ISO 4217 alphabetic currency code.
@property (nonatomic, strong) NSString* _Nullable currency;


@end
