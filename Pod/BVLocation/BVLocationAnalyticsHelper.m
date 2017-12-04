//
//  BVLocationAnalyticsHelper.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVLocationAnalyticsHelper.h"
#import "BVAnalyticsManager.h"
#import <Gimbal/Gimbal.h>

@implementation BVLocationAnalyticsHelper

+ (void)queueAnalyticsEventForGimbalVisit:(GMBLVisit *)visit {
  NSMutableDictionary *event = [NSMutableDictionary dictionary];
  [event setValue:@"Visit" forKey:@"type"];
  [event setValue:@"Location" forKey:@"cl"];
  [event setValue:@"native-mobile-sdk" forKey:@"source"];
  [event setValue:[visit.place.attributes stringForKey:@"id"]
           forKey:@"locationId"];

  if (visit.departureDate) {
    [event setValue:@"Exit" forKey:@"transition"];
    [event setValue:@([visit.departureDate
                        timeIntervalSinceDate:visit.arrivalDate])
             forKey:@"durationSecs"];
  } else {
    [event setValue:@"Entry" forKey:@"transition"];
  }

  [[BVAnalyticsManager sharedManager] queueEvent:event];
}

@end
