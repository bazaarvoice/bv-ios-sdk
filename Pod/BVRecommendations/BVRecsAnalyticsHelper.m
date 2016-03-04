//
//  BVRecsAnalyticsHelper.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVRecsAnalyticsHelper.h"
#include <sys/sysctl.h>
#include <sys/utsname.h>


@implementation BVRecsAnalyticsHelper

static const NSString *bvProductName = @"Recommendations";

+(NSDictionary *)getRelavantInfoForRecommendationType:(BVProduct *)product isVisible:(BOOL)visible {
    
    NSDictionary* analyticValues = [BVRecsAnalyticsHelper getPrivateAnalyticInfoForProduct:product];
    
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithDictionary:analyticValues];

    [info addEntriesFromDictionary:@{
                                    @"bvProduct": bvProductName,
                                    @"productId": product.productId,
                                    @"sponsored" : product.sponsored ? @"true" : @"false",
                                    @"visible": visible ? @"true" : @"false",
                                    }];
    
    return info;

}

+(NSDictionary*)getRecommendationParams {
    return @{
             @"cl": @"Impression",
             @"type": @"Recommendation",
             @"source": @"recommendation-mob"
             };
}

+(NSDictionary*)getUsedFeatureParams {
    return @{
             @"cl": @"Feature",
             @"type": @"Used",
             @"source": @"recommendation-mob"
             };
}


+(NSDictionary*)getRecommendationImpressionEvent:(NSDictionary *)productRec {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:[self getRecommendationParams]];
    [parameters addEntriesFromDictionary:productRec];
    
    return parameters;
}


+ (NSDictionary *)getFieldsForFeatureUsed:(BVProductFeatureUsed)featureUsed{
    
    NSDictionary *featureUsedDict;
    
    switch (featureUsed) {
        case TapLike:
            featureUsedDict = [NSDictionary dictionaryWithObjectsAndKeys:@"productliked", @"name", nil];
            break;
        case TapUnlike:
            featureUsedDict = [NSDictionary dictionaryWithObjectsAndKeys:@"productdisliked", @"name", nil];
            break;
        case TapShopNow:
            featureUsedDict = [NSDictionary dictionaryWithObjectsAndKeys:@"conversion", @"name", nil];
            break;
        case TapRatingsReviews:
            featureUsedDict = [NSDictionary dictionaryWithObjectsAndKeys:@"conversion", @"name", nil];
            break;
        case TapProduct:
            featureUsedDict = [NSDictionary dictionaryWithObjectsAndKeys:@"conversion", @"name", nil];
            break;
        default:
            break;
    }
    
    return featureUsedDict;
    
}

+ (NSDictionary *)getFieldForWidgetType:(BVProductRecommendationWidget)widgetType{
    
    NSDictionary *widgetTypeDict = nil;
    
    switch (widgetType) {
        case RecommendationsCarousel:
            widgetTypeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"carousel", @"component", nil];
            break;
        case RecommendationsStaticView:
            widgetTypeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"staticview", @"component", nil];
            break;
        case RecommendationsTableView:
            widgetTypeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"tableview", @"component", nil];
            break;
        case RecommendationsCustom:
            widgetTypeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"custom", @"component", nil];
            break;
        default:
            widgetTypeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"unknown", @"component", nil];
            break;
    }
    
    return widgetTypeDict;
    
}


+ (NSString *)getWidgetTypeString:(BVProductRecommendationWidget)widgetType{
    
    NSString *widgetTypeString = nil;
    
    switch (widgetType) {
        case RecommendationsCarousel:
            widgetTypeString = @"carousel";
            break;
        case RecommendationsStaticView:
            widgetTypeString = @"staticview";
            break;
        case RecommendationsTableView:
            widgetTypeString = @"tableview";
            break;
        case RecommendationsCustom:
            widgetTypeString = @"custom";
            break;
        default:
            widgetTypeString = @"unknown";
            break;
    }
    
    return widgetTypeString;
    
}

+(NSDictionary*)getRecommendationContainerType:(NSDictionary *)productRec {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:[self getRecommendationParams]];
    [parameters addEntriesFromDictionary:productRec];
    
    return parameters;
}


