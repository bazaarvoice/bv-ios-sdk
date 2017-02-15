//
//  BVCurationsAnalyticsHelper.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCurationsAnalyticsHelper.h"
#import "BVCurationsFeedItem.h"
#import "BVCore.h"

@implementation BVCurationsAnalyticsHelper

static BVCurationsAnalyticsHelper *analyticsInstance = nil;

static const NSString *bvProductName = @"Curations";

+ (void)queueUGCImpressionEventForFeedItem:(BVCurationsFeedItem *)feedItem{
    
    if (!feedItem){
        return;
    }
    
    NSMutableDictionary* event = [self getUGCImpressionParams];
    
    if (feedItem.sourceClient){
        [event setObject:feedItem.sourceClient forKey:@"syndicationSource"];
    }
    if (feedItem.contentId){
        [event setObject:feedItem.contentId forKey:@"contentId"];
    }
    if (feedItem.externalId){
        [event setObject:feedItem.externalId forKey:@"productId"];
    }
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+ (void)queueUsedFeatureEventForContainerInView:(BVCurationsFeedWidget)widgetType withExternalId:(NSString *  _Nullable)externalId withWidgetId:(NSString * _Nullable)widgetId{
    
    NSMutableDictionary* event = [self getUsedFeatureParams];
    [event setObject:@"InView" forKey:@"name"];
     [event setObject:[self getFeedWidgetTypeText:widgetType] forKey:@"component"];
    if (externalId){
        [event setObject:externalId forKey:@"productId"];
    }
    if (widgetId){
        [event setObject:widgetId forKey:@"detail1"];
    }
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+ (void)queueUsedFeatureEventForWidgetScroll:(BVCurationsFeedWidget)widgetType withExternalId:(NSString *  _Nullable)externalId{
    
    NSMutableDictionary *event = [self getUsedFeatureParams];
    [event setObject:[self getFeedWidgetTypeText:widgetType] forKey:@"component"];
    [event setObject:@"Scrolled" forKey:@"name"];
    if (externalId){
        [event setObject:externalId forKey:@"productId"];
    }
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+ (void)queueUsedFeatureEventForFeedItemTapped:(BVCurationsFeedItem *)feedItem{
    
    if (!feedItem){
        return;
    }
    
    NSMutableDictionary *event = [self getUsedFeatureParams];
    [event setObject:@"ContentClick" forKey:@"name"];
    
    if (feedItem.channel){
        [event setObject:feedItem.channel forKey:@"detail1"];
    }
    if (feedItem.contentId){
        [event setObject:feedItem.contentId forKey:@"detail2"];
    }
    if (feedItem.externalId){
        [event setObject:feedItem.externalId forKey:@"productId"];
    }

    
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+ (void)queueEmbeddedPageViewEventCurationsFeed:(BVCurationsFeedWidget)widgetType withExternalId:(NSString *  _Nullable)externalId{
    
    NSMutableDictionary *event = [self getPageViewEmbeddedEventParams];
    [event setObject:[self getFeedWidgetTypeText:widgetType] forKey:@"reportingGroup"];
    if (externalId){
        [event setObject:externalId forKey:@"productId"];
    }
    [[BVAnalyticsManager sharedManager] queueEvent:event];    
}

+ (void)queueSubmissionPageView:(BVCurationsSubmissionWidget)widgetType {
    NSMutableDictionary *event = [self getBasicParamsForCL:@"PageView" type:@"Submission"];
    [event setObject:[self getSubmissionWidgetTypeText:widgetType] forKey:@"component"];
    [[BVAnalyticsManager sharedManager] queueEvent:event];
}

+ (void)queueUsedFeatureUploadPhoto:(BVCurationsSubmissionWidget)widgetType {
    NSMutableDictionary *event = [self getBasicParamsForCL:@"Feature" type:@"Used"];
    [event setObject:@"UploadPhoto" forKey:@"name"];
    [event setObject:[self getSubmissionWidgetTypeText:widgetType] forKey:@"component"];
    [[BVAnalyticsManager sharedManager] queueEvent:event];
}

+ (NSString *)getFeedWidgetTypeText:(BVCurationsFeedWidget)widgetType{
    
    switch (widgetType) {
        case BVCurationsFeedWidgetCarousel:
            return @"Carousel";
        case BVCurationsFeedWidgetTableView:
            return @"Tableview";
        case BVCurationsFeedWidgetCustom:
            return @"Custom";
        case BVCurationsFeedWidgetGrid:
            return @"Grid";
    }
}


+(NSString*)getSubmissionWidgetTypeText:(BVCurationsSubmissionWidget)widgetType {
    switch (widgetType) {
        case BVCurationsSubmissionWidgetCompose:
            return @"Compose";
        case BVCurationsSubmissionWidgetCustom:
            return @"Custom";
    }
}

+ (NSMutableDictionary*)getPageViewEmbeddedEventParams {
    return [self getBasicParamsForCL:@"PageView" type:@"Embedded"];
}

+ (NSMutableDictionary*)getUGCImpressionParams {
    NSMutableDictionary *dict = [self getBasicParamsForCL:@"Impression" type:@"UGC"];
    [dict setObject:@"socialPost" forKey:@"contentType"];
    return dict;
}

+ (NSMutableDictionary*)getUsedFeatureParams {
    return [self getBasicParamsForCL:@"Feature" type:@"Used"];

}

+ (NSMutableDictionary *)getBasicParamsForCL:(NSString*)cl type:(NSString*)type {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:cl forKey:@"cl"];
    [dict setObject:type forKey:@"type"];
    [dict setObject:bvProductName forKey:@"bvProduct"];
    [dict setObject:[[BVSDKManager sharedManager] clientId] forKey:@"client"];
    [dict setObject:@"native-mobile-sdk" forKey:@"source"];
    
    return dict;
}
@end
