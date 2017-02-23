//
//  BVConversionEvent.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "BVAnalyticEvent.h"
#import "BVBasePIIEvent.h"

#define CONVERSION_SCHEMA   @{@"cl": @"Conversion"}
#define CONVERSION_SCHEMA_PII   @{@"cl": @"PIIConversion"}

/**
 Known as a non-eCommerce conversion, this analytic event should be performed when an action such as the following takes place:
 
 • Registering a user
 • Signing up for a subscription (paid or free)
 • Downloading trial software, a whitepaper, or something else. This presumably will predispose people to progress in the sales funnel
 • Requesting more information
 • Using a feature of an application
 • Anything else that can be unambiguously counted by a computer and that you want users to do
 
*/
 @interface BVConversionEvent : BVBasePIIEvent <BVAnalyticEvent>

/**
@param type Required - The type of conversion that is taking place.
@param value Required - The total amount of the order.
@param label Optional - A descriptive label to apply to the conversion.
@param params Optional - Used to define any other conversion parameters such as user email.
 
@return the event object that can be used to submit to Bazaarvoice via the BVPixel API.
 */
-(id _Nonnull)initWithType:(NSString* _Nonnull)type value:(NSString* _Nonnull)value label:(NSString* _Nullable)label otherParams:(NSDictionary* _Nullable)params;

- (nonnull instancetype) __unavailable init;

/**
 Creates a raw dictionary event that removes any possibly personally identifiable information. These events are fine to send with IDFA.
 
 @return The fully created event that can be sent to Bazaarvoice Analytics.
 */
- (NSDictionary * _Nonnull)toRawNonPII;


/// The type of conversion that is taking place.
@property (nonatomic, strong, readonly) NSString* _Nonnull type;


/// The total amount of the order.
@property (nonatomic, strong, readonly) NSString* _Nonnull value;


/// A descriptive label to apply to the conversion.
@property (nonatomic, strong, readonly) NSString* _Nonnull label;


@end
