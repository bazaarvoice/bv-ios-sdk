//
//  BVAnalyticsManager.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <AdSupport/AdSupport.h>
#import <UIKit/UIKit.h>

#import "BVCore.h"
#import "BVAnalyticsManager.h"
#include <sys/sysctl.h>
#include <sys/utsname.h>

#define BV_MAGPIE_ENDPOINT @"https://network.bazaarvoice.com/event"
#define BV_MAGPIE_STAGING_ENDPOINT @"https://network-stg.bazaarvoice.com/event"
#define BV_QUEUE_FLUSH_INTERVAL 10.0
#define BVID_STORAGE_KEY @"BVID_STORAGE_KEY"

@interface BVAnalyticsManager ()

@property (strong) NSMutableArray* eventQueue; // Impressions, other non-pageview events
@property (strong) NSMutableArray* pageviewQueue; // Page views
@property NSTimer* queueFlushTimer;

@property (nonatomic, strong) dispatch_queue_t concurrentEventQueue;

@property BVAuthenticatedUser *bvAuthenticatedUser;
@property NSString* BVID;

@end

@implementation BVAnalyticsManager

static BVAnalyticsManager *analyticsInstance = nil;

+ (BVAnalyticsManager *) sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        analyticsInstance = [[self alloc] init];
        analyticsInstance->_concurrentEventQueue = dispatch_queue_create("com.bazaarvoice.analyticEventQueue",
                                                                          DISPATCH_QUEUE_CONCURRENT);
    });
    
    return analyticsInstance;
}

- (id) init {
    self = [super init];
    if (self != nil) {
        
        self.BVID = [[NSUserDefaults standardUserDefaults] stringForKey:BVID_STORAGE_KEY];
        if(self.BVID == nil || [self.BVID length] == 0) {
            self.BVID = [[NSUUID UUID] UUIDString];
            [[NSUserDefaults standardUserDefaults] setValue:self.BVID forKey:BVID_STORAGE_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        self.eventQueue = [NSMutableArray array];
        self.pageviewQueue = [NSMutableArray array];
        
        [self registerForAppStateChanges];
        
    }
    return self;
}


-(NSMutableDictionary*)getMobileDiagnosticParams {
    
    // get diagnostic data
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString* osVersion = [[UIDevice currentDevice] systemVersion];
    NSString *majorMinor = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDictionary objectForKey:(NSString*)kCFBundleVersionKey];
    NSString* appVersion = [NSString stringWithFormat:@"%@.%@", majorMinor, build];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:bundleIdentifier forKey:@"mobileAppIdentifier"];
    [params setValue:appVersion forKey:@"mobileAppVersion"];
    [params setValue:osVersion forKey:@"mobileOSVersion"];
    [params setValue:@"ios" forKey:@"mobileOS"];
    [params setValue:platform forKey:@"mobileDeviceName"];
    [params setValue:BV_SDK_VERSION forKey:@"bvSDKVersion"];
    
    return params;
}

#pragma mark - Application state change updates

-(void)registerForAppStateChanges {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    });
}

-(void)applicationDidFinishLaunching {
    [self sendAppLaunchedEvent];
}


-(void)applicationDidBecomeActive {
        
    [self sendAppActiveEvent];
}

-(void)applicationDidEnterBackground {
    [self sendAppInBackgroundEvent];
}

#pragma mark User Profile Event

#pragma mark - Personalization event

-(NSDictionary*)getPersonalizationEventParams {
    return @{
             @"type": @"ProfileMobile",
             @"cl": @"Personalization",
             @"source": @"ProfileMobile",
             @"bvProduct": @"ShopperMarketing"
             };
}


- (NSDictionary *)getCommonAnalyticsDict{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"mobileSource": @"bv-ios-sdk",
                                                                                  @"HashedIP" : @"default",
                                                                                  @"UA" : self.BVID
                                                                                }];
    
    [params setValue:self.clientId forKey:@"client"];
    
    // idfa
    //check it limit ad tracking is enabled
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]){
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    } else {
        idfa = @"nontracking";
    }
    
    [params setValue:idfa forKey:@"advertisingId"];
    
    return params;
}


-(void)sendPersonalizationEvent:(BVAuthenticatedUser *)user {
    
    if (!user){
        return;
    }
    
    self.bvAuthenticatedUser = user;
    
    NSMutableDictionary* eventData = [NSMutableDictionary dictionaryWithDictionary:[self getCommonAnalyticsDict]];
    [eventData addEntriesFromDictionary:[self getPersonalizationEventParams]];
    [eventData setValue:self.bvAuthenticatedUser.userAuthString forKey:@"profileId"]; // may be null
    
    [self queueEvent:eventData];
    
    // for personalization events, want to flush queue immediately.

    [self flushQueue];
}

#pragma mark - App lifecycle events

-(NSDictionary*)getAppStateEventParams {
    return @{
             @"cl": @"Lifecycle",
             @"type": @"MobileApp",
             @"source": @"mobile-lifecycle"
             };
}

-(void)sendAppLaunchedEvent {
    [self sendAppStateEvent:@"launched"];
}

-(void)sendAppActiveEvent {
    [self sendAppStateEvent:@"active"];
}

-(void)sendAppInBackgroundEvent{
    [self sendAppStateEvent:@"background"];
}

-(void)sendAppStateEvent:(NSString*)appState {
    // build param dictionary

    NSMutableDictionary* eventData = [NSMutableDictionary dictionaryWithDictionary:[self getCommonAnalyticsDict]];
    [eventData addEntriesFromDictionary:[self getMobileDiagnosticParams]];
    [eventData addEntriesFromDictionary:[self getAppStateEventParams]];
    [eventData setObject:appState forKey:@"appState"];
    
    // send request
    [self queueEvent:eventData];
}

