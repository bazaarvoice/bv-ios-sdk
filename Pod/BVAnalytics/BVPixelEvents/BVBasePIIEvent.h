//
//  BVBasePIIEvent.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVAnalyticEvent.h"

@interface BVBasePIIEvent : NSObject <BVAnalyticEvent>

- (nonnull instancetype)initWithParams:(NSDictionary * _Nullable)params;

- (nonnull instancetype) __unavailable init;

/**
 Creates a raw dictionary event that removes any possibly personally identifiable information. These events are fine to send with IDFA.
 
 @param params The additional parameters added to the event creation
 
 @return The fully created event that can be sent to Bazaarvoice Analytics.
 */
-(NSDictionary * _Nonnull)getNonPII:(NSDictionary * _Nullable)params;


/**
 Does this event have PII?
 
 @return True if there are additional parameters added that are not explicitly white-listed.
 */
- (BOOL)hasPII;

-(NSString * _Nonnull)getLoadId;

@end
