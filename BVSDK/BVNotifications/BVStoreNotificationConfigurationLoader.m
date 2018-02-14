//
//  BVStoreNotificationConfigurationLoader.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVStoreNotificationConfigurationLoader.h"
#import "BVNotificationConfiguration.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager.h"
#import "BVStoreReviewNotificationCenter.h"

@interface BVStoreNotificationConfigurationLoader ()

@end

@implementation BVStoreNotificationConfigurationLoader

+ (void)load {
  [self sharedManager];
}

+ (id)sharedManager {
  __strong static BVStoreNotificationConfigurationLoader *shared;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [[self alloc] init];
  });

  return shared;
}

- (id)init {
  if ((self = [super init])) {
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(receiveConversationsStoreAPIKey:)
               name:CONVERSATIONS_STORES_API_KEY_SET_NOTIFICATION
             object:nil];
  }

  return self;
}

- (void)receiveConversationsStoreAPIKey:(NSNotification *)notification {
  // [notification name] should always be
  // CONVERSATIONS_STORES_API_KEY_SET_NOTIFICATION
  // unless you use this method for observation of other notifications
  // as well.

  if ([[notification name]
          isEqualToString:CONVERSATIONS_STORES_API_KEY_SET_NOTIFICATION]) {
    [[BVLogger sharedLogger]
        verbose:@"Recieved notifcation for conversations stores configuration"];

    [self loadStoreNotificationConfiguration:^(
              BVStoreReviewNotificationProperties *__nonnull response) {
      // success
    }
                                     failure:^(NSError *__nonnull error){
                                         // failed
                                     }];
  }
}

- (BOOL)isClientConfiguredForPush:(BVSDKManager *)sdkMgr {
  BVStoreReviewNotificationProperties *storeNotificationProps =
      self.bvStoreReviewNotificationProperties;

  return
      [[UIApplication sharedApplication] isRegisteredForRemoteNotifications] &&
      sdkMgr.configuration.apiKeyConversationsStores &&
      sdkMgr.configuration.storeReviewContentExtensionCategory &&
      storeNotificationProps && storeNotificationProps.notificationsEnabled;
}

- (void)
loadStoreNotificationConfiguration:
    (nonnull void (^)(BVStoreReviewNotificationProperties *__nonnull response))
        completion
                           failure:(nonnull void (^)(NSError *__nonnull error))
                                       failure {
  NSURL *url = [NSURL
      URLWithString:[NSString stringWithFormat:@"%@/incubator-mobile-apps/"
                                               @"sdk/%@/ios/%@/"
                                               @"conversations-stores/"
                                               @"geofenceConfig.json",
                                               NOTIFICATION_CONFIG_ROOT,
                                               S3_API_VERSION,
                                               [BVSDKManager sharedManager]
                                                   .configuration.clientId]];
  [BVNotificationConfiguration loadGeofenceConfiguration:url
      completion:^(BVStoreReviewNotificationProperties *__nonnull response) {
        [[BVLogger sharedLogger]
            verbose:@"Successfully loaded BVStoreReviewNotificationProperties"];
        _bvStoreReviewNotificationProperties = response;
        completion(response);

      }
      failure:^(NSError *__nonnull error) {
        [[BVLogger sharedLogger]
            error:@"ERROR: Failed to load BVStoreReviewNotificationProperties"];
        failure(error);
      }];
}
@end
