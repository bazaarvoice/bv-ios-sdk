//
//  BVNotificationProperties.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVNotificationProperties.h"
#import "BVLogger.h"
#import "BVNullHelper.h"

@implementation BVNotificationProperties

@synthesize reviewPromtNoReview = _reviewPromtNoReview;

- (id)initWithDictionary:(NSDictionary *)configDict {

  self = [super init];
  _configDict = configDict;
  _notificationsEnabled =
      [[configDict objectForKey:@"notificationsEnabled"] boolValue];
  if ([configDict objectForKey:@"notificationDelay"]) {
    _notificationDelay =
        [[configDict objectForKey:@"notificationDelay"] integerValue];
  }

  SET_IF_NOT_NULL(_reviewPromtDispayText,
                  [configDict objectForKey:@"reviewPromptDisplayText"]);
  SET_IF_NOT_NULL(_reviewPromptSubtitleText,
                  [configDict objectForKey:@"reviewPromptSubtitleText"]);
  SET_DEFAULT_IF_NULL(_reviewPromptYesReview,
                      [configDict objectForKey:@"reviewPromptYesReview"],
                      @"Leave Review Now");
  SET_DEFAULT_IF_NULL(_reviewPromtNoReview,
                      [configDict objectForKey:@"reviewPromtNoReview"],
                      @"No Thanks.");
  SET_DEFAULT_IF_NULL(_reviewPromptRemindText,
                      [configDict objectForKey:@"reviewPromptRemindText"],
                      @"Remind Me Later");
  SET_IF_NOT_NULL(_customUrlScheme, [configDict objectForKey:@"urlScheme"]);

  _requestReviewOnAppOpen =
      [[configDict objectForKey:@"requestReviewOnAppOpen"] boolValue];

  if ([configDict objectForKey:@"visitDuration"]) {
    _visitDuration = [[configDict objectForKey:@"visitDuration"] integerValue];
  } else {
    _visitDuration = 300; // Default 5 minutes
  }

  if ([configDict objectForKey:@"reviewRemindLaterDuration"]) {
    _remindMeLaterDuration =
        [[configDict objectForKey:@"reviewRemindLaterDuration"] integerValue];
  }

  if ([configDict objectForKey:@"allowableTimePeriodStart"]) {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.hour = 17;
    comps.minute = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    _allowableTimePeriodStart = [calendar dateFromComponents:comps];
  }

  if ([configDict objectForKey:@"allowableTimePeriodEnd"]) {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.hour = 19;
    comps.minute = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    _allowableTimePeriodEnd = [calendar dateFromComponents:comps];
  }

  return self;
}
@end
