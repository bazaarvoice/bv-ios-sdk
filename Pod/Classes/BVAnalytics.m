//
//  BVAnalytics.m
//  BazaarvoiceSDK
//
//  Created by Bazaarvoice Engineering on 2/12/15.
//  Copyright (c) 2015 Bazaarvoice. All rights reserved.
//


#import "BVAnalytics.h"
#import "BVGet.h"
#import "BVRisonEncoder.h"


// type for BVGet
typedef enum {
    BVUGCImpression,
    BVProductPageview
} BVAnalyticsType;

@interface BVAnalytics()

@property (nonatomic, strong) NSTimer* analyticsTimer;
@property (nonatomic, strong) NSMutableArray* impressionQueue;
@property (nonatomic, strong) NSMutableArray* pageviewQueue;

@end


static BVAnalytics* BVAnalyticsSingleton = nil;


@implementation BVAnalytics

+ (BVAnalytics*) instance {
    if (BVAnalyticsSingleton == nil) {
        BVAnalyticsSingleton = [[BVAnalytics alloc] init];
    }
    
    return BVAnalyticsSingleton;
}

- (id) init {
    self = [super init];
    if (self != nil) {
        self.impressionQueue = [NSMutableArray array];
        self.pageviewQueue = [NSMutableArray array];
    }
    return self;
}


-(void)resetAnalyticsTimer:(float)duration {
    self.analyticsTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                      target:self
                                                    selector:@selector(analyticsTimerFired)
                                                    userInfo:nil
                                                     repeats:YES];
}

-(void)analyticsTimerFired {

    unsigned long numberOfQueuedEvents = [self.impressionQueue count] + [self.pageviewQueue count];
    
    if(numberOfQueuedEvents == 0){
//      NSLog(@"No analytics events ready, cancelling timer.");
        [self.analyticsTimer invalidate];
        self.analyticsTimer = nil;
    }
    else {
//      NSLog(@"Attempting to send %lu analytics events", numberOfQueuedEvents);
        [self flushQueue];
    }
}

-(void)flushQueue {
   
    // Batch the queued up events, and send the request on a background thread
    //
    if([self.impressionQueue count] > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            // blanket error catching
            //
            @try {
                // Ensure the url is under 2000 characters long. If it's longer, leave some events for the next queue flush
                //
                NSString* batchedEventsUrl = [self getBatchedEventsUrl:self.impressionQueue type:BVUGCImpression];
                
                // Form the NSURLRequest
                //
                NSURL *url = [[NSURL alloc] initWithString:batchedEventsUrl];
                NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                
                // Send the request synchronously (we're on background thread)
                //
                [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                
                // Used for testing purposes
                //
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BV_INTERNAL_IMPRESSION_ANALYTICS_COMPLETED" object:nil];
            }
            @catch (NSException *exception)
            {
                // Print exception information
                NSLog(@"BVSDK encountered an exception while trying to flush event queue: %@", exception.name);
                NSLog(@"Reason: %@", exception.reason );
            }
        });
    }
    
    // Fire pageview events
    //
    if([self.pageviewQueue count] > 0){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            // blanket error catching
            //
            @try {
                
                NSString* batchedEventsUrl = [self getBatchedEventsUrl:self.pageviewQueue type:BVProductPageview];
                
                // Format the pageview event into a full request
                //
                NSString* baseUrl = [self getBaseURL];
                NSString* baseParamString = [self formatUrlParams:[self getBaseAnalyticsParams]];
                NSString* formatedEventUrl = [NSString stringWithFormat:@"%@?%@%@", baseUrl, baseParamString, batchedEventsUrl];
                
                // Form and send the request synchronously (we're on background thread)
                //
                NSURL *url = [[NSURL alloc] initWithString:formatedEventUrl];
                NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                
//                NSLog(@"Sent analytics event: %@", batchedEventsUrl);
                
                // Used for testing purposes
                //
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BV_INTERNAL_PAGEVIEW_ANALYTICS_COMPLETED" object:nil];
            }
            @catch (NSException *exception)
            {
                // Print exception information
                NSLog(@"BVSDK encountered an exception while trying to flush event queue: %@", exception.name);
                NSLog(@"Reason: %@", exception.reason );
            }
        });
    }
}


-(NSString*)getBatchedEventsUrl:(inout NSMutableArray*)eventsArray type:(BVAnalyticsType)analyticsType {
    
    NSString* batchedEventsUrl = [self batchImpressionEvents:eventsArray type:analyticsType];
    unsigned long numberOfEvents = [eventsArray count];
    
    while([batchedEventsUrl length] > 2000 && numberOfEvents > 1){
        numberOfEvents -= 1;
        batchedEventsUrl = [self batchImpressionEvents:[eventsArray subarrayWithRange:NSMakeRange(0, numberOfEvents)] type:analyticsType];
    }
    
    [eventsArray removeObjectsInRange:NSMakeRange(0, numberOfEvents)];
    return batchedEventsUrl;
}

#pragma mark - Forming the analytics request

-(NSDictionary*)getReviewImpressionEvent:(NSDictionary*)reviewInfo {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:[self getImpressionParams]];
    [parameters addEntriesFromDictionary:reviewInfo];
    
    return parameters;
}

-(NSString*)getPageViewEvent:(NSDictionary*)pageViewInfo {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:[self getPageViewParams]];
    [parameters addEntriesFromDictionary:pageViewInfo];
    
    return [self formatUrlParams:parameters];
}

#pragma mark - Public facing

