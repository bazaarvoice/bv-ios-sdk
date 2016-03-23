//
//  BVRecsAnalyticsHelper.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVRecsAnalyticsHelper.h"
#include <sys/sysctl.h>
#include <sys/utsname.h>


@implementation BVRecsAnalyticsHelper

static BVRecsAnalyticsHelper *analyticsInstance = nil;

static const NSString *bvProductName = @"Recommendations";

+(NSDictionary *)getRelavantInfoForRecommendationType:(BVProduct *)product isVisible:(BOOL)visible {
    
    NSDictionary* analyticValues = [self getPrivateAnalyticInfoForProduct:product];
    
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
             @"source": @"recommendation-mob",
             @"client": [[BVSDKManager sharedManager] clientId],
             @"bvProduct": bvProductName
             };
}

+(NSDictionary*)getUsedFeatureParams {
    return @{
             @"cl": @"Feature",
             @"type": @"Used",
             @"source": @"recommendation-mob",
             @"client": [[BVSDKManager sharedManager] clientId],
             @"bvProduct": bvProductName
             };
}

+ (NSDictionary*)getPageViewEmbeddedEventParams {
    return @{
             @"cl": @"PageView",
             @"type": @"Embedded",
             @"source": @"recommendation-mob",
             @"client": [[BVSDKManager sharedManager] clientId],
             @"bvProduct": bvProductName
             };
}

+ (NSDictionary *)getFieldForWidgetType:(BVProductRecommendationWidget)widgetType{
    
    switch (widgetType) {
        case RecommendationsCarousel:
            return @{@"component" : @"carousel"};
        case RecommendationsTableView:
            return @{@"component" : @"tableview"};
        case RecommendationsCustom:
            return @{@"component" : @"custom"};
    }
    
}


+ (NSString *)getWidgetTypeString:(BVProductRecommendationWidget)widgetType{
    
    switch (widgetType) {
        case RecommendationsCarousel:
            return @"carousel";
        case RecommendationsTableView:
            return @"tableview";
        case RecommendationsCustom:
            return @"custom";
    }
    
}

+(NSDictionary*)getRecommendationContainerType:(NSDictionary *)productRec {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:[self getRecommendationParams]];
    [parameters addEntriesFromDictionary:productRec];
    return parameters;
    
}


+(void)queueAnalyticsEventForProductView:(BVProduct *)product{
    
    if (!product){
        return;
    }
    
    NSMutableDictionary* event = [NSMutableDictionary dictionaryWithDictionary:[self getRelavantInfoForRecommendationType:product isVisible:YES]];
    [event addEntriesFromDictionary:[self getRecommendationParams]];
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+ (void)queueAnalyticsEventForRecommendationsOnPage:(BVProductRecommendationWidget)widgetType{
    
    NSMutableDictionary* event = [NSMutableDictionary dictionaryWithDictionary:[self getUsedFeatureParams]];
    [event addEntriesFromDictionary:[self getFieldForWidgetType:widgetType]];
    [event setObject:@"InView" forKey:@"name"];
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}



+ (void)queueAnalyticsEventForWidgetScroll:(BVProductRecommendationWidget)widgetType{
    
    NSMutableDictionary *event = [NSMutableDictionary dictionaryWithDictionary:[self getUsedFeatureParams]];
    [event addEntriesFromDictionary:[self getFieldForWidgetType:widgetType]];
    [event setObject:@"Scrolled" forKey:@"name"];
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+ (void)queueAnalyticsEventForProductTapped:(BVProduct *)product{
    
    if (!product){
        return;
    }

    NSMutableDictionary *event = [NSMutableDictionary dictionaryWithDictionary:[self getUsedFeatureParams]];
    [event addEntriesFromDictionary:[self getRelavantInfoForRecommendationType:product isVisible:true]];
    [event setObject:@"ContentClick" forKey:@"name"];
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}


+ (void)queueEmbeddedRecommendationsPageViewEvent:(BVRecommendationsRequest *)recommendationsRequest
                                   withWidgetType:(BVProductRecommendationWidget)widgetType {
    
    NSMutableDictionary* event = [NSMutableDictionary dictionary];
    
    [event addEntriesFromDictionary:[self getPageViewEmbeddedEventParams]];
    [event setObject:[self getWidgetTypeString:widgetType] forKey:@"reportingGroup"];
    [event setValue:recommendationsRequest.productId forKey:@"productId"];
    [event setValue:recommendationsRequest.categoryId forKey:@"categoryId"];
    
    [[BVAnalyticsManager sharedManager] queueEvent:event];
    
}

+(NSDictionary*)getPrivateAnalyticInfoForProduct:(BVProduct*)product {
        
    NSMutableDictionary* productAnalytics = [NSMutableDictionary dictionary];
    
    if (product.rawProductDict){
        
        for (NSString* key in @[@"RKB", @"RKI", @"RKP", @"RKT", @"RKC"]) {
            
            if ([product.rawProductDict objectForKey:key] != nil){
                NSNumber* value = @([[product.rawProductDict objectForKey:key] integerValue]);
                [productAnalytics setObject:value forKey:key];
            }
            
        }
        
    }
    
    NSString* rs = [product.rawProductDict objectForKey:@"RS"];
    [productAnalytics setObject:rs ? rs : [NSNull null] forKey:@"RS"];
    
    return productAnalytics;
    
}

@end
