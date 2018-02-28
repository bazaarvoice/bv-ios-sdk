//
//  BVSDKManager.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVAuthenticatedUser.h"
#import "BVCommon.h"
#import "BVLogger.h"
#import "BVURLSessionDelegate.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BVConfigurationType) {
  BVConfigurationTypeProd,
  BVConfigurationTypeStaging
};

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

/// BVURLSessionDelegate used to acquire NSURLSession objects and proxy methods.
/// Please see BVURLSessionDelegate.h for more details. Setting this is
/// guaranteed to be thread safe, however, it isn't atomic with respect to
/// currently enqueued and running jobs so behavior is undefined if you
/// set/unset this anytime after initialization. It's best to set this at launch
/// and to not unset.
@property(nullable, nonatomic, weak) id<BVURLSessionDelegate>
    urlSessionDelegate;

/// Read-only value of urlRoot for BVRecommendations APIs. Varies depending on
/// value of staging.
@property(nonnull, nonatomic, readonly) NSString *urlRootShopperAdvertising;

/// Network timeout in seconds.  Default is 60 seconds.  Note that iOS may set a
/// minimum timeout of 240 seconds for post requests.
@property(nonatomic, assign) float timeout;

/// The authenticed user retrieved after calling setUserWithAuthString. The
/// model may be empty until the BV user profile has been reconcilled.
@property(nonnull, strong, readonly) BVAuthenticatedUser *bvUser;

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

/**
    Set user information. Associates a user profile with device for taylored
    recommendations.
    Use of this method requires that a valid key has been set for
   apiKeyShopperMarketing.

    @param userAuthString The UAS that was generated server-side for
   Bazaarvoice.
 */
- (void)setUserWithAuthString:(nonnull NSString *)userAuthString;

/**
    Generate DFP (Doubleclick For Publsher's) compatible custom targeting.

    @code
    DFPRequest* request = [[DFPRequest request] request];
    request.customerTargeting = [[BVSDKManager sharedManager]
   getTargetingKeywords];
    @endcode
 */
- (nonnull NSDictionary *)getCustomTargeting;

@end
