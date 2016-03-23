//
//  BVConversion.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>

/// Container class with convenience initializer for required, suggested, and custom parameters for Non-Transactional Conversion events.
@interface BVConversion : NSObject

/**
    @param type Required - The type of conversion that is taking place.
    @param value Required - The total amount of the order.
    @param label Optional - A descriptive label to apply to the conversion.
    @param params Optional - Used to define any other conversion parameters such as user email.
 */
-(id _Nonnull)initWithType:(NSString* _Nonnull)type value:(NSString* _Nonnull)value label:(NSString* _Nullable)label otherParams:(NSDictionary* _Nullable)params;


/// The type of conversion that is taking place.
@property (nonatomic, strong, readonly) NSString* _Nonnull type;


/// The total amount of the order.
@property (nonatomic, strong, readonly) NSString* _Nonnull value;


/// A descriptive label to apply to the conversion.
@property (nonatomic, strong, readonly) NSString* _Nonnull label;


/// Other conversion parameters such as user email.
@property (nonatomic, strong, readonly) NSDictionary* _Nullable otherParams;


@end
