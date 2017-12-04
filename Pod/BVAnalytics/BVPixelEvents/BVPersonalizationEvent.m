//
//  BVPersonalizationEvent.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVPersonalizationEvent.h"
#import "BVAnalyticEventManager.h"

@implementation BVPersonalizationEvent

@synthesize additionalParams;

- (nonnull id)initWithUserAuthenticationString:(nonnull NSString *)uas {

  self = [super init];
  if (self) {

    _uas = uas;
  }

  return self;
}

- (NSDictionary *)toRaw {

  NSMutableDictionary *eventDict = [NSMutableDictionary
      dictionaryWithObjectsAndKeys:self.uas, @"profileId", nil];

  [eventDict addEntriesFromDictionary:PERSONALIZATION_SCHEMA];
  [eventDict addEntriesFromDictionary:[[BVAnalyticEventManager sharedManager]
                                          getCommonAnalyticsDictAnonymous:NO]];
  [eventDict addEntriesFromDictionary:@{@"source" : @"ProfileMobile"}];

  return eventDict;
}

@end
