//
//  BVGMBLPlace.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  BVGMBLVisit is a holder object that is used to hold and pass around Gimbal-based 'Visit' events.
 */
@interface BVGMBLVisit : NSObject

@property NSDate* arrivalDate;
@property NSTimeInterval dwellTime;
@property NSDate* departureDate;
@property NSString* identifier;
@property NSString* name;

@end
