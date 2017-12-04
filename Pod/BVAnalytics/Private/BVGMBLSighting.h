//
//  BVGMBLSighting.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  BVGMBLSighting is a holder object that is used to hold and pass around
 * Gimbal-based 'Sighting' events.
 */
@interface BVGMBLSighting : NSObject

@property NSInteger RSSI;
@property NSDate *date;
@property NSString *identifier;
@property NSString *name;

@end
