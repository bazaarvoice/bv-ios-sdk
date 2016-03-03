//
//  BVConversationsAnalyticsHelper.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BVGet.h"
#import "BVPost.h"
#import "BVMediaPost.h"
#import "BVSettings.h"

/*!
 BVAnalytics is a singleton object which queues, batches, and handles analytics event requests.
 */
@interface BVConversationsAnalyticsHelper : NSObject

/*!
 Static accessor method.
 */
+ (BVConversationsAnalyticsHelper *) instance;

/*!
 Add an analytics event for the event queue.
 The events are queued up so that they can be sent off in a batched request to save network traffic.
 Queue flushing is also delayed and set on a background thread to minimize any interferance with more important network traffic.
 @param response JSON-deserialized response from the Bazaarvoice Converstaions API.
 @param sender The BVSDK class that created the network request. Ex: BVGet, BVPost, etc.
 */
-(void)queueAnalyticsEventForResponse:(NSDictionary*)response forRequest:(id)sender;

/*!
 Add an analytics event for the event queue when the user POSTs review UGC.
 The events are queued up so that they can be sent off in a batched request to save network traffic.
 Queue flushing is also delayed and set on a background thread to minimize any interferance with more important network traffic.
 @param postObj Data for the POST.
 */
-(void)queueAnalyticsEventForFeatureUsed:(BVPost *)postObj;


/*!
 Add an analytics event for the event queue when the user POSTs a photo or video UGC.
 The events are queued up so that they can be sent off in a batched request to save network traffic.
 Queue flushing is also delayed and set on a background thread to minimize any interferance with more important network traffic.
 @param postObj Media type for the POST.
 */
-(void)queueAnalyticsEventForMediaPost:(BVMediaPost *)postObj;

@end