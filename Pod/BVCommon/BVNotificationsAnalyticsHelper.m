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

static BVNotificationsAnalyticsHelper *analyticsSingleton = nil;

+ (BVNotificationsAnalyticsHelper *) instance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        analyticsSingleton = [[self alloc] init];
    });
    
    return analyticsSingleton;
}

- (id) init {
    self = [super init];
    return self;
}


- (void)queueAnalyticEventForStoreReviewNotificationInView:(NSString *)viewName withStoreId:(NSString *)storeId{
    
    NSMutableDictionary *eventDict = [NSMutableDictionary dictionaryWithDictionary:[self getFeatureUsedInViewParams]];
    [eventDict setObject:storeId forKey:@"productId"];
    [eventDict setObject:viewName forKey:@"detail1"];
    [eventDict setObject:@"store" forKey:@"detail2"];
    [eventDict setObject:@"RatingsAndReviews" forKey:@"bvProduct"];
    [[BVAnalyticsManager sharedManager] queueEvent:eventDict];
}

- (void)queueAnalyticEventForStoreReviewUsedFeature:(NSString *)actionDetail withStoreId:(NSString *)storeId{
    
    NSMutableDictionary *eventDict = [NSMutableDictionary dictionaryWithDictionary:[self getFeatureUsedParams]];
    [eventDict setObject:storeId forKey:@"productId"];
    [eventDict setObject:@"PushNotification" forKey:@"name"];
    [eventDict setObject:actionDetail forKey:@"detail1"];
    [eventDict setObject:@"store" forKey:@"detail2"];
    [eventDict setObject:@"RatingsAndReviews" forKey:@"bvProduct"];
    [[BVAnalyticsManager sharedManager] queueEvent:eventDict];
}

@end
