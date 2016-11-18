//
//  BVAnalyticsManager.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Singleton class that manages all analytic event queueing and dispatching of events to Bazaarvoice.
@interface BVAnalyticsManager : NSObject


/// Set to true when sending events to the staging server. Default is NO (production)
@property BOOL isStagingServer;


/// Sets the client ID for the API being used. App will assert if client ID is not set!
@property (strong, nonatomic) NSString *clientId;


/// Create and get the singleton instance of the analytics manager.
+ (BVAnalyticsManager *)sharedManager;


/// Add an event to the analytics processing queuek
-(void)queueEvent:(NSDictionary*)eventData;


/// Add an event without IDFA to the analytics processing queue
-(void)queueAnonymousEvent:(NSDictionary*)eventData;


/**
    Add a page view event to be queued. Pageview events run on a separate event queue than other impression events.
 
    @param pageViewEvent The page view event to send
 */
- (void)queuePageViewEventDict:(NSDictionary *)pageViewEvent;


/**
    Date formatter for BV analytic events.
 
    @param date An NSDate object
 
    @return The string representation of the date that can be sent along with a BV analytic event.
 */
-(NSString*)formatDate:(NSDate*)date;


/// Immediately send all pending analytic events
-(void)flushQueue;


/**
    Get mobile diagnostic event dictionary to add to an event. Provides info such as bundle identifier, app version, ect.
 
    @return Mutable dictionary with filled out key/value pairs.
 */
-(NSMutableDictionary*)getMobileDiagnosticParams;


/**
    Provided an authentication token has been set for a BVAuthenticatedUser, send an event that the user has registered with the app.
 
    @param userAuthString The user auth string found in the BVAuthenticatedUser object.
 */
-(void)sendPersonalizationEvent:(NSString *)userAuthString;

@end
