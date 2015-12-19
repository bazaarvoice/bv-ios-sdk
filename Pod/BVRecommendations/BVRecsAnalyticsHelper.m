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

+(NSDictionary *)getRelavantInfoForRecommendationType:(BVProduct *)product isVisible:(BOOL)visible {
    
    return @{
             @"bvProduct": @"ProductRecommendations",
             @"productId": product.product_id,
             @"brand" : product.client,
             @"sponsored" : [product.sponsored boolValue] ? @"true" : @"false",
             @"visible": visible ? @"true" : @"false",
             @"RKP": ((product.RKP) ? [product.RKP stringValue] : @""),
             @"RKI": ((product.RKP) ? [product.RKI stringValue] : @""),
             @"RKB": ((product.RKP) ? [product.RKB stringValue] : @""),
             @"RS": ((product.RS) ? product.RS : @"")
             };
}

+(NSDictionary*)getRecommendationParams {
    return @{
             @"cl": @"Impression",
             @"type": @"RecommendationMobile"
             };
}

+(NSDictionary*)getUsedFeatureParams {
    return @{
             @"cl": @"Feature",
             @"type": @"Used",
             };
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
            featureUsedDict = [NSDictionary dictionaryWithObjectsAndKeys:@"recommendationconversion", @"name",
                               @"shopnowbutton", @"detail1",
                               nil];
            break;
        case TapRatingsReviews:
            featureUsedDict = [NSDictionary dictionaryWithObjectsAndKeys:@"recommendationconversion", @"name",
                               @"ratingsreview", @"detail1",
                               nil];
            break;
        case TapProduct:
            featureUsedDict = [NSDictionary dictionaryWithObjectsAndKeys:@"recommendationconversion", @"name",
                               @"productimage", @"detail1",
                               nil];
            break;
        default:
            break;
    }
    
    return featureUsedDict;
    
}

+(NSDictionary*)getRecommendationImpressionEvent:(NSDictionary *)productRec {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:[self getRecommendationParams]];
    [parameters addEntriesFromDictionary:productRec];
    
    return parameters;
}


+(void)createAnalyticsRecommendationEventFromProfile:(BVShopperProfile *)profile{
    
    if (profile != nil){
        
        // Create and queue a recommendation impression event
        for (BVProduct *product in profile.recommendations){
            
            NSMutableDictionary* resultInfo = [NSMutableDictionary dictionaryWithDictionary:[self getRelavantInfoForRecommendationType:product isVisible:NO]];
            
            if (resultInfo != nil){
                BVAnalyticsManager *bvAnalyticsInstance = [BVAnalyticsManager sharedManager];
                [resultInfo addEntriesFromDictionary:[bvAnalyticsInstance getMobileDiagnosticParams]];
                [bvAnalyticsInstance queueEvent:[self getRecommendationImpressionEvent:resultInfo]];
            }
            
        }
        
    }
    
}

+(void)queueAnalyticsEventForProdctView:(BVProduct *)product{
    
    if (!product){
        return;
    }
    
    NSMutableDictionary* resultInfo = [NSMutableDictionary dictionaryWithDictionary:[self getRelavantInfoForRecommendationType:product isVisible:YES]];
    if (resultInfo != nil){
        BVAnalyticsManager *bvAnalyticsInstance = [BVAnalyticsManager sharedManager];
        [resultInfo addEntriesFromDictionary:[bvAnalyticsInstance getMobileDiagnosticParams]];
        [[BVAnalyticsManager sharedManager] queueEvent:[self getRecommendationImpressionEvent:resultInfo]];
    }
    
}


+ (void)queueAnalyticsEventForProductFeatureUsed:(BVProduct *)product withFeatureUsed:(BVProductFeatureUsed)featureUsed{
    
    if (!product){
        return;
    }
    
    BVAnalyticsManager *bvAnalyticsInstance = [BVAnalyticsManager sharedManager];

    NSMutableDictionary *resultInfo = [NSMutableDictionary dictionaryWithDictionary:[self getUsedFeatureParams]];
    [resultInfo addEntriesFromDictionary:[self getRelavantInfoForRecommendationType:product isVisible:true]];
    [resultInfo addEntriesFromDictionary:[self getFieldsForFeatureUsed:featureUsed]];
    [bvAnalyticsInstance queueEvent:[self getRecommendationImpressionEvent:resultInfo]];
    
}

@end
