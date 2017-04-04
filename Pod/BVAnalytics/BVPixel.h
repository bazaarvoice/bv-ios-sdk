//
//  BVPixel.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVAnalyticEvent.h"  // All events implement for of BVAnalyticEvent

// Event types that can be tracked.
#import "BVTransactionEvent.h"
#import "BVConversionEvent.h"
#import "BVFeatureUsedEvent.h"
#import "BVPageViewEvent.h"
#import "BVImpressionEvent.h"
#import "BVInViewEvent.h"
#import "BVImpressionEvent.h"
#import "BVPersonalizationEvent.h"
#import "BVViewedCGCEvent.h"

/// Static class used to queue Conversion events
@interface BVPixel : NSObject


/**
 Adds the event to be queued for upload.

 @param event The type of <BVAnalyticEvent> to be tracked (e.g. BVPageViewEvent, BVImpressionEvent)
 */
+(void)trackEvent:(_Nonnull id<BVAnalyticEvent>)event;


@end
