//
//  BVSDKManager.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVSDKManager.h"
#import "BVAnalyticEventManager.h"
#import "BVAnalyticsManager.h"
#import "BVCommon.h"
#import "BVSDKConfiguration.h"
#import <UIKit/UIKit.h>

@interface BVSDKManager ()
@property(nonatomic, strong) BVSDKConfiguration *configuration;
@end

@implementation BVSDKManager
static NSString *const BVSDKConfigFileNameProd = @"bvsdk_config_prod";
static NSString *const BVSDKConfigFileNameStaging = @"bvsdk_config_staging";
static NSString *const BVSDKConfigFileExt = @"json";

+ (void)configure:(BVConfigurationType)configurationType {
  [[self sharedManager] attemptToLoadConfiguration:configurationType];
}

+ (void)configureWithConfiguration:(NSDictionary *)configDict
                        configType:(BVConfigurationType)configType {
  [[self sharedManager] configureWithDictionary:configDict
                                     configType:configType];
}

+ (instancetype)sharedManager {
  // structure used to test whether the block has completed or not
  static dispatch_once_t p = 0;

  // initialize sharedObject as nil (first call only)
  __strong static id _sharedObject = nil;

  // executes a block object once and only once for the lifetime of an
  // application
  dispatch_once(&p, ^{
    _sharedObject = [[self alloc] init];
  });

  // returns the same object each time
  return _sharedObject;
}

- (id)init {
  self = [super init];
  if (self) {
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
    _configuration = [[BVSDKConfiguration alloc] init];
  }
  return self;
}

- (void)attemptToLoadConfiguration:(BVConfigurationType)configType {
  NSString *fileName;
  if (configType == BVConfigurationTypeProd) {
    fileName = BVSDKConfigFileNameProd;
  } else {
    fileName = BVSDKConfigFileNameStaging;
  }

  NSString *filePath =
      [[NSBundle mainBundle] pathForResource:fileName
                                      ofType:BVSDKConfigFileExt];
  NSAssert(
      filePath,
      @"File %@.%@ could not be found in bundle. Unable to configure bundle",
      fileName, BVSDKConfigFileExt);

  if (filePath) {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    [self configureWithDictionary:json configType:configType];
  }

  [self assertConfiguration];
}

- (void)configureWithDictionary:(NSDictionary *)dict
                     configType:(BVConfigurationType)configType {
  NSMutableDictionary *config = dict.mutableCopy;
  [config setObject:@(configType == BVConfigurationTypeStaging)
             forKey:@"staging"];
  _configuration = [[BVSDKConfiguration alloc] initWithDictionary:dict
                                                       configType:configType];
  [BVAnalyticsManager sharedManager].isDryRunAnalytics =
      _configuration.dryRunAnalytics;
  [self copyJson:config toObj:self];
}

- (void)setConfiguration:(nonnull BVSDKConfiguration *)configuration {
  _configuration = configuration;
}

- (void)copyJson:(NSDictionary *)json toObj:(NSObject *)obj {
  for (NSString *key in json.allKeys) {
    if ([obj respondsToSelector:NSSelectorFromString(key)]) {
      [obj setValue:json[key] forKeyPath:key];
    }
  }
}

- (NSString *)description {
  NSString *returnValue = [NSString
      stringWithFormat:@"Setting Values:\n conversations API key = %@ \n "
                       @"shopper marketing API key = %@ \n conversations "
                       @"for stores API key = %@ \n BVSDK Version = %@ \n "
                       @"clientId = %@ \n staging = %i \n",
                       self.configuration.apiKeyConversations,
                       self.configuration.apiKeyShopperAdvertising,
                       self.configuration.apiKeyConversationsStores,
                       BV_SDK_VERSION, self.configuration.clientId,
                       self.configuration.staging];

  return returnValue;
}
- (NSString *)urlRootShopperAdvertising {
  return self.configuration.staging ? @"https://my.network-stg.bazaarvoice.com"
                                    : @"https://my.network.bazaarvoice.com";
}

// SDK supports only a single client ID
- (void)setClientId:(NSString *)clientId {
  _clientId = clientId;
  [BVAnalyticEventManager sharedManager].clientId = clientId;
  [BVAnalyticEventManager sharedManager].eventSource = @"native-mobile-sdk";
  [self assertConfiguration];
  [_configuration setValue:clientId forKeyPath:@"clientId"];
}

- (void)assertConfiguration {
  NSAssert(_clientId && 0 < _clientId.length,
           @"You must supply valid client id in the "
           @"BVSDKManager before using the Bazaarvoice "
           @"SDK.");
}

// SDK supports only a single setting for production or stage
- (void)setStaging:(BOOL)staging {
  _staging = staging;
  [BVAnalyticsManager sharedManager].isStagingServer = staging;
  [_configuration setValue:@(staging) forKeyPath:@"staging"];
}

- (void)setApiKeyShopperAdvertising:(NSString *)apiKeyShopperAdvertising {
  _apiKeyShopperAdvertising = apiKeyShopperAdvertising;
  [_configuration setValue:apiKeyShopperAdvertising
                forKeyPath:@"apiKeyShopperAdvertising"];
}

