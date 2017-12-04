//
//  BVPixel.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <AdSupport/AdSupport.h>

#import "BVAnalyticsManager.h"
#import "BVPixel.h"

@implementation BVPixel

+ (void)trackEvent:(nonnull id<BVAnalyticEvent>)event {

  if ([event isKindOfClass:[BVConversionEvent class]]) {
    BVConversionEvent *conversion = (BVConversionEvent *)event;
    if ([conversion hasPII]) {
      [[BVAnalyticsManager sharedManager]
          queueAnonymousEvent:[conversion toRaw]];
    }

    [[BVAnalyticsManager sharedManager] queueEvent:[conversion toRawNonPII]];

  } else if ([event isKindOfClass:[BVTransactionEvent class]]) {
    BVTransactionEvent *transaction = (BVTransactionEvent *)event;
    if ([transaction hasPII]) {
      [[BVAnalyticsManager sharedManager]
          queueAnonymousEvent:[transaction toRaw]];
    }

    [[BVAnalyticsManager sharedManager] queueEvent:[transaction toRawNonPII]];

  } else if ([event isKindOfClass:[BVPersonalizationEvent class]]) {
    [[BVAnalyticsManager sharedManager] queueEvent:[event toRaw]];
    [[BVAnalyticsManager sharedManager] flushQueue];
  } else if ([event isKindOfClass:[BVPageViewEvent class]]) {
    [[BVAnalyticsManager sharedManager] queuePageViewEventDict:[event toRaw]];
  } else {
    [[BVAnalyticsManager sharedManager] queueEvent:[event toRaw]];
  }
}

@end
