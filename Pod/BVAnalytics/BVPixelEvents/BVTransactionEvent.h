//
//  BVTransactionEvent.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVAnalyticEvent.h"
#import "BVBasePIIEvent.h"
#import "BVTransactionItem.h"
#import <Foundation/Foundation.h>

#define TRANSACTION_SCHEMA @{@"cl" : @"Conversion", @"type" : @"Transaction"}
#define TRANSACTION_SCHEMA_PII                                                 \
  @{@"cl" : @"PIIConversion", @"type" : @"Transaction"}

/**
  The trackConversionTransaction event should execute once the user has
  completed a purchase. This will often be after a payment has been processed or
  when loading of a payment confirmation view.
*/
@interface BVTransactionEvent : BVBasePIIEvent <BVAnalyticEvent>

/**
@param orderId Required - The unique Id of the order.
@param total Required - The total amount of the order.
@param items Required - [BVTransactionItem] -An array of the individual items in
the order.
@param params Optional - Used to define any other transaction parameters such as
user email.

@return the event object that can be used to submit to Bazaarvoice via the
BVPixel API.
 */
- (nonnull id)initWithOrderId:(nonnull NSString *)orderId
                   orderTotal:(double)total
                   orderItems:(nonnull NSArray *)items
               andOtherParams:(nullable NSDictionary *)params;

- (nonnull instancetype)__unavailable init;

/**
 Creates a raw dictionary event that removes any possibly personally
 identifiable information. These events are fine to send with IDFA.

 @return The fully created event that can be sent to Bazaarvoice Analytics.
 */
- (nonnull NSDictionary *)toRawNonPII;

/// The unique Id of the order.
@property(nonnull, nonatomic, strong, readonly) NSString *orderId;

/// The total amount of the order.
@property(nonatomic, assign, readonly) double total;

/// [BVTransactionItem] - An array of the individual items in the order.
@property(nonnull, nonatomic, strong, readonly)
    NSArray<BVTransactionItem *> *items;

/// The tax amount of the order.
@property(nonatomic, assign) double tax;

/// The shipping cost of the order.
@property(nonatomic, assign) double shipping;

/// The user's city
@property(nullable, nonatomic, strong) NSString *city;

/// The user's state
@property(nullable, nonatomic, strong) NSString *state;

/// The user's country
@property(nullable, nonatomic, strong) NSString *country;

/// The currency used of the order.
/// ISO 4217 alphabetic currency code.
@property(nullable, nonatomic, strong) NSString *currency;

@end
