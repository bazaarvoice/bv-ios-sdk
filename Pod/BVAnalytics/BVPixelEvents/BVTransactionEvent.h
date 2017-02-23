//
//  BVTransactionEvent.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVTransactionItem.h"
#import "BVAnalyticEvent.h"
#import "BVBasePIIEvent.h"

#define TRANSACTION_SCHEMA   @{@"cl": @"Conversion",@"type": @"Transaction"}
#define TRANSACTION_SCHEMA_PII   @{@"cl": @"PIIConversion",@"type": @"Transaction"}

/**
  The trackConversionTransaction event should execute once the user has completed a purchase. This will often be after a payment has been processed or when loading of a payment confirmation view.
*/
@interface BVTransactionEvent : BVBasePIIEvent <BVAnalyticEvent>

/**
@param orderId Required - The unique Id of the order.
@param total Required - The total amount of the order.
@param items Required - [BVTransactionItem] -An array of the individual items in the order.
@param params Optional - Used to define any other transaction parameters such as user email.
 
@return the event object that can be used to submit to Bazaarvoice via the BVPixel API.
 */
-(id _Nonnull)initWithOrderId:(NSString* _Nonnull)orderId orderTotal:(double)total orderItems:(NSArray* _Nonnull)items andOtherParams:(NSDictionary* _Nullable)params;

- (nonnull instancetype) __unavailable init;

/**
 Creates a raw dictionary event that removes any possibly personally identifiable information. These events are fine to send with IDFA.
 
 @return The fully created event that can be sent to Bazaarvoice Analytics.
 */
- (NSDictionary * _Nonnull)toRawNonPII;

/// The unique Id of the order.
@property (nonatomic, strong, readonly) NSString* _Nonnull orderId;


/// The total amount of the order.
@property (nonatomic, assign, readonly) double total;


/// [BVTransactionItem] - An array of the individual items in the order.
@property (nonatomic, strong, readonly) NSArray<BVTransactionItem*>* _Nonnull items;


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
