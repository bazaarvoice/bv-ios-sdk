//
//  BVSDKManager.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVSDKManager.h"
#import "BVCore.h"
#import "BVAnalyticsManager.h"
#import "BVAnalyticEventManager.h"
#import <UIKit/UIKit.h>

@interface BVSDKManager ()

@end

@implementation BVSDKManager

+(instancetype)sharedManager
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

-(id)init {
    self = [super init];
    if(self){
        
        _bvUser = [[BVAuthenticatedUser alloc] init];
        
        // make sure analytics has been started
        [BVAnalyticsManager sharedManager];
        
        _timeout = 60;
        _staging = NO;
        _clientId = nil;
        _apiKeyConversations = nil;
        _apiKeyShopperAdvertising = nil;
        _apiKeyConversationsStores = nil;
        _apiKeyLocation = nil;
    }
    return self;
}

-(void)registerForAppStateChanges {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidFinishLaunching)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
    });
}


-(void)applicationDidFinishLaunching {
    
    BVSDKManager *sdkMgr = [BVSDKManager sharedManager];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    NSString *clientId = sdkMgr.clientId;
    
    // check that `clientId` is valid
    NSAssert(clientId != nil && ![clientId isEqualToString:@""], @"You must supply client id in the BVSDKManager before using the Bazaarvoice SDK.");
#pragma clang diagnostic pop
}

- (NSString *)description{
    
    NSString *returnValue = [NSString stringWithFormat:@"Setting Values:\n conversations API key = %@ \n shopper marketing API key = %@ \n conversations for stores API key = %@ \n BVSDK Version = %@ \n clientId = %@ \n staging = %i \n" , self.apiKeyConversations, self.apiKeyShopperAdvertising, self.apiKeyConversationsStores, BV_SDK_VERSION, self.clientId, self.staging];
    
    return returnValue;
    
}
- (NSString *)urlRootShopperAdvertising{
    return self.staging ? @"https://my.network-stg.bazaarvoice.com" : @"https://my.network.bazaarvoice.com";
}

// SDK supports only a single client ID
-(void)setClientId:(NSString *)clientId{
    _clientId = clientId;
    [BVAnalyticEventManager sharedManager].clientId = clientId;
    [BVAnalyticEventManager sharedManager].eventSource = @"native-mobile-sdk";
}

// SDK supports only a single setting for production or stage
- (void)setStaging:(BOOL)staging{
    _staging = staging;
    [BVAnalyticsManager sharedManager].isStagingServer = staging;
}

-(void)setApiKeyShopperAdvertising:(NSString *)apiKeyShopperMarketing{
    _apiKeyShopperAdvertising = apiKeyShopperMarketing;
}

-(void)setApiKeyConversations:(NSString *)apiKeyConversations{
    _apiKeyConversations = apiKeyConversations;
}

- (void)setApiKeyConversationsStores:(NSString *)apiKeyConversationsStores{
    
    _apiKeyConversationsStores = apiKeyConversationsStores;
    NSDictionary *userInfo = @{CONVERSATIONS_STORES_API_KEY_SET_NOTIFICATION:_apiKeyConversationsStores};
    [[NSNotificationCenter defaultCenter] postNotificationName:CONVERSATIONS_STORES_API_KEY_SET_NOTIFICATION object:nil userInfo:userInfo];

}

- (void)setApiKeyLocation:(NSString *)apiKeyLocation{
    
    _apiKeyLocation = apiKeyLocation;
    NSDictionary *userInfo = @{LOCATION_API_KEY_SET_NOTIFICATION:_apiKeyLocation};
    [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_API_KEY_SET_NOTIFICATION object:nil userInfo:userInfo];
    
}

-(void)setApiKeyPIN:(NSString *)apiKeyPIN {
    
    _apiKeyPIN = apiKeyPIN;
    NSDictionary *userInfo = @{PIN_API_KEY_SET_NOTIFICATION:_apiKeyPIN};
    [[NSNotificationCenter defaultCenter] postNotificationName:PIN_API_KEY_SET_NOTIFICATION object:nil userInfo:userInfo];
    
}

-(void)setLogLevel:(BVLogLevel)logLevel {
    [[BVLogger sharedLogger] setLogLevel:logLevel];
}

#pragma mark - user

-(void)setUserWithAuthString:(NSString*)userAuthString {
    
    if(userAuthString == nil || [userAuthString length] == 0){
        [[BVLogger sharedLogger] error:@"No userAuthString was supplied for the recommendations manager!"];
        return;
    }
    
    [self setUserId:userAuthString];
}

// Update the user profile by calling the /users/ endpoint if the targeting params are empty.
-(void)updateUserProfileIfEmpty {
    [self.bvUser updateProfile:false withAPIKey:self.apiKeyShopperAdvertising isStaging:self.staging];
}


// Udpate the user profile by calling the /users/ endpoint, regardless of the current state of the targeting params
-(void)updateUserProfileForce {
    [self.bvUser updateProfile:true withAPIKey:self.apiKeyShopperAdvertising isStaging:self.staging];
}

-(void)setUserId:(NSString*)userAuthString{
    
    self.bvUser.userAuthString = userAuthString;
    
    BVPersonalizationEvent *personEvent = [[BVPersonalizationEvent alloc] initWithUserAuthenticationString:userAuthString];
    [BVPixel trackEvent:personEvent];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // try to grab the profile as soon as its available
    [self updateUserProfileForce];
    [self performSelector:@selector(updateUserProfileIfEmpty) withObject:self afterDelay:5.0];
    [self performSelector:@selector(updateUserProfileIfEmpty) withObject:self afterDelay:12.0];
    [self performSelector:@selector(updateUserProfileIfEmpty) withObject:self afterDelay:24.0];
    
}

- (BVAuthenticatedUser *)getBVAuthenticatedUser{
    return self.bvUser;
}

-(NSDictionary*)getCustomTargeting {
    
    // check that `apiKeyShopperAdvertising` is valid. Will fail only in debug mode.
    NSAssert(self.apiKeyShopperAdvertising != nil && ![self.apiKeyShopperAdvertising isEqualToString:@""], @"You must supply apiKeyShopperAdvertising in the BVSDKManager before using BVAdvertising.");
    
    return [self.bvUser getTargetingKeywords];
}

@end
