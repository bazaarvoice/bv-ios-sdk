//
//  BVSDKManager.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVCore.h"
#import "BVLogger.h"
#import "BVAuthenticatedUser.h"
#import "BVStoreReviewNotificationProperties.h"

NS_ASSUME_NONNULL_BEGIN

// For internal use of notifying the BVLocation module when the SDK has been intialized.
#define LOCATION_API_KEY_SET_NOTIFICATION @"locationAPIKeyReady"

/*!
   The singleton instance for registering your API key and server to use. Any use of the BVRecommendations API must start here!
 
 ##Code Examples: Initializing the SDK Manager
 
 ### Objective-C
    
    @code
    [BVSDKManager sharedManager].staging = YES;  //  NO for production
    [BVSDKManager sharedManager].clientId = @"YOUR_CLIENT_ID";
    // If using Converstations API, add this line:
    [BVSDKManager sharedManager].apiKeyConversations = @"YOUR_CONVERSATIONS_API_KEY";
    // If using Recommendations or Advertising, add this line:
    [BVSDKManager sharedManager].apiKeyShopperAdvertising = @"YOUR_SHOPPER_MARKETING_KEY";
    @endcode
 
 ### Swift
 
    @code
    let mgr = BVSDKManager.sharedManager()
    mgr.setLogLevel(BVLogLevel.Verbose)
    // If using Converstations API, add this line:
    apiKeyConversations = "YOUR_CONVERSATIONS_API_KEY"
    // If using Recommendations or Advertising, add this line:
    mgr.apiKeyShopperAdvertising = "YOUR_SHOPPER_MARKETING_KEY"
    mgr.clientId = "YOUR_CLIENT_ID"
    mgr.staging = false  //  true for production
    @endcode
 
 */
@interface BVSDKManager : NSObject


/// Singleton pattern. Use this `sharedManager` whenever interacting with BVSDK.
+(instancetype)sharedManager;


- (id) init __attribute__((unavailable("Must use sharedManager for the BVSDKManager")));


/// Set the log level for getting log and event info. Default is BVLogLevel.kBVLogLevelError
-(void)setLogLevel:(BVLogLevel)logLevel;

/// Client ID associated with the API key
@property (nonatomic, strong) NSString *clientId;

/// Boolean indicating whether this request should go to staging (true) or production (false).  Default is production (false).
@property (nonatomic, assign) BOOL staging;

/// Read-only value of urlRoot for Shopper Advertising APIs. Varies depending on value of staging.
@property (nonatomic, readonly) NSString *urlRootShopperAdvertising;

/// Your private API key for the BVConversations product
@property (nonatomic, strong) NSString *apiKeyConversations;


/// Your private API key for the BVConversations, Store Reviews product
@property (nonatomic, strong) NSString *apiKeyConversationsStores;

/// The category of the Notification Content Extension you will use for store review notifications
@property (nonatomic, strong) NSString *storeReviewContentExtensionCategory;

/// Your private API key for the BVRecommendations and BVAdvertising products (Shopper Advertising)
@property (nonatomic, strong) NSString *apiKeyShopperAdvertising;

/// Your private API key for the BVCurations API
@property (nonatomic, strong) NSString *apiKeyCurations;

/// Your private API key for the BVLocations API
@property (nonatomic, strong) NSString *apiKeyLocation;


/**
    Set user information. Associates a user profile with device for taylored advertising and recommendations.
    Use of this method requires that a valid key has been set for apiKeyShopperMarketing.
 
    @param userAuthString The UAS that was generated server-side for Bazaarvoice.
 */
-(void)setUserWithAuthString:(NSString*)userAuthString;


/// The authenticed user retrieved after calling setUserWithAuthString. The model may be empty until the BV user profile has been reconcilled.
@property (strong, readonly) BVAuthenticatedUser *bvUser;

/**
These properties are available after setting the BVSDKManager#apiKeyLConversationsStores. Clients typically do not need to access these properties except for help in debugging. 
 */
@property (strong, readonly) BVStoreReviewNotificationProperties *bvStoreReviewNotificationProperties;

/**
    Generate DFP (Doubleclick For Publsher's) compatible custom targeting.
     
    @code
    DFPRequest* request = [[DFPRequest request] request];
    request.customerTargeting = [[BVSDKManager sharedManager] getTargetingKeywords];
    @endcode
 */
-(NSDictionary*)getCustomTargeting;


/// Network timeout in seconds.  Default is 60 seconds.  Note that iOS may set a minimum timeout of 240 seconds for post requests.
@property (nonatomic, assign) float timeout;

NS_ASSUME_NONNULL_END

@end
