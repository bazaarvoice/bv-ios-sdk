//
//  BVConversationsAnalyticsHelper.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVConversationsAnalyticsHelper.h"
#import "BVAnalyticsManager.h"

// type for BVGet
typedef enum {
    BVUGCImpression,
    BVProductPageview
} BVAnalyticsType;

@interface BVConversationsAnalyticsHelper()

@end

static BVConversationsAnalyticsHelper *BVAnalyticsSingleton = nil;

@implementation BVConversationsAnalyticsHelper

+ (BVConversationsAnalyticsHelper *) instance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BVAnalyticsSingleton = [[self alloc] init];
    });
    
    return BVAnalyticsSingleton;
}

- (id) init {
    self = [super init];
    return self;
}



#pragma mark - Forming the analytics request


-(NSDictionary*)getReviewImpressionEvent:(NSDictionary*)reviewInfo {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:[self getImpressionParams]];
    [parameters addEntriesFromDictionary:reviewInfo];
    
    return parameters;
}


-(NSDictionary *)getPageViewEventDict:(NSDictionary*)pageViewInfo {
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:[self getPageViewParams]];
    [parameters addEntriesFromDictionary:pageViewInfo];
    
    return parameters;
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
                    NSDictionary *eventDict = [self getReviewImpressionEvent:resultInfo];
                    [[BVAnalyticsManager sharedManager] queueEvent:eventDict];
                    
                    // Create and queue PageView event, if not already added for this response
                    //
                    NSString* productId = [resultInfo objectForKey:@"productId"];
                    if(productId != nil && [pageViewProductIds containsObject:productId] == false){

                        [[BVAnalyticsManager sharedManager] queuePageViewEventDict:[self getPageViewEventDict:@{ @"productId": productId }]];

                        [pageViewProductIds addObject:productId];
                    }
                }
            }
        }
        
    }
    @catch (NSException *exception)
    {
        // Print exception information
        NSLog(@"BVSDK encountered an exception while queueing an event: %@", exception.name);
        NSLog(@"Reason: %@", exception.reason );
    }
}


#pragma mark - Internal Data formatting

// Helper routines to format data according to API response

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
                     @"contentId": @"null",
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