//
//  BVNotificationsAnalyticsHelper.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVBaseAnalyticsHelper.h"
#import <Foundation/Foundation.h>

typedef enum { ProductTypeStore, ProductTypeProduct } ProductType;

@interface BVNotificationsAnalyticsHelper : BVBaseAnalyticsHelper

+ (void)queueAnalyticEventForReviewNotificationInView:(NSString *)viewName
                                               withId:(NSString *)Id
                                       andProductType:(ProductType)type;

+ (void)queueAnalyticEventForReviewUsedFeature:(NSString *)actionDetail
                                        withId:(NSString *)Id
                                andProductType:(ProductType)type;

@end