#pragma mark - Event Queueing

-(void)queueEvent:(NSDictionary*)eventData {
    
    NSAssert(self.clientId != nil, @"You must set the client id in the BVSDKManager class before using the SDK!");
    
    NSMutableDictionary *eventForQueue = [NSMutableDictionary dictionaryWithDictionary:eventData];
    [eventForQueue addEntriesFromDictionary:[self getCommonAnalyticsDict]];
    
    dispatch_barrier_sync(self.concurrentEventQueue, ^{
        // Update event queue
        [self.eventQueue addObject:eventForQueue];
        
    });
    
    // schedule a queue flush, if not already scheduled
    // many times, a rush of events come very close to each other, and then things are quiet for a while.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(self.queueFlushTimer == nil){
            
            SEL flushQueueSelector = @selector(flushQueue);
            
            self.queueFlushTimer = [NSTimer scheduledTimerWithTimeInterval:BV_QUEUE_FLUSH_INTERVAL
                                                                    target:self
                                                                  selector:flushQueueSelector
                                                                  userInfo:nil
                                                                   repeats:NO];
        }
    });

    
    
    
}

- (void)queuePageViewEventDict:(NSDictionary *)pageViewEvent{
    
    assert(self.clientId != nil);
    
    NSMutableDictionary *eventForQueue = [NSMutableDictionary dictionaryWithDictionary:pageViewEvent];
    [eventForQueue addEntriesFromDictionary:[self getCommonAnalyticsDict]];
    
    dispatch_barrier_sync(self.concurrentEventQueue, ^{
        // Update PageView queue events
        [self.pageviewQueue addObject:eventForQueue];
    });
    
    
        
}

// Flush queue for POST batch
-(void)flushQueue {
    
    // clear flush timer
    if(self.queueFlushTimer != nil){
        [self.queueFlushTimer invalidate];
    }
    self.queueFlushTimer = nil;
    
    // send events
    if([self.eventQueue count] > 0){
        NSDictionary* batch = @{ @"batch": self.eventQueue };
        [self sendBatchedPOSTEvent:batch withCompletionHandler:^(NSError * _Nullable error) {
            if (error){
                [[BVLogger sharedLogger] error:[NSString stringWithFormat:@"ERROR: posting magpie impression event%@", error.localizedDescription]];
            }
            
            // For internal testing
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BV_INTERNAL_MAGPIE_EVENT_COMPLETED" object:error];
            });
            
        }];
        
        dispatch_barrier_sync(self.concurrentEventQueue, ^{
            // purge queue
            [self.eventQueue removeAllObjects];
        });
        
    }
    
    // send page view events
    if ([self.pageviewQueue count] > 0){
        NSDictionary* batch = @{ @"batch": self.pageviewQueue };
        [self sendBatchedPOSTEvent:batch withCompletionHandler:^(NSError * _Nullable error) {
            if (error){
                [[BVLogger sharedLogger] error:[NSString stringWithFormat:@"ERROR: posting magpie pageview event%@", error.localizedDescription]];
            }
            
            // For internal testing
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BV_INTERNAL_PAGEVIEW_ANALYTICS_COMPLETED" object:error];
            });
            
        }];
        
        dispatch_barrier_sync(self.concurrentEventQueue, ^{
            // purge pageview queue
            [self.pageviewQueue removeAllObjects];
        });
        
    }
}

-(void)sendBatchedPOSTEvent:(NSDictionary*)eventData withCompletionHandler:(void (^)(NSError * __nullable error))completionHandler{
    
    NSURL *url = [NSURL URLWithString:[self baseUrl]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];// content type
        
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:eventData options:kNilOptions error:&error];
    
    [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"POST Event: %@\nWith Data:%@", url, eventData]];
    
    if (!error){
        NSURLSessionUploadTask *postTask = [session uploadTaskWithRequest:request
                                                                 fromData:data completionHandler:^(NSData *data,
                                                                                                   NSURLResponse *response, NSError *error) {
                                                                     
             // completion
             // one-way communication, client->server: disregard results but log error, if any
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             if ((httpResponse && httpResponse.statusCode >= 300) || error != nil){
                 
                 if (data){
                     
                     NSString* errorMsg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                     [[BVLogger sharedLogger] error:errorMsg];
                     
                 } else {
                 
                     [[BVLogger sharedLogger] error:[NSString stringWithFormat:@"ERROR: Posting analytics event failed with status: %ld and error: %@", (long)httpResponse.statusCode, error]];
                }
                 
             } else {
                 
                 // Successful analyatics event sent
                 NSString* message = [NSString stringWithFormat:@"Analytics event sent successfully."];
                 [[BVLogger sharedLogger] verbose:message];
                 
             }
             
             completionHandler(error);
             
         }];
        
        [postTask resume];
        
    };
    
}


#pragma mark - Helpers

-(NSString*)formatDate:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    return [dateFormatter stringFromDate:date]; //return ISO-8601 formatted UTC timestamp
}

-(NSString*)baseUrl {
    if(self.isStagingServer){
        [[BVLogger sharedLogger] error:@"WARNING: Using staging server for analytic events. This should only enabled for non-production."];
        return BV_MAGPIE_STAGING_ENDPOINT;
    }
    else {
        return BV_MAGPIE_ENDPOINT;
    }
}

- (void)setClientId:(NSString *)clientId{
    
    _clientId = clientId;
    
    if ([_clientId isEqualToString:@"apitestcustomer"]){
        [[BVLogger sharedLogger] error:@"WARNING: Client apitestcustomer should not be used for production!!!"];
    }
    
}

-(void)setLogLevel:(BVLogLevel)logLevel{
    [[BVLogger sharedLogger] setLogLevel:logLevel];
}


@end