- (void)setApiKeyConversations:(NSString *)apiKeyConversations {
  _apiKeyConversations = apiKeyConversations;
  [_configuration setValue:apiKeyConversations
                forKeyPath:@"apiKeyConversations"];
}

- (void)setApiKeyConversationsStores:(NSString *)apiKeyConversationsStores {
  _apiKeyConversationsStores = apiKeyConversationsStores;
  NSDictionary *userInfo = @{
    CONVERSATIONS_STORES_API_KEY_SET_NOTIFICATION : _apiKeyConversationsStores
  };
  [[NSNotificationCenter defaultCenter]
      postNotificationName:CONVERSATIONS_STORES_API_KEY_SET_NOTIFICATION
                    object:nil
                  userInfo:userInfo];
  [_configuration setValue:apiKeyConversationsStores
                forKeyPath:@"apiKeyConversationsStores"];
}

- (void)setApiKeyLocation:(NSString *)apiKeyLocation {
  _apiKeyLocation = apiKeyLocation;
  NSDictionary *userInfo =
      @{LOCATION_API_KEY_SET_NOTIFICATION : _apiKeyLocation};
  [[NSNotificationCenter defaultCenter]
      postNotificationName:LOCATION_API_KEY_SET_NOTIFICATION
                    object:nil
                  userInfo:userInfo];
  [_configuration setValue:apiKeyLocation forKeyPath:@"apiKeyLocation"];
}

- (void)setApiKeyPIN:(NSString *)apiKeyPIN {
  _apiKeyPIN = apiKeyPIN;
  NSDictionary *userInfo = @{PIN_API_KEY_SET_NOTIFICATION : _apiKeyPIN};
  [[NSNotificationCenter defaultCenter]
      postNotificationName:PIN_API_KEY_SET_NOTIFICATION
                    object:nil
                  userInfo:userInfo];
  [_configuration setValue:apiKeyPIN forKeyPath:@"apiKeyPIN"];
}

- (void)setStoreReviewContentExtensionCategory:
    (NSString *)storeReviewContentExtensionCategory {
  _storeReviewContentExtensionCategory = storeReviewContentExtensionCategory;
  [_configuration setValue:storeReviewContentExtensionCategory
                forKeyPath:@"storeReviewContentExtensionCategory"];
}

- (void)setPINContentExtensionCategory:(NSString *)PINContentExtensionCategory {
  _PINContentExtensionCategory = PINContentExtensionCategory;
  [_configuration setValue:PINContentExtensionCategory
                forKeyPath:@"PINContentExtensionCategory"];
}

- (void)setApiKeyCurations:(NSString *)apiKeyCurations {
  _apiKeyCurations = apiKeyCurations;
  [_configuration setValue:apiKeyCurations forKeyPath:@"apiKeyCurations"];
}

- (void)setLogLevel:(BVLogLevel)logLevel {
  [[BVLogger sharedLogger] setLogLevel:logLevel];
}

#pragma mark - user

- (void)setUserWithAuthString:(NSString *)userAuthString {
  if (userAuthString && 0 < userAuthString.length) {
    [self setUserId:userAuthString];
  } else {
    [[BVLogger sharedLogger] error:@"No userAuthString was supplied for "
                                   @"the recommendations manager!"];
  }
}

// Update the user profile by calling the /users/ endpoint if the targeting
// params are empty.
- (void)updateUserProfileIfEmpty {
  [self.bvUser updateProfile:false
                  withAPIKey:self.configuration.apiKeyShopperAdvertising
                   isStaging:self.configuration.staging];
}

// Udpate the user profile by calling the /users/ endpoint, regardless of the
// current state of the targeting params
- (void)updateUserProfileForce {
  [self.bvUser updateProfile:true
                  withAPIKey:self.configuration.apiKeyShopperAdvertising
                   isStaging:self.configuration.staging];
}

- (void)setUserId:(NSString *)userAuthString {
  self.bvUser.userAuthString = userAuthString;

  BVPersonalizationEvent *personEvent = [[BVPersonalizationEvent alloc]
      initWithUserAuthenticationString:userAuthString];
  [BVPixel trackEvent:personEvent];

  [NSObject cancelPreviousPerformRequestsWithTarget:self];

  // try to grab the profile as soon as its available
  [self updateUserProfileForce];
  [self waitForProfileUpdatesByPollingWithStep:6.0f andMaxTimeInterval:24.0f];
}

- (void)waitForProfileUpdatesByPollingWithStep:(NSTimeInterval)step
                            andMaxTimeInterval:(NSTimeInterval)maxTimeInterval {

  NSTimeInterval currentStep = step;

  while (currentStep > maxTimeInterval) {
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(currentStep * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [self updateUserProfileIfEmpty];
        });

    currentStep += currentStep;
  }
}

- (BVAuthenticatedUser *)getBVAuthenticatedUser {
  return self.bvUser;
}

- (NSDictionary *)getCustomTargeting {
  NSAssert(_apiKeyShopperAdvertising && 0 < _apiKeyShopperAdvertising.length,
           @"You must supply apiKeyShopperAdvertising in the BVSDKManager.");
  return [self.bvUser getTargetingKeywords];
}

@end
