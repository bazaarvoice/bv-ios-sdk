//
//  BVSDKConfiguration.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVSDKManager.h"

@interface BVSDKConfiguration : NSObject

- (nonnull instancetype)init __attribute__((unavailable("init not available")));

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dict
                                configType:(BVConfigurationType)type;

/// Client ID associated with the API key
@property(nonatomic, strong, readonly, nonnull) NSString *clientId;

/// Your private API key for the BVConversations product
@property(nonatomic, strong, readonly, nullable) NSString *apiKeyConversations;

/// Your private API key for the BVConversations, Store Reviews product
@property(nonatomic, strong, readonly, nullable)
    NSString *apiKeyConversationsStores;

/// Your private API key for Post Interaction Notifications
@property(nonatomic, strong, readonly, nullable) NSString *apiKeyPIN;

/// The category of the Notification Content Extension you will use for store
/// review notifications
@property(nonatomic, strong, readonly, nullable)
    NSString *storeReviewContentExtensionCategory;

/// The category of the Notification Content Extension you will use for PIN
@property(nonatomic, strong, readonly, nullable)
    NSString *PINContentExtensionCategory;

/// Your private API key for the BVRecommendations product
@property(nonatomic, strong, readonly, nullable)
    NSString *apiKeyShopperAdvertising;

/// Your private API key for the BVProductSentiments
@property(nonatomic, strong, readonly, nullable) NSString *apiKeyProductSentiments;

/// Your private API key for the BVCurations API
@property(nonatomic, strong, readonly, nullable) NSString *apiKeyCurations;

@property(nonatomic, assign, readonly) BOOL staging;

@property(nonatomic, assign, readonly) BOOL dryRunAnalytics;

/// The Locale Specific binding for Analytics
@property(nonatomic, strong, readonly, nullable)
    NSString *analyticsLocaleIdentifier;

@end
