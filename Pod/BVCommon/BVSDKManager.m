//
//  BVSDKManager.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVSDKManager.h"
#import "BVCore.h"

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
    }
    return self;
}

- (NSString *)description{

    NSString *returnValue = [NSString stringWithFormat:@"Setting Values:\n conversations API key = %@ \n shopper marketing API key = %@ \n BVSDK Version = %@ \n clientId = %@ \n staging = %i \n" , self.apiKeyConversations, self.apiKeyShopperAdvertising, BV_SDK_VERSION, self.clientId, self.staging];
    
    return returnValue;
    
}
- (NSString *)urlRootShopperAdvertising{
    return self.staging ? @"https://my.network-stg.bazaarvoice.com" : @"https://my.network.bazaarvoice.com";
}

// SDK supports only a single client ID
-(void)setClientId:(NSString *)clientId{
    _clientId = clientId;
    [BVAnalyticsManager sharedManager].clientId = clientId;
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

-(void)maybeUpdateUserProfile {
    [self.bvUser updateProfile:false withAPIKey:self.apiKeyShopperAdvertising isStaging:self.staging];
}

-(void)updateUserProfileForce {
    
    NSAssert(self.apiKeyShopperAdvertising != nil, @"You must supply a Shopper Advertising key in the BVSDKManager before using the Bazaarvoice SDK.");
    NSAssert(self.clientId != nil, @"You must supply client id in the BVSDKManager before using the Bazaarvoice SDK.");
    
    [self.bvUser updateProfile:true withAPIKey:self.apiKeyShopperAdvertising isStaging:self.staging];
    
}

-(void)setUserId:(NSString*)userAuthString{
    
    self.bvUser.userAuthString = userAuthString;
    
    [[BVAnalyticsManager sharedManager] sendPersonalizationEvent:self.bvUser];
    
    // try to grab the profile as soon as its available
    [self updateUserProfileForce];
    [self performSelector:@selector(updateUserProfileForce) withObject:nil afterDelay:5.0];
    [self performSelector:@selector(updateUserProfileForce) withObject:nil afterDelay:12.0];
    [self performSelector:@selector(updateUserProfileForce) withObject:nil afterDelay:24.0];
}

- (BVAuthenticatedUser *)getBVAuthenticatedUser{
    return self.bvUser;
}


@end
