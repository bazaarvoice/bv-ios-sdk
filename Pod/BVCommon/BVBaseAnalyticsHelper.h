//
//  BVBaseAnalyticsHelper.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface BVBaseAnalyticsHelper : NSObject

-(NSDictionary*)getImpressionParams;
-(NSDictionary*)getPageViewParams;
-(NSDictionary*)getFeatureUsedParams;
-(NSDictionary*)getFeatureUsedInViewParams;

@end
