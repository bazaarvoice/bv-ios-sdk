//
//  BVNotificationsAnalyticsHelper.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "BVBaseAnalyticsHelper.h"

@interface BVNotificationsAnalyticsHelper : BVBaseAnalyticsHelper

/// Singleton pattern.
+ (BVNotificationsAnalyticsHelper *) instance;

- (void)queueAnalyticEventForStoreReviewNotificationInView:(NSString *)viewName withStoreId:(NSString *)storeId;

- (void)queueAnalyticEventForStoreReviewUsedFeature:(NSString *)actionDetail withStoreId:(NSString *)storeId;

@end
