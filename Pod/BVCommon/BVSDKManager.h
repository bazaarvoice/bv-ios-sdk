//
//  BVSDKManager.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVCore.h"
#import "BVLogger.h"
#import "BVAuthenticatedUser.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 * The singleton instance for registering your API key and server to use. Any use of the BVRecommendations API must start here!
 
 ##Code Examples: Initializing the SDK Manager
 
 ### Objective-C

    [BVSDKManager sharedManager].staging = YES;  //  NO for production
    [BVSDKManager sharedManager].clientId = @"YOUR_CLIENT_ID";
    // If using Converstations API, add this line:
    [BVSDKManager sharedManager].apiKeyConversations = @"YOUR_CONVERSATIONS_API_KEY";
    // If using Recommendations or Advertising, add this line:
    [BVSDKManager sharedManager].apiKeyShopperAdvertising = @"YOUR_SHOPPER_MARKETING_KEY";
 
 
 ### Swift
 
     let mgr = BVSDKManager.sharedManager()
     mgr.setLogLevel(BVLogLevel.Verbose)
     // If using Converstations API, add this line:
     apiKeyConversations = "YOUR_CONVERSATIONS_API_KEY"
     // If using Recommendations or Advertising, add this line:
     mgr.apiKeyShopperAdvertising = "YOUR_SHOPPER_MARKETING_KEY"
     mgr.clientId = "YOUR_CLIENT_ID"
     mgr.staging = false  //  true for production
 
 
 */
@interface BVSDKManager : NSObject

/**
 *  The shared SDK manager across all SDK modules
 *
 *  @return Returns the initialized singleton instance.
 */
+(instancetype)sharedManager;

/**
 Set the log level for getting log and event info. Default is BVLogLevel.kBVLogLevelError
 */
-(void)setLogLevel:(BVLogLevel)logLevel;

/**
 Client ID associated with the API key
 */
@property (nonatomic, strong) NSString *clientId;

/**
 Boolean indicating whether this request should go to staging (true) or production (false).  Default is production (false).
 */
@property (nonatomic, assign) BOOL staging;

/**
 *  Read-only value of urlRoot. Varies depending on value of staging.
 */
@property (nonatomic, readonly) NSString *urlRootShopperAdvertising;

/**
 *  Your private API key for the BVConversations product
 */
@property (nonatomic, strong) NSString *apiKeyConversations;

/**
 *  Your private API key for the BVRecommendations and BVAdvertising products (Shopper Advertising)
 */
@property (nonatomic, strong) NSString *apiKeyShopperAdvertising;

/**
 Set user information. Associates a user profile with device for taylored advertising and recommendations.
 Use of this method requires that a valid key has been set for apiKeyShopperMarketing.
 
 @param userAuthString The UAS that was generated server-side for Bazaarvoice.
 */
-(void)setUserWithAuthString:(NSString*)userAuthString;

/**
 *  The authenticed user retrieved after calling setUserWithAuthString. The model may be empty until the BV user profile has been reconcilled.
 */
@property (strong, readonly) BVAuthenticatedUser *bvUser;
    

/**
 Network timeout in seconds.  Default is 60 seconds.  Note that iOS may set a minimum timeout of 240 seconds for post requests.
 */
@property (nonatomic, assign) float timeout;


NS_ASSUME_NONNULL_END

@end