-(void)queueAnalyticsEventForResponse:(NSDictionary*)response forRequest:(id)sender {
    
    // no analytics events are sent for anything but GET requests
    //
    if([sender class] != [BVGet class]){
        return;
    }
    
    // blanket error-catching
    //
    @try{
    
        BVGet* bvGetRequest = (BVGet*)sender;
        BVGetType type = bvGetRequest.type;
        
        NSMutableSet* pageViewProductIds = [NSMutableSet set];
        NSArray* results = [response objectForKey:@"Results"];
        
        if(results != nil) {
            for(NSDictionary* result in results) {
                NSDictionary* resultInfo = [self getRelevantInfoForGetType:type andResult:result];
                if(resultInfo != nil) {
                    
                    // Create and queue UGC-Impression event
                    //
                    [self.impressionQueue addObject:[self getReviewImpressionEvent:resultInfo]];
                    
                    // Create and queue PageView event, if not already added for this response
                    //
                    NSString* productId = [resultInfo objectForKey:@"productId"];
                    if(productId != nil && [pageViewProductIds containsObject:productId] == false){
                        [self.pageviewQueue addObject:[self getPageViewEvent:@{ @"productId": productId }]];
                        [pageViewProductIds addObject:productId];
                    }
                }
            }
        }
        
        // flush queue in 5 seconds (approx after requests have finished). If new event queued up, wait again.
        //
        [self resetAnalyticsTimer:5.0];
        
        // if the queue is too big, start flushing
        //
        if([self.impressionQueue count] + [self.pageviewQueue count] > 25){
            [self flushQueue];
        }
        
    }
    @catch (NSException *exception)
    {
        // Print exception information
        NSLog(@"BVSDK encountered an exception while queueing an event: %@", exception.name);
        NSLog(@"Reason: %@", exception.reason );
    }
}

#pragma mark - Data formatting

-(NSString*)formatUrlParams:(NSDictionary*)parameters {
    
    NSMutableArray* urlParameters = [NSMutableArray array];
    
    for (NSString* key in parameters) {
        [urlParameters addObject:[NSString stringWithFormat:@"%@=%@", key, [parameters objectForKey:key]]];
    }
    
    return [urlParameters componentsJoinedByString:@"&"];
}

-(NSString*)batchImpressionEvents:(NSArray*)eventUrls type:(BVAnalyticsType)analyticsType {
    
    // batch the events according to RISON formatting
    //
    NSString* r_batch = [BVRisonEncoder urlEncode:[BVRisonEncoder encode:eventUrls]];
    
    NSString* baseUrl = [self getBaseURL];
    NSString* baseParamString = [self formatUrlParams:[self getBaseAnalyticsParams]];
    NSString* baseBatchUrl = [NSString stringWithFormat:@"%@?%@", baseUrl, baseParamString];
    NSString* analyticsSpecificParameters;
    if(analyticsType == BVUGCImpression) {
        analyticsSpecificParameters = @"UGC";
    }
    else {
        analyticsSpecificParameters = @"Product";
    }
    
    return [NSString stringWithFormat:@"%@&cl=null&type=%@&r_batch=%@", baseBatchUrl, analyticsSpecificParameters, r_batch];
}

-(NSString*) getBaseURL {
    if ([BVSettings instance].staging) {
        return @"https://network-stg-a.bazaarvoice.com/a.gif";
    }
    else {
        return @"https://network-a.bazaarvoice.com/a.gif";
    }
}

-(NSDictionary*)getBaseAnalyticsParams {
    
    NSString* environment = @"production";
    if([[BVSettings instance] staging]){
        environment = @"staging";
    }
    
    return @{
             @"source": @"bv-ios-sdk",
             @"environment": environment,
             @"client": [[BVSettings instance] clientId],
             @"bvProduct": @"bv-ios-sdk"
             };
}

-(NSDictionary*)getImpressionParams {
    return @{
             @"cl": @"Impression",
             @"type": @"UGC"
             };
}

-(NSDictionary*)getPageViewParams {
    return @{
             @"cl": @"PageView",
             @"type": @"Product"
             };
}

-(NSDictionary*)getRelevantInfoForGetType:(BVGetType)type andResult:(NSDictionary*)result {
    switch (type) {
        case BVGetTypeReviews:
            return @{
                     @"contentType": @"Review",
                     @"contentId": [result objectForKey:@"Id"],
                     @"productId": [result objectForKey:@"ProductId"],
                     @"visible": [NSNumber numberWithBool:NO]
                     };
            break;
        
        case BVGetTypeStatistics:
            return @{
                     @"contentType": @"Statistic",
                     @"contentId": [NSNull null],
                     @"productId": [[result objectForKey:@"ProductStatistics"] objectForKey:@"ProductId"]
                     };
            break;
            
        case BVGetTypeStories:
            return @{
                     @"contentType": @"Story",
                     @"contentId": [result objectForKey:@"Id"]
                     };
            break;
            
        case BVGetTypeCategories:
            return @{
                     @"contentType": @"Category",
                     @"contentId": [result objectForKey:@"Id"]
                     };
            break;
            
        case BVGetTypeStoryCommments:
            return @{
                     @"contentType": @"Comment",
                     @"contentId": [result objectForKey:@"Id"]
                     };
            break;
            
        case BVGetTypeProducts:
            return @{
                     @"contentType": @"Product",
                     @"contentId": [result objectForKey:@"Id"],
                     @"productId": [result objectForKey:@"Id"],
                     @"categoryId": [result objectForKey:@"CategoryId"]
                     };
            
        case BVGetTypeQuestions:
            return @{
                     @"contentType": @"Question",
                     @"contentId": [result objectForKey:@"Id"],
                     @"productId": [result objectForKey:@"ProductId"],
                     @"categoryId": [result objectForKey:@"CategoryId"]
                     };
            
        default:
            return nil;
    }
}

@end