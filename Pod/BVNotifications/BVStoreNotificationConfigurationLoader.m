//
//  BVStoreNotificationConfigurationLoader.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//


#import "BVStoreNotificationConfigurationLoader.h"
#import "BVNotificationConfiguration.h"
#import "BVLocationManager.h"
#import "BVPlaceAttributes.h"
#import "BVVisit.h"
#import "BVSDKManager.h"
#import "BVStoreReviewNotificationCenter.h"
#import "BVSDKConfiguration.h"

@interface BVStoreNotificationConfigurationLoader()<BVLocationManagerDelegate>

@end

@implementation BVStoreNotificationConfigurationLoader

+(void)load{
    [self sharedManager];
}

+(id)sharedManager {
    static BVStoreNotificationConfigurationLoader *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    
    return shared;
}

- (id)init {
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveConversationsStoreAPIKey:)
                                                     name:CONVERSATIONS_STORES_API_KEY_SET_NOTIFICATION
                                                   object:nil];
        
        [BVLocationManager registerForLocationUpdates:self];
    }
    
    return self;
}


- (void) receiveConversationsStoreAPIKey:(NSNotification *) notification
{    
    // [notification name] should always be CONVERSATIONS_STORES_API_KEY_SET_NOTIFICATION
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:CONVERSATIONS_STORES_API_KEY_SET_NOTIFICATION]){
        
        [[BVLogger sharedLogger] verbose:@"Recieved notifcation for conversations stores configuration"];
        
        [self loadStoreNotificationConfiguration:^(BVStoreReviewNotificationProperties * _Nonnull response) {
            // success
        } failure:^(NSError * _Nonnull error) {
            // failed
        }];
        
    }
}

-(BOOL)isClientConfiguredForPush:(BVSDKManager *)sdkMgr {
    
    BVStoreReviewNotificationProperties *storeNotificationProps = self.bvStoreReviewNotificationProperties;
    
    return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications] &&
    sdkMgr.configuration.apiKeyConversationsStores &&
    sdkMgr.configuration.storeReviewContentExtensionCategory &&
    storeNotificationProps &&
    storeNotificationProps.notificationsEnabled;
}



-(void)loadStoreNotificationConfiguration:(void (^ _Nonnull)(BVStoreReviewNotificationProperties * _Nonnull response))completion failure:(void (^ _Nonnull)(NSError * _Nonnull error))failure {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/incubator-mobile-apps/sdk/%@/ios/%@/conversations-stores/geofenceConfig.json", NOTIFICATION_CONFIG_ROOT, S3_API_VERSION, [BVSDKManager sharedManager].configuration.clientId]];
    [BVNotificationConfiguration loadGeofenceConfiguration:url completion:^(BVStoreReviewNotificationProperties * _Nonnull response) {
        [[BVLogger sharedLogger] verbose:@"Successfully loaded BVStoreReviewNotificationProperties"];
        _bvStoreReviewNotificationProperties = response;
        completion(response);
        
    } failure:^(NSError * _Nonnull error) {
        [[BVLogger sharedLogger] error:@"ERROR: Failed to load BVStoreReviewNotificationProperties"];
        failure(error);
    }];
    
}

#pragma mark BVLocationManagerDelegate
-(void)didBeginVisit:(BVVisit* _Nonnull)visit {
    [self receiveStoreVisitNotification:visit];
}


-(void)didEndVisit:(BVVisit* _Nonnull)visit {
    [self receiveStoreVisitNotification:visit];
}

- (void) receiveStoreVisitNotification:(BVVisit * )visit {
    BVSDKManager *sdkMgr = [BVSDKManager sharedManager];
    if ([self isClientConfiguredForPush:sdkMgr])
    {
        // Check and make sure the visit time has been met before trying to queue a notification
        BVStoreReviewNotificationProperties *noteProps = [[BVStoreNotificationConfigurationLoader sharedManager] bvStoreReviewNotificationProperties];
        
        NSTimeInterval visitDuration = [visit.departureDate timeIntervalSinceDate:visit.arrivalDate];
        
        if (visitDuration >= noteProps.visitDuration){
            
            // queue up the notification....
            [[BVStoreReviewNotificationCenter sharedCenter] queueReviewWithStoreId:visit.storeId];
            
        } else {
            
            [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"Vist time of %f, not long enough to post notification. Need %f seconds.", visitDuration, noteProps.visitDuration]];
        }
    }
    
}
@end
