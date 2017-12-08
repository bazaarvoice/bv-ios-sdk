//
//  BVSDKManager.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVAuthenticatedUser.h"
#import "BVCommon.h"
#import "BVLogger.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BVConfigurationType) {
  BVConfigurationTypeProd,
  BVConfigurationTypeStaging
};

// For internal use of notifying the BVLocation module when the SDK has been
// intialized.
#define LOCATION_API_KEY_SET_NOTIFICATION @"locationAPIKeyReady"

// For intenal use of notifying with the Conversations Store api key has been
// initialized.
#define CONVERSATIONS_STORES_API_KEY_SET_NOTIFICATION                          \
  @"conversationsStoreAPIKeyReady"

// For intenal use of notifying with the BVPIN (Post Interaction Notification)
// module has been initialized.
#define PIN_API_KEY_SET_NOTIFICATION @"pinAPIKeyReady"

/*!
   The singleton instance for registering your API key and server to use. Any
 use of the BVRecommendations API must start here!

 ##Code Examples: Initializing the SDK Manager

 ### Objective-C

    @code
    // Will search app bundle for file bvsdk_config_staging.json for
 BVConfigurationTypeStaging or
    // bvsdk_config_prod.json for BVConfigurationTypeProd. BVSDK will be
 configured using this file
    [BVSDKManager configure:BVConfigurationTypeStaging];
    @endcode

 ### Swift

    @code
    // Will search app bundle for file bvsdk_config_staging.json for
 BVConfigurationTypeStaging or
    // bvsdk_config_prod.json for BVConfigurationTypeProd. BVSDK will be
 configured using this file
    BVSDKManager.configure(.staging)
    @endcode

 */
@interface BVSDKManager : NSObject

+ (void)configure:(BVConfigurationType)configurationType;

+ (void)configureWithConfiguration:(nonnull NSDictionary *)configDict
                        configType:(BVConfigurationType)configType;

/// Singleton pattern. Use this `sharedManager` whenever interacting with BVSDK.
+ (nonnull instancetype)sharedManager;

- (nonnull id)init
    __attribute__((unavailable("Must use sharedManager for the BVSDKManager")));

/// Set the log level for getting log and event info. Default is
/// BVLogLevel.kBVLogLevelError
- (void)setLogLevel:(BVLogLevel)logLevel;

/// Read-only value of urlRoot for Shopper Advertising APIs. Varies depending on
/// value of staging.
@property(nonnull, nonatomic, readonly) NSString *urlRootShopperAdvertising;

/// Client ID associated with the API key
@property(nonnull, nonatomic, strong) NSString *clientId
    __attribute__((deprecated(
        "Use BVSDKManager#configure:(BVConfigurationType)configurationType "
        "instead.")));

/// Boolean indicating whether this request should go to staging (true) or
/// production (false).  Default is production (false).
@property(nonatomic, assign) BOOL staging __attribute__((deprecated(
    "Use BVSDKManager#configure:(BVConfigurationType)configurationType "
    "instead.")));

/// Your private API key for the BVConversations product
@property(nonnull, nonatomic, strong) NSString *apiKeyConversations
    __attribute__((deprecated("Use "
                              "BVSDKManager#configure:(BVConfigurationType)"
                              "configurationType instead.")));

/// Your private API key for the BVConversations, Store Reviews product
@property(nonnull, nonatomic, strong) NSString *apiKeyConversationsStores
    __attribute__((deprecated("Use "
                              "BVSDKManager#configure:(BVConfigurationType)"
                              "configurationType instead.")));

/// Your private API key for Post Interaction Notifications
@property(nonnull, nonatomic, strong) NSString *apiKeyPIN
    __attribute__((deprecated(
        "Use BVSDKManager#configure:(BVConfigurationType)configurationType "
        "instead.")));

/// The category of the Notification Content Extension you will use for store
/// review notifications
@property(nonnull, nonatomic, strong)
    NSString *storeReviewContentExtensionCategory
    __attribute__((deprecated("Use "
                              "BVSDKManager#configure:(BVConfigurationType)"
                              "configurationType instead.")));

/// The category of the Notification Content Extension you will use for PIN
@property(nonnull, nonatomic, strong) NSString *PINContentExtensionCategory
    __attribute__((deprecated("Use "
                              "BVSDKManager#configure:(BVConfigurationType)"
                              "configurationType instead.")));

/// Your private API key for the BVRecommendations and BVAdvertising products
/// (Shopper Advertising)
@property(nonnull, nonatomic, strong) NSString *apiKeyShopperAdvertising
    __attribute__((deprecated("Use "
                              "BVSDKManager#configure:(BVConfigurationType)"
                              "configurationType instead.")));

/// Your private API key for the BVCurations API
@property(nonnull, nonatomic, strong) NSString *apiKeyCurations
    __attribute__((deprecated("Use "
                              "BVSDKManager#configure:(BVConfigurationType)"
                              "configurationType instead.")));

/// Your private API key for the BVLocations API
@property(nonnull, nonatomic, strong) NSString *apiKeyLocation
    __attribute__((deprecated("Use "
                              "BVSDKManager#configure:(BVConfigurationType)"
                              "configurationType instead.")));

/**
    Set user information. Associates a user profile with device for taylored
   advertising and recommendations.
    Use of this method requires that a valid key has been set for
   apiKeyShopperMarketing.

    @param userAuthString The UAS that was generated server-side for
   Bazaarvoice.
 */
- (void)setUserWithAuthString:(nonnull NSString *)userAuthString;

/// The authenticed user retrieved after calling setUserWithAuthString. The
/// model may be empty until the BV user profile has been reconcilled.
@property(nonnull, strong, readonly) BVAuthenticatedUser *bvUser;

/**
    Generate DFP (Doubleclick For Publsher's) compatible custom targeting.

    @code
    DFPRequest* request = [[DFPRequest request] request];
    request.customerTargeting = [[BVSDKManager sharedManager]
   getTargetingKeywords];
    @endcode
 */
- (nonnull NSDictionary *)getCustomTargeting;

/// Network timeout in seconds.  Default is 60 seconds.  Note that iOS may set a
/// minimum timeout of 240 seconds for post requests.
@property(nonatomic, assign) float timeout;

@end
