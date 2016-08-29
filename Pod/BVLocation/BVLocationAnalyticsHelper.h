//
//  BVLocationAnalyticsHelper.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GMBLVisit;

@interface BVLocationAnalyticsHelper : NSObject

+ (void)queueAnalyticsEventForGimbalVisit:(GMBLVisit *)visit;

@end