+(void)queueAnalyticsEventForProdctView:(BVProduct *)product{
    
    if (!product){
        return;
    }
    
    NSMutableDictionary* resultInfo = [NSMutableDictionary dictionaryWithDictionary:[self getRelavantInfoForRecommendationType:product isVisible:YES]];
    if (resultInfo != nil){
        [[BVAnalyticsManager sharedManager] queueEvent:[self getRecommendationImpressionEvent:resultInfo]];
    }
    
}

+ (void)queueAnalyticsEventForWidgetScroll:(BVProductRecommendationWidget)widgetType{
    
    BVAnalyticsManager *bvAnalyticsInstance = [BVAnalyticsManager sharedManager];
    
    NSMutableDictionary *resultInfo = [NSMutableDictionary dictionaryWithDictionary:[self getUsedFeatureParams]];
    [resultInfo addEntriesFromDictionary:[self getFieldForWidgetType:widgetType]];
    [resultInfo setObject:@"scrolled" forKey:@"name"];
    [resultInfo setObject:bvProductName forKey:@"bvProduct"];
    
    [bvAnalyticsInstance queueEvent:resultInfo];
}

+ (void)queueAnalyticsEventForProductFeatureUsed:(BVProduct *)product withFeatureUsed:(BVProductFeatureUsed)featureUsed withWidgetType:(BVProductRecommendationWidget)widgetType{
    
    if (!product){
        return;
    }
    
    BVAnalyticsManager *bvAnalyticsInstance = [BVAnalyticsManager sharedManager];

    NSMutableDictionary *resultInfo = [NSMutableDictionary dictionaryWithDictionary:[self getUsedFeatureParams]];
    [resultInfo addEntriesFromDictionary:[self getRelavantInfoForRecommendationType:product isVisible:true]];
    [resultInfo addEntriesFromDictionary:[self getFieldsForFeatureUsed:featureUsed]];
    [resultInfo addEntriesFromDictionary:[self getFieldForWidgetType:widgetType]];
    [bvAnalyticsInstance queueEvent:[self getRecommendationImpressionEvent:resultInfo]];
    
}

+(NSDictionary*)getPageViewEmbeddedEventParams {
    return @{
             @"cl": @"PageView",
             @"type": @"Embedded",
             @"source": @"recommendation-mob"
             };
}


+ (void)queueEmbeddedRecommendationsPageViewEvent:(NSString *)productId
                                   withCategoryId:(NSString *)categoryId
                                        withClientId:(NSString *)clientId
                           withNumRecommendations:(NSInteger)numRecommendations
                                   withWidgetType:(NSString *)widgetType {
    
    BVAnalyticsManager *bvAnalyticsInstance = [BVAnalyticsManager sharedManager];
    
    NSMutableDictionary* eventData = [NSMutableDictionary dictionary];
    
    [eventData addEntriesFromDictionary:[self getPageViewEmbeddedEventParams]];
    if (productId != nil){
        [eventData setObject:productId forKey:@"productId"];
    }
    
    if (categoryId != nil){
        [eventData setObject:categoryId forKey:@"categoryId"];
    }
    
    if (clientId != nil){
        [eventData setObject:clientId forKey:@"brand"];
    }
    
    
    [eventData setObject:[NSNumber numberWithInteger:numRecommendations] forKey:@"numRecommendations"];
    
    if (widgetType != nil){
        [eventData setObject:widgetType forKey:@"reportingGroup"];
    }
    
    [eventData setObject:bvProductName forKey:@"bvProduct"];
    
    [bvAnalyticsInstance queueEvent:eventData];
    
}


+(NSDictionary*)getPrivateAnalyticInfoForProduct:(BVProduct*)product {
        
    NSMutableDictionary* productAnalytics = [NSMutableDictionary dictionary];
    
    if (product.rawProductDict){
        
        for (NSString* key in @[@"RKB", @"RKI", @"RKP", @"RKT", @"RKC"]) {
            
            if ([product.rawProductDict objectForKey:key] != nil){
                NSNumber* value = [NSNumber numberWithInteger:[[product.rawProductDict objectForKey:key] integerValue]];
                [productAnalytics setObject:value forKey:key];
            }
            
        }
        
    }
    
    NSString* rs = [product.rawProductDict objectForKey:@"RS"];
    [productAnalytics setObject:rs ? rs : [NSNull null] forKey:@"RS"];
    
    return productAnalytics;
    
}

@end
