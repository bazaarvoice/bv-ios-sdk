//
//  BVSDKManager.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVAnalyticEventManager+Private.h"
#import "BVAnalyticsManager.h"
#import "BVAuthenticatedUser+Private.h"
#import "BVCommon.h"
#import "BVLogger+Private.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"
#import <UIKit/UIKit.h>

@interface BVSDKManager ()
@property(nonatomic, strong, nonnull) BVSDKConfiguration *internalConfiguration;
@property(nonatomic, strong) dispatch_queue_t urlSessionDelegateQueue;
@property(nonnull, nonatomic, strong) NSString *clientId;
@property(nonatomic, assign) BOOL staging;
@property(nonnull, nonatomic, strong) NSString *apiKeyConversations;
@property(nonnull, nonatomic, strong) NSString *apiKeyConversationsStores;
@property(nonnull, nonatomic, strong) NSString *apiKeyPIN;
@property(nonnull, nonatomic, strong)
    NSString *storeReviewContentExtensionCategory;
@property(nonnull, nonatomic, strong) NSString *PINContentExtensionCategory;
@property(nonnull, nonatomic, strong) NSString *apiKeyShopperAdvertising;
@property(nonnull, nonatomic, strong) NSString *apiKeyCurations;
@end

@implementation BVSDKManager

static NSString *const BVSDKConfigFileNameProd = @"bvsdk_config_prod";
static NSString *const BVSDKConfigFileNameStaging = @"bvsdk_config_staging";
static NSString *const BVSDKConfigFileExt = @"json";

@synthesize urlSessionDelegate = _urlSessionDelegate,
            urlSessionDelegateQueue = _urlSessionDelegateQueue;

- (BVSDKConfiguration *)configuration {
  return _internalConfiguration;
}

- (nullable id<BVURLSessionDelegate>)urlSessionDelegate {
  __block id<BVURLSessionDelegate> tempDelegate = nil;
  dispatch_sync(self.urlSessionDelegateQueue, ^{
    tempDelegate = self->_urlSessionDelegate;
  });
  return tempDelegate;
}

- (void)setUrlSessionDelegate:
    (nullable id<BVURLSessionDelegate>)urlSessionDelegate {
  dispatch_sync(self.urlSessionDelegateQueue, ^{
    self->_urlSessionDelegate = urlSessionDelegate;
  });
}

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

- (instancetype)init {
  if ((self = [super init])) {
    _bvUser = [[BVAuthenticatedUser alloc] init];

    // make sure analytics has been started
    [BVAnalyticsManager sharedManager];
      

    _urlSessionDelegateQueue = dispatch_queue_create(
        "com.bazaarvoice.BVSDKManager.urlSessionDelegateQueue",
        DISPATCH_QUEUE_SERIAL);

    _timeout = 60;
    _staging = NO;
    _clientId = nil;
    _apiKeyConversations = nil;
    _apiKeyShopperAdvertising = nil;
    _apiKeyConversationsStores = nil;
    _internalConfiguration = [[BVSDKConfiguration alloc] init];
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
  _internalConfiguration =
      [[BVSDKConfiguration alloc] initWithDictionary:dict
                                          configType:configType];
  [BVAnalyticsManager sharedManager].isDryRunAnalytics =
      _internalConfiguration.dryRunAnalytics;

  /// Handle Analytics Locale Configuration
  NSLocale *analyticsLocale = nil;
  NSString *analyticsLocaleIdentifier =
      _internalConfiguration.analyticsLocaleIdentifier;

  if (analyticsLocaleIdentifier) {
    analyticsLocale =
        [[NSLocale alloc] initWithLocaleIdentifier:analyticsLocaleIdentifier];
  } else {
    BVLogWarning(
        ([NSString stringWithFormat:@"BVSDK is currently using user region "
                                    @"settings. Please see the documentation "
                                    @"regarding setting proper locale settings "
                                    @"for dealing with user data privacy."]),
        BV_PRODUCT_COMMON);
  }

  [BVAnalyticsManager sharedManager].analyticsLocale = analyticsLocale;

  [self copyJson:config toObj:self];
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
  [_internalConfiguration setValue:clientId forKeyPath:@"clientId"];
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
  [BVAnalyticsManager sharedManager].isStagingServer =
      [NSNumber numberWithBool:staging];
  [_internalConfiguration setValue:@(staging) forKeyPath:@"staging"];
}

- (void)setApiKeyShopperAdvertising:(NSString *)apiKeyShopperAdvertising {
  _apiKeyShopperAdvertising = apiKeyShopperAdvertising;
  [_internalConfiguration setValue:apiKeyShopperAdvertising
                        forKeyPath:@"apiKeyShopperAdvertising"];
}

- (void)setApiKeyConversations:(NSString *)apiKeyConversations {
  _apiKeyConversations = apiKeyConversations;
  [_internalConfiguration setValue:apiKeyConversations
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
  [_internalConfiguration setValue:apiKeyConversationsStores
                        forKeyPath:@"apiKeyConversationsStores"];
}

- (void)setApiKeyPIN:(NSString *)apiKeyPIN {
  _apiKeyPIN = apiKeyPIN;
  NSDictionary *userInfo = @{PIN_API_KEY_SET_NOTIFICATION : _apiKeyPIN};
  [[NSNotificationCenter defaultCenter]
      postNotificationName:PIN_API_KEY_SET_NOTIFICATION
                    object:nil
                  userInfo:userInfo];
  [_internalConfiguration setValue:apiKeyPIN forKeyPath:@"apiKeyPIN"];
}

- (void)setStoreReviewContentExtensionCategory:
    (NSString *)storeReviewContentExtensionCategory {
  _storeReviewContentExtensionCategory = storeReviewContentExtensionCategory;
  [_internalConfiguration setValue:storeReviewContentExtensionCategory
                        forKeyPath:@"storeReviewContentExtensionCategory"];
}

- (void)setPINContentExtensionCategory:(NSString *)PINContentExtensionCategory {
  _PINContentExtensionCategory = PINContentExtensionCategory;
  [_internalConfiguration setValue:PINContentExtensionCategory
                        forKeyPath:@"PINContentExtensionCategory"];
}

- (void)setApiKeyCurations:(NSString *)apiKeyCurations {
  _apiKeyCurations = apiKeyCurations;
  [_internalConfiguration setValue:apiKeyCurations
                        forKeyPath:@"apiKeyCurations"];
}

- (void)setLogLevel:(BVLogLevel)logLevel {
  [[BVLogger sharedLogger] setLogLevel:logLevel];
}

#pragma mark - user

- (void)setUserWithAuthString:(NSString *)userAuthString {
  if (userAuthString && 0 < userAuthString.length) {
    [self setUserId:userAuthString];
  } else {
    BVLogError(
        @"No userAuthString was supplied for the recommendations manager!",
        BV_PRODUCT_COMMON);
  }
}

- (void)setUserId:(NSString *)userAuthString {
  self.bvUser.userAuthString = userAuthString;

  BVPersonalizationEvent *personEvent = [[BVPersonalizationEvent alloc]
      initWithUserAuthenticationString:userAuthString];
  [BVPixel trackEvent:personEvent];

  [NSObject cancelPreviousPerformRequestsWithTarget:self];

}


- (BVAuthenticatedUser *)getBVAuthenticatedUser {
  return self.bvUser;
}

- (NSDictionary *)getCustomTargeting {
    return  nil;
}

@end
