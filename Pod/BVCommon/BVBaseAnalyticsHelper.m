//
//  BVBaseAnalyticsHelper.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVBaseAnalyticsHelper.h"

@implementation BVBaseAnalyticsHelper

-(NSDictionary*)getImpressionParams {
    return @{
             @"cl": @"Impression",
             @"type": @"UGC",
             @"source": @"native-mobile-sdk"
             };
}

-(NSDictionary*)getPageViewParams {
    return @{
             @"cl": @"PageView",
             @"type": @"Product",
             @"source": @"native-mobile-sdk"
             };
}


-(NSDictionary*)getFeatureUsedParams {
    return @{
             @"cl": @"Feature",
             @"type": @"Used",
             @"source": @"native-mobile-sdk"
             };
}

-(NSDictionary*)getFeatureUsedInViewParams {
    return @{
             @"cl": @"Feature",
             @"type": @"Used",
             @"name": @"InView",
             @"source": @"native-mobile-sdk"
             };
}

@end
