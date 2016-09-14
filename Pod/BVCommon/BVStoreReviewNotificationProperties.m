//
//  BVStoreReviewNotificationProperties.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVStoreReviewNotificationProperties.h"
#import "BVNullHelper.h"

@implementation BVStoreReviewNotificationProperties

- (id)init{
    
    self = [super init];
    
    // TODO: Suitable defaults if not remote config?
    
    return self;
}


- (id)initWithDictionary:(NSDictionary *)configDict{
    
    self = [self init];
    
    SET_IF_NOT_NULL(_requestReviewOnAppOpen, [[configDict objectForKey:@"requestReviewOnAppOpen"] boolValue]);
    SET_IF_NOT_NULL(_notificationsEnabled, [[configDict objectForKey:@"notificationsEnabled"] boolValue]);
    
    if ([configDict objectForKey:@"visitDuration"] != nil) {
        _visitDuration = [[configDict objectForKey:@"visitDuration"] integerValue];
    } else {
        _visitDuration = 300; // Default 5 minutes
    }
    
    if ([configDict objectForKey:@"notificationDelay"]) {
        _notificationDelay = [[configDict objectForKey:@"notificationDelay"] integerValue];
    }
    
    if ([configDict objectForKey:@"reviewRemindLaterDuration"]) {
        _remindMeLaterDuration = [[configDict objectForKey:@"reviewRemindLaterDuration"] integerValue];
    }
    
    SET_IF_NOT_NULL(_reviewPromtDispayText, [configDict objectForKey:@"reviewPromptDisplayText"]);
    SET_IF_NOT_NULL(_reviewPromptSubtitleText, [configDict objectForKey:@"reviewPromptSubtitleText"]);
    SET_DEFAULT_IF_NULL(_reviewPromptYesReview, [configDict objectForKey:@"reviewPromptYesReview"],  @"Leave Review Now");
    SET_DEFAULT_IF_NULL(_reviewPromtNoReview, [configDict objectForKey:@"reviewPromtNoReview"], @"Remind Me Later");
    SET_DEFAULT_IF_NULL(_reviewPromptRemindText, [configDict objectForKey:@"reviewPromptRemindText"], @"No Thanks.");
    SET_IF_NOT_NULL(_customUrlScheme, [configDict objectForKey:@"urlScheme"]);

    SET_IF_NOT_NULL(_defaultStoreImageUrl, [configDict objectForKey:@"defaultStoreImageUrl"]);
    
    if ([configDict objectForKey:@"allowableTimePeriodStart"]){
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        comps.hour = 17;
        comps.minute = 0;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone: [NSTimeZone systemTimeZone]];
        _allowableTimePeriodStart = [calendar dateFromComponents:comps];
    }
    
    if ([configDict objectForKey:@"allowableTimePeriodEnd"]){
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        comps.hour = 19;
        comps.minute = 0;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone: [NSTimeZone systemTimeZone]];
        _allowableTimePeriodEnd = [calendar dateFromComponents:comps];
    }
    
    return self;
}

@end
