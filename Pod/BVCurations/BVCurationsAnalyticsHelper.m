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
    
    NSMutableDictionary* event = [NSMutableDictionary dictionaryWithDictionary:[self getUGCImpressionParams]];
    
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
    
    NSMutableDictionary* event = [NSMutableDictionary dictionaryWithDictionary:[self getUsedFeatureParams]];
    [event setObject:@"InView" forKey:@"name"];
     [event setObject:[self getWidgetTypeText:widgetType] forKey:@"component"];
    if (externalId){
        [event setObject:externalId forKey:@"productId"];
    }
    if (widgetId){
        [event setObject:widgetId forKey:@"detail1"];
    }
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+ (void)queueUsedFeatureEventForWidgetScroll:(BVCurationsFeedWidget)widgetType withExternalId:(NSString *  _Nullable)externalId{
    
    NSMutableDictionary *event = [NSMutableDictionary dictionaryWithDictionary:[self getUsedFeatureParams]];
    [event setObject:[self getWidgetTypeText:widgetType] forKey:@"component"];
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
    
    NSMutableDictionary *event = [NSMutableDictionary dictionaryWithDictionary:[self getUsedFeatureParams]];
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
    
    NSMutableDictionary *event = [NSMutableDictionary dictionaryWithDictionary:[self getPageViewEmbeddedEventParams]];
    [event setObject:[self getWidgetTypeText:widgetType] forKey:@"reportingGroup"];
    if (externalId){
        [event setObject:externalId forKey:@"productId"];
    }
    [[BVAnalyticsManager sharedManager] queueEvent:event];    
}


+ (NSString *)getWidgetTypeText:(BVCurationsFeedWidget)widgetType{
    
    switch (widgetType) {
        case CurationsFeedCarousel:
            return @"Carousel";
        case CurationsFeedTableView:
            return @"Tableview";
        case CurationsFeedCustom:
            return @"Custom";
    }
    
}


+ (NSDictionary*)getPageViewEmbeddedEventParams {
    
    return @{
             @"cl": @"PageView",
             @"type": @"Embedded",
             @"source": @"native-mobile-sdk",
             @"client": [[BVSDKManager sharedManager] clientId],
             @"bvProduct": bvProductName
             };
}

+ (NSDictionary*)getUGCImpressionParams {
    return @{
             @"cl": @"Impression",
             @"type": @"UGC",
             @"source": @"native-mobile-sdk",
             @"contentType" : @"socialPost",
             @"client": [[BVSDKManager sharedManager] clientId],
             @"bvProduct": bvProductName
             };
}

+ (NSDictionary*)getUsedFeatureParams {
    return @{
             @"cl": @"Feature",
             @"type": @"Used",
             @"source": @"native-mobile-sdk",
             @"client": [[BVSDKManager sharedManager] clientId],
             @"bvProduct": bvProductName
             };
}


@end
