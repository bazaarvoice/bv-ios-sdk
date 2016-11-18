//
//  BVNotificationsAnalyticsHelper.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVNotificationsAnalyticsHelper.h"
#import "BVAnalyticsManager.h"

@implementation BVNotificationsAnalyticsHelper

+(void)queueAnalyticEventForReviewNotificationInView:(NSString *)viewName withId:(NSString *)Id andProductType:(ProductType)type{
    
    NSMutableDictionary *eventDict = [NSMutableDictionary dictionaryWithDictionary:[self getFeatureUsedInViewParams]];
    [eventDict addEntriesFromDictionary:[self getCommonParams:Id type:type]];
    [eventDict setObject:viewName forKey:@"detail1"];
    [[BVAnalyticsManager sharedManager] queueEvent:eventDict];
}

+(void)queueAnalyticEventForReviewUsedFeature:(NSString *)actionDetail withId:(NSString *)Id andProductType:(ProductType)type{
    
    NSMutableDictionary *eventDict = [NSMutableDictionary dictionaryWithDictionary:[self getFeatureUsedParams]];
    [eventDict addEntriesFromDictionary:[self getCommonParams:Id type:type]];
    [eventDict setObject:@"PushNotification" forKey:@"name"];
    [eventDict setObject:actionDetail forKey:@"detail1"];
    [[BVAnalyticsManager sharedManager] queueEvent:eventDict];
}

+(NSDictionary*)getCommonParams:(NSString*)Id type:(ProductType)type {
    NSMutableDictionary *eventDict = [NSMutableDictionary new];
    [eventDict setObject:Id forKey:@"productId"];
    [eventDict setObject:@"RatingsAndReviews" forKey:@"bvProduct"];
    if (type == ProductTypeStore) {
        [eventDict setObject:@"store" forKey:@"detail2"];
    }else {
        [eventDict setObject:@"product" forKey:@"detail2"];
    }
    return eventDict;
}

@end
